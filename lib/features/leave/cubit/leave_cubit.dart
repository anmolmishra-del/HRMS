import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/core/utils/shared_pref.dart';
import 'package:flutter_app/network/odoo_service.dart';
import 'package:flutter_app/features/leave/cubit/leave_state.dart';
import 'package:flutter_app/features/leave/models/leave_model.dart';
import 'package:flutter_app/features/leave/models/leave_type_model.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class LeaveCubit extends Cubit<LeaveState> {
  LeaveCubit() : super(const LeaveState());

  void clearData() {
    emit(const LeaveState());
  }

  Future<void> fetchLeavesAndTypes() async {
    if (isClosed) return;
    emit(state.copyWith(status: LeaveStatus.loading));
    final prefs = SharedPref();
    final baseUrl = await prefs.getString('baseUrl');
    final employeeData = await prefs.getObject('employee_data');
    final sessionObj = await prefs.getObject('session');

    if (baseUrl == null || employeeData == null || sessionObj == null) {
      if (!isClosed) emit(state.copyWith(status: LeaveStatus.failure, errorMessage: "Session expired"));
      return;
    }

    final session = OdooSession.fromJson(sessionObj);
    final employeeId = int.tryParse(employeeData['id']?.toString() ?? '0') ?? 0;
    final odooService = OdooService(baseUrl, session: session);

    try {
      final results = await Future.wait([
        odooService.fetchMyLeaves(employeeId),
        odooService.fetchLeaveTypes(employeeId: employeeId),
      ]);
// ...

      final leaves = (results[0] as List).map((l) => LeaveRequest.fromJson(l)).toList();
      final types = (results[1] as List).map((t) => LeaveType.fromJson(t)).toList();

      if (!isClosed) {
        emit(state.copyWith(
          status: LeaveStatus.success,
          leaves: leaves,
          leaveTypes: types,
        ));
      }
    } catch (e, stackTrace) {
      debugPrint('LeaveCubit ERROR: $e');
      if (!isClosed) {
        emit(state.copyWith(
          status: LeaveStatus.failure,
          errorMessage: _getErrorMessage(e),
        ));
      }
    } finally {
      odooService.close();
    }
  }

  Future<void> applyLeave(Map<String, dynamic> data) async {
    if (isClosed) return;
    emit(state.copyWith(status: LeaveStatus.submitting));
    final prefs = SharedPref();
    final baseUrl = await prefs.getString('baseUrl');
    final sessionObj = await prefs.getObject('session');
    
    if (baseUrl == null || sessionObj == null) {
      if (!isClosed) emit(state.copyWith(status: LeaveStatus.failure, errorMessage: "Session expired"));
      return;
    } 

    final session = OdooSession.fromJson(sessionObj);
    final odooService = OdooService(baseUrl, session: session);

    try {
      // 1. Client-side duplicate / overlap validation check
      final reqStartStr = data['request_date_from']?.toString();
      final reqEndStr = data['request_date_to']?.toString();
      if (reqStartStr != null && reqEndStr != null) {
        final reqStart = DateTime.parse(reqStartStr);
        final reqEnd = DateTime.parse(reqEndStr);
        
        final checkStart = DateTime(reqStart.year, reqStart.month, reqStart.day);
        final checkEnd = DateTime(reqEnd.year, reqEnd.month, reqEnd.day);

        final hasOverlap = state.leaves.any((leave) {
          if (leave.state == 'refuse' || leave.state == 'cancel') return false;
          if (leave.requestDateFrom == null || leave.requestDateTo == null) return false;

          final leaveStart = DateTime(leave.requestDateFrom!.year, leave.requestDateFrom!.month, leave.requestDateFrom!.day);
          final leaveEnd = DateTime(leave.requestDateTo!.year, leave.requestDateTo!.month, leave.requestDateTo!.day);

          return (checkStart.isBefore(leaveEnd.add(const Duration(days: 1))) &&
                  checkEnd.isAfter(leaveStart.subtract(const Duration(days: 1))));
        });

        if (hasOverlap) {
          if (!isClosed) {
            emit(state.copyWith(
              status: LeaveStatus.failure,
              errorMessage: "You have already applied for a leave or LOP on this date.",
            ));
          }
          return;
        }
      }

      // 2. Add 'state': 'draft' to the payload to ensure it is created in the draft stage
      final requestData = Map<String, dynamic>.from(data);
      requestData['state'] = 'draft';

      final leaveId = await odooService.createLeaveRequest(requestData);
      if (leaveId > 0) {
        // Created directly in draft stage - no need to call action_draft
        if (!isClosed) {
          emit(state.copyWith(
            status: LeaveStatus.submitted,
            successMessage: "Leave request created in Draft stage successfully",
          ));
        }
        
        await fetchLeavesAndTypes();
      } else {
        throw Exception("Failed to create leave request");
      }
    } catch (e, stackTrace) {
      debugPrint('LeaveCubit ERROR: $e');
      if (!isClosed) {
        emit(state.copyWith(
          status: LeaveStatus.failure,
          errorMessage: _getErrorMessage(e),
        ));
      }
    } finally {
      odooService.close();
    }
  }

  Future<void> cancelLeave(int leaveId) async {
    if (isClosed) return;
    final prefs = SharedPref();
    final baseUrl = await prefs.getString('baseUrl');
    final sessionObj = await prefs.getObject('session');
    
    if (baseUrl == null || sessionObj == null) {
      return;
    }

    final session = OdooSession.fromJson(sessionObj);
    final odooService = OdooService(baseUrl, session: session);
    try {
      await odooService.executeLeaveAction(leaveId, 'action_cancel');
      // Increased delay to let server process the state change before refreshing
      await Future.delayed(const Duration(milliseconds: 1000));
      await fetchLeavesAndTypes();
    } catch (e, stackTrace) {
      debugPrint('LeaveCubit ERROR: $e');
      if (!isClosed) {
        emit(state.copyWith(
          status: LeaveStatus.failure,
          errorMessage: _getErrorMessage(e),
        ));
      }
    } finally {
      odooService.close();
    }
  }

  Future<void> deleteLeave(int leaveId) async {
    if (isClosed) return;
    final prefs = SharedPref();
    final baseUrl = await prefs.getString('baseUrl');
    final sessionObj = await prefs.getObject('session');
    
    if (baseUrl == null || sessionObj == null) return;

    final session = OdooSession.fromJson(sessionObj);
    final odooService = OdooService(baseUrl, session: session);
    try {
      debugPrint('LeaveCubit: Deleting (unlink) leaveId=$leaveId');
      await odooService.executeModelMethod('hr.leave', 'unlink', [[leaveId]]);
      await fetchLeavesAndTypes();
    } catch (e) {
      debugPrint('LeaveCubit ERROR: $e');
      if (!isClosed) {
        emit(state.copyWith(
          status: LeaveStatus.failure,
          errorMessage: _getErrorMessage(e),
        ));
      }
    } finally {
      odooService.close();
    }
  }

  Future<void> submitLeave(int leaveId) async {
    if (isClosed) return;
    final prefs = SharedPref();
    final baseUrl = await prefs.getString('baseUrl');
    final sessionObj = await prefs.getObject('session');
    
    if (baseUrl == null || sessionObj == null) {
      if (!isClosed) emit(state.copyWith(status: LeaveStatus.failure, errorMessage: "Session expired"));
      return;
    }

    final session = OdooSession.fromJson(sessionObj);
    final odooService = OdooService(baseUrl, session: session);

    try {
      if (!isClosed) emit(state.copyWith(status: LeaveStatus.submitting));
      // According to Odoo custom module tooltip, action_draft transitions the leave to To Approve
      await odooService.executeLeaveAction(leaveId, 'action_draft');
      
      if (!isClosed) {
        emit(state.copyWith(
          status: LeaveStatus.submitted,
          successMessage: "Leave request submitted successfully",
        ));
      }
      
      await fetchLeavesAndTypes();
    } catch (e) {
      debugPrint('LeaveCubit Submit ERROR: $e');
      if (!isClosed) {
        emit(state.copyWith(
          status: LeaveStatus.failure,
          errorMessage: _getErrorMessage(e),
        ));
      }
    } finally {
      odooService.close();
    }
  }

  String _getErrorMessage(Object e) {
    if (e is OdooException) {
      try {
        final data = e.error;
        if (data is Map && data['message'] != null) {
          return data['message'].toString();
        }
      } catch (_) {}
      return e.message;
    }
    return e.toString();
  }

  void clearMessages() {
    emit(state.copyWith(errorMessage: null, successMessage: null));
  }
}
