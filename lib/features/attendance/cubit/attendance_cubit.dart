import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/core/utils/shared_pref.dart';
import 'package:flutter_app/network/odoo_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:odoo_rpc/odoo_rpc.dart';
import 'attendance_state.dart';

/// Cubit for managing the active check-in/check-out state and timer.
class AttendanceCubit extends Cubit<AttendanceState> {
  Timer? _ticker;
  DateTime? _currentCheckInTime;

  AttendanceCubit() : super(const AttendanceState());

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }

  /// Loads the initial attendance status from the server.
  Future<void> loadInitialStatus() async {
    emit(state.copyWith(status: AttendanceStatus.loading));
    
    final prefs = SharedPref();
    final sobj = await prefs.getObject('session');
    var baseUrl = await prefs.getString('baseUrl');
    final employeeData = await prefs.getObject('employee_data');

    if (sobj == null || baseUrl == null || employeeData == null) {
      emit(state.copyWith(status: AttendanceStatus.failure, errorMessage: "Session expired"));
      return;
    }

    final session = OdooSession.fromJson(sobj);
    final odooService = OdooService(baseUrl, session: session);
    
    final rawEmpId = employeeData['id'];
    final int empId = rawEmpId is int ? rawEmpId : int.parse(rawEmpId.toString());

    try {
      debugPrint('AttendanceCubit: Loading initial status for empId=$empId');
      // Check if there is an active (unclosed) attendance record
      final checkInStatus = await odooService.executeModelMethod(
        'hr.attendance',
        'search_read',
        [],
        kwargs: {
          'domain': [
            ['employee_id', '=', empId],
            ['check_in', '!=', false],
            ['check_out', '=', false]
          ],
          'fields': ['id', 'check_in'],
        },
      );

      final isCheckedIn = checkInStatus != null && (checkInStatus as List).isNotEmpty;
      if (isCheckedIn) {
        String lastCheckInStr = checkInStatus[0]['check_in'];
        // Format the date string for parsing
        if (!lastCheckInStr.endsWith('Z')) {
          lastCheckInStr = '${lastCheckInStr.replaceAll(' ', 'T')}Z';
        }
        _currentCheckInTime = DateTime.parse(lastCheckInStr).toLocal();
      } else {
        _currentCheckInTime = null;
      }
      
      // Fetch base hours (completed sessions today)
      final baseHours = await _fetchBaseHours(odooService, empId);

      // Fetch weekly hours
      final baseWeekly = await _fetchWeeklyHours(odooService, empId);

      // Calculate live weekly hours
      List<double> liveWeekly = List.from(baseWeekly);
      if (isCheckedIn) {
        int todayIndex = DateTime.now().weekday - 1;
        if (todayIndex >= 0 && todayIndex < 7) {
          liveWeekly[todayIndex] += _calculateCurrentSessionHours();
        }
      }

      emit(state.copyWith(
        status: AttendanceStatus.success,
        isCheckedIn: isCheckedIn,
        baseHours: baseHours,
        todayHours: _formatHours(baseHours + _calculateCurrentSessionHours()),
        baseWeeklyHours: baseWeekly,
        weeklyHours: liveWeekly,
      ));

      _startTicker(); // Always start ticker to keep UI clock updated
    } catch (e) {
      debugPrint('AttendanceCubit: Error loading status: $e');
      emit(state.copyWith(status: AttendanceStatus.failure, errorMessage: e.toString()));
    }
  }

  /// Starts a periodic timer to update the displayed working hours and UI clock every second.
  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isClosed) {
        final currentSessionHours = _calculateCurrentSessionHours();
        final totalHours = state.baseHours + currentSessionHours;

        List<double> liveWeekly = List.from(state.baseWeeklyHours);
        if (state.isCheckedIn) {
          int todayIndex = DateTime.now().weekday - 1;
          if (todayIndex >= 0 && todayIndex < 7) {
            liveWeekly[todayIndex] += currentSessionHours;
          }
        }

        emit(state.copyWith(
          todayHours: _formatHours(totalHours),
          weeklyHours: liveWeekly,
          clearSuccess: true,
          clearError: true,
        ));
      } else {
        timer.cancel();
      }
    });
  }

  /// Clears success and error messages from the state.
  void clearMessages() {
    emit(state.copyWith(clearSuccess: true, clearError: true));
  }

  /// Calculates the hours elapsed in the current active session.
  double _calculateCurrentSessionHours() {
    if (_currentCheckInTime == null) return 0.0;
    final duration = DateTime.now().difference(_currentCheckInTime!);
    return duration.inSeconds / 3600.0;
  }

  /// Formats double hours into "HH:mm" clock format.
  String _formatHours(double hours) {
    if (hours < 0) hours = 0;
    final int h = hours.floor();
    final int m = ((hours - h) * 60).round();
    
    final int finalH = h + (m == 60 ? 1 : 0);
    final int finalM = m == 60 ? 0 : m;

    final String hourStr = finalH.toString().padLeft(2, '0');
    final String minuteStr = finalM.toString().padLeft(2, '0');
    
    return '$hourStr:$minuteStr';
  }

  /// Fetches the sum of worked hours from already closed sessions for today.
  Future<double> _fetchBaseHours(OdooService odooService, int empId) async {
    DateTime now = DateTime.now();
    DateTime todayStart = DateTime(now.year, now.month, now.day);
    DateTime todayEnd = todayStart.add(const Duration(days: 1));

    final finishedRecords = await odooService.executeModelMethod(
      'hr.attendance',
      'search_read',
      [],
      kwargs: {
        'domain': [
          ['employee_id', '=', empId],
          ['check_in', '>=', _toUtcOdooString(todayStart)],
          ['check_in', '<', _toUtcOdooString(todayEnd)],
          ['check_out', '!=', false],
        ],
        'fields': ['worked_hours'],
      },
    );

    double total = 0.0;
    if (finishedRecords != null) {
      for (var record in (finishedRecords as List)) {
        total += (record['worked_hours'] ?? 0.0).toDouble();
      }
    }
    return total;
  }

  /// Toggles between check-in and check-out.
  Future<void> toggleAttendance() async { 
    final currentlyCheckedIn = state.isCheckedIn;
    _ticker?.cancel();
    emit(state.copyWith(status: AttendanceStatus.loading));

    final prefs = SharedPref();
    final sobj = await prefs.getObject('session');
    var baseUrl = await prefs.getString('baseUrl');
    final employeeData = await prefs.getObject('employee_data');

    if (baseUrl == null || sobj == null || employeeData == null) {
      emit(state.copyWith(status: AttendanceStatus.failure, errorMessage: "Session info missing"));
      return;
    }

    final session = OdooSession.fromJson(sobj);
    final odooService = OdooService(baseUrl, session: session);
    final rawEmpId = employeeData['id'];
    final int empId = rawEmpId is int ? rawEmpId : int.parse(rawEmpId.toString());

    try {
      // Capture GPS location first (MANDATORY)
      final Position position = await _getCurrentPosition();
      
      // Capture device IP (optional timeout)
      final String ipAddress = await _getIpAddress().timeout(const Duration(seconds: 5), onTimeout: () => "0.0.0.0");
      
      // Perform the check-in/out action on the server
      await odooService.mobileCheckInOut(
        employeeId: empId,
        isCheckIn: currentlyCheckedIn, 
        longitude: position.longitude,
        latitude: position.latitude,
        ipAddress: ipAddress,
      );

      // Local state update
      if (!currentlyCheckedIn) {
        _currentCheckInTime = DateTime.now();
      } else {
        _currentCheckInTime = null;
      }

      final baseHours = await _fetchBaseHours(odooService, empId);
      final baseWeekly = await _fetchWeeklyHours(odooService, empId);

      List<double> liveWeekly = List.from(baseWeekly);
      if (!currentlyCheckedIn) {
        int todayIndex = DateTime.now().weekday - 1;
        if (todayIndex >= 0 && todayIndex < 7) {
          liveWeekly[todayIndex] += _calculateCurrentSessionHours();
        }
      }

      final successMsg = currentlyCheckedIn ? "Checked out successfully" : "Checked in successfully";

      emit(state.copyWith(
        status: AttendanceStatus.success,
        isCheckedIn: !currentlyCheckedIn,
        baseHours: baseHours,
        todayHours: _formatHours(baseHours + _calculateCurrentSessionHours()),
        baseWeeklyHours: baseWeekly,
        weeklyHours: liveWeekly,
        successMessage: successMsg,
      ));

      if (!currentlyCheckedIn) {
        _startTicker();
      }
    } catch (e) {
      debugPrint('AttendanceCubit Toggle Error: $e');
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      emit(state.copyWith(status: AttendanceStatus.failure, errorMessage: errorMsg));
    }
  }

  /// Retrieves the public IP address of the device.
  Future<String> _getIpAddress() async {
    try {
      final response = await http
          .get(Uri.parse('https://api.ipify.org?format=json'))
          .timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['ip'];
      }
    } catch (e) {
      debugPrint('AttendanceCubit: IP fetch failed or timed out');
    }
    return "0.0.0.0";
  }

  /// Requests location permissions and retrieves the current GPS coordinates.
  /// Throws an error string if permission is denied.
  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled. Please enable GPS in your device settings to check in/out.';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permission is required to check in/out. Please grant permission when asked.';
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied. Please enable them in your phone settings to use attendance.';
    }

    try {
      // Try to get last known position first for near-instant response
      final lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) return lastKnown;

      // Fallback to current position with a strict time limit
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      throw 'Failed to acquire GPS location. Please make sure you are in a clear area and try again.';
    }
  }

  /// Fetches weekly attendance records from Odoo (Monday to Sunday)
  Future<List<double>> _fetchWeeklyHours(OdooService odooService, int empId) async {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday; // Monday is 1, Sunday is 7
    DateTime monday = DateTime(now.year, now.month, now.day).subtract(Duration(days: currentWeekday - 1));
    DateTime nextMonday = monday.add(const Duration(days: 7));

    try {
      final weeklyRecords = await odooService.executeModelMethod(
        'hr.attendance',
        'search_read',
        [],
        kwargs: {
          'domain': [
            ['employee_id', '=', empId],
            ['check_in', '>=', _toUtcOdooString(monday)],
            ['check_in', '<', _toUtcOdooString(nextMonday)]
          ],
          'fields': ['check_in', 'worked_hours'],
        },
      );

      List<double> weekHours = List.filled(7, 0.0);
      if (weeklyRecords != null && weeklyRecords is List) {
        for (var rec in weeklyRecords) {
          if (rec['check_in'] != null) {
            String checkInStr = rec['check_in'];
            if (!checkInStr.endsWith('Z')) {
              checkInStr = '${checkInStr.replaceAll(' ', 'T')}Z';
            }
            DateTime checkIn = DateTime.parse(checkInStr).toLocal();
            int dayIndex = checkIn.weekday - 1; // Monday is 0, Sunday is 6
            if (dayIndex >= 0 && dayIndex < 7) {
              double hours = 0.0;
              if (rec['worked_hours'] != null) {
                hours = double.tryParse(rec['worked_hours'].toString()) ?? 0.0;
              }
              weekHours[dayIndex] += hours;
            }
          }
        }
      }
      return weekHours;
    } catch (e) {
      debugPrint('AttendanceCubit: Error fetching weekly hours: $e');
      return List.filled(7, 0.0);
    }
  }

  /// Converts a local DateTime to a UTC string format expected by Odoo
  String _toUtcOdooString(DateTime localDateTime) {
    return localDateTime.toUtc().toIso8601String().replaceAll('T', ' ').substring(0, 19);
  }
}
