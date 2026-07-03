// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_app/ats/utils/shared_ref.dart';
// import 'package:flutter_app/ats/core/services/odoo_service.dart';
// import 'package:flutter_app/ats/core/constants/api_config.dart';
// import 'package:flutter_app/ats/features/dashboard/repository/service.dart';
// import '../state/dashboard_state.dart';

// class DashboardCubit extends Cubit<DashboardState> {
//   DashboardCubit()
//       : super(
//           DashboardState.initial(),
//         ) {
//     print("DASHBOARD CUBIT CREATED");

//     loadDashboard();
//   }

//   // final repository = DashboardRepository();

//   void changeFilter(String value) {
//     emit(
//       state.copyWith(
//         selectedFilter: value,
//       ),
//     );
//   }

//   Future<void> loadDashboard() async {
//     print("[DashboardCubit] loadDashboard() started.");
//     emit(
//       state.copyWith(
//         isLoading: true,
//         error: null,
//       ),
//     );

//     try {
//       final prefs = SharedPref();
//       final userData = await prefs.getObject('user_profile');
//       String name = "Recruiter";
//       if (userData != null && userData is Map && userData.isNotEmpty) {
//         name = userData['name']?.toString() ?? "Recruiter";
//       }

//       final service = OdooService(ApiConfig.baseUrl);
//       await service.ensureSession();

//       // 1. Get valid fields for hr.candidate dynamically to prevent Odoo ValueError
//       Map<String, dynamic>? candidateFieldsInfo;
//       try {
//         final rawFields = await service.executeModelMethod(
//           'hr.candidate',
//           'fields_get',
//           [],
//           kwargs: {'attributes': ['type']},
//         );
//         if (rawFields is Map) {
//           candidateFieldsInfo = Map<String, dynamic>.from(rawFields);
//         }
//       } catch (fe) {
//         print("[DashboardCubit] fields_get failed for hr.candidate: $fe");
//       }


//       final List<String> activeCandFields = ['id'];
//       if (candidateFieldsInfo != null && candidateFieldsInfo.containsKey('stage_id')) {
//         activeCandFields.add('stage_id');
//       }

//       print("[DashboardCubit] Querying hr.candidate records for funnel stats with fields $activeCandFields...");
//       final candidatesRes = await service.executeModelMethod(
//         'hr.candidate',
//         'search_read',
//         [[]],
//         kwargs: {
//           'fields': activeCandFields,
//         },
//       );

//       // 2. Fetch Jobs (hr.job) to compute open positions
//       print("[DashboardCubit] Querying hr.job records for positions stats...");
//       final jobsRes = await service.executeModelMethod(
//         'hr.job',
//         'search_read',
//         [[]],
//         kwargs: {
//           'fields': ['id'],
//         },
//       );

//       int totalCandidates = 0;
//       int openPositions = 0;
      
//       int appliedCount = 0;
//       int screeningCount = 0;
//       int interviewCount = 0;
//       int offerCount = 0;
//       int hiredCount = 0;
//       int rejectedCount = 0;

//       if (jobsRes is List) {
//         openPositions = jobsRes.length;
//       }

//       if (candidatesRes is List) {
//         totalCandidates = candidatesRes.length;
//         for (var c in candidatesRes) {
//           final stageVal = c['stage_id'];
//           final stageName = stageVal is List && stageVal.length > 1 
//               ? stageVal[1].toString().toLowerCase() 
//               : 'applied';
          
//           if (stageName.contains('screening')) {
//             screeningCount++;
//           } else if (stageName.contains('interview') || stageName.contains('tech') || stageName.contains('hr')) {
//             interviewCount++;
//           } else if (stageName.contains('offer')) {
//             offerCount++;
//           // } else if (stageName.contains('hired') || stageName.contains('joined')) {
//           //   hiredCount++;
//           // } else if (stageName.contains('rejected') || stageName.contains('refused') || stageName.contains('cancel')) {
//           //   rejectedCount++;
//           // } else {
//           //   appliedCount++;
//           }
//         }
//       }

//       // Map statistics to the DashboardState lists:
//       // Index mappings:
//       // 0: Open Positions
//       // 1: New Applications (total candidates)
//       // 2: Interviews Today
//       // 3: Offers Pending
//       // 4: Hired This Month
//       // 5: Rejected
//       final counts = [
//         openPositions,
//         totalCandidates,
//         interviewCount,
//         offerCount,
//         hiredCount,
//         rejectedCount,
//       ];

//       // Funnel mapping (Applied, Screening, Interview, Offer, Hired)
//       final chartValues = [
//         appliedCount.toDouble(),
//         screeningCount.toDouble(),
//         interviewCount.toDouble(),
//         offerCount.toDouble(),
//         hiredCount.toDouble(),
//       ];

//       emit(
//         state.copyWith(
//           isLoading: false,
//           name: name,
//           counts: counts,
//           chartValues: chartValues,
//           recentApplications: [],
//           recentCandidates: [],
//           error: null,
//         ),
//       );
//       print("[DashboardCubit] loadDashboard() completed successfully.");
//     } catch (e) {
//       print("[DashboardCubit] Error: $e");
//       emit(
//         state.copyWith(
//           isLoading: false,
//           recentApplications: [],
//           recentCandidates: [],
//           error: e.toString(),
//         ),
//       );
//     }
//   }

//   void refreshDashboard() {
//     loadDashboard();
//   }
// }
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/utils/shared_ref.dart';
import 'package:flutter_app/ats/core/services/odoo_service.dart';
import 'package:flutter_app/ats/core/constants/api_config.dart';
import '../state/dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit()
      : super(
          DashboardState.initial(),
        ) {
    loadDashboard();
  }

  void changeFilter(String value) {
    emit(
      state.copyWith(
        selectedFilter: value,
      ),
    );
  }

  Future<void> loadDashboard() async {
    emit(
      state.copyWith(
        isLoading: true,
        error: null,
      ),
    );

    try {
      final prefs = SharedPref();
      final userData =
          await prefs.getObject(
        'user_profile',
      );

      String name = "Recruiter";

      if (userData != null &&
          userData is Map &&
          userData.isNotEmpty) {
        name =
            userData['name']
                    ?.toString() ??
                "Recruiter";
      }

      final service =
          OdooService(ApiConfig.baseUrl);

      await service.ensureSession();

      /// OPEN POSITIONS
      dynamic jobsRes;
      try {
        jobsRes = await service.executeModelMethod(
          'hr.job',
          'search_read',
          [[]],
          kwargs: {
            'fields': ['id'],
          },
        );
      } catch (e) {
        print("[DashboardCubit] hr.job fetch failed: $e");
      }

      /// APPLICATIONS
      dynamic applicationsRes;
      try {
        Map<String, dynamic>? fieldsInfo;
        try {
          final rawFields = await service.executeModelMethod(
            'hr.applicant',
            'fields_get',
            [],
            kwargs: {'attributes': ['type']},
          );
          if (rawFields is Map) {
            fieldsInfo = Map<String, dynamic>.from(rawFields);
          }
        } catch (fe) {
          print("[DashboardCubit] fields_get for hr.applicant failed: $fe");
        }

        final List<String> requestedAppFields = ['id', 'name', 'partner_name', 'job_id', 'stage_id', 'recruitment_stage_id', 'create_date'];
        final List<String> activeAppFields = fieldsInfo != null
            ? requestedAppFields.where((f) => fieldsInfo!.containsKey(f) == true).toList()
            : ['id', 'name'];

        final currentYear = DateTime.now().year;
        final startOfYear = '$currentYear-01-01 00:00:00';

        applicationsRes = await service.executeModelMethod(
          'hr.applicant',
          'search_read',
          [[
            ['active', '=', true],
            ['create_date', '>=', startOfYear],
            '|',
            ['employee_id', '=', false],
            ['emp_is_active', '=', true]
          ]],
          kwargs: {
            'fields': activeAppFields,
          },
        );
      } catch (e) {
        print("[DashboardCubit] hr.applicant fetch failed: $e");
      }

      // Extract raw applications and sort/slice for recent
      List<Map<String, dynamic>> recentAppsList = [];
      if (applicationsRes is List) {
        final rawList = List<Map<String, dynamic>>.from(applicationsRes);
        // Sort by create_date or id descending to show newest
        rawList.sort((a, b) {
          final idA = a['id'] as int? ?? 0;
          final idB = b['id'] as int? ?? 0;
          return idB.compareTo(idA);
        });
        recentAppsList = rawList.take(5).toList();
      }

      /// CANDIDATES
      dynamic candidatesRes;
      try {
        candidatesRes = await service.executeModelMethod(
          'hr.candidate',
          'search_read',
          [[]],
          kwargs: {
            'fields': ['id'],
          },
        );
      } catch (e) {
        print("[DashboardCubit] hr.candidate fetch failed: $e");
      }

      int openPositions = 0;
      int totalApplications = 0;
      int totalCandidates = 0;

      if (jobsRes is List) {
        openPositions = jobsRes.length;
      }

      final List<int> weeklyCounts = List.filled(7, 0);
      int newApplicationsThisWeek = 0;

      if (applicationsRes is List) {
        totalApplications = applicationsRes.length;
        
        final today = DateTime.now();
        for (var app in applicationsRes) {
          final createDateStr = app['create_date']?.toString();
          if (createDateStr != null) {
            final createDate = DateTime.tryParse(createDateStr);
            if (createDate != null) {
              final difference = today.difference(createDate).inDays;
              if (difference >= 0 && difference < 7) {
                weeklyCounts[6 - difference]++;
              }
            }
          }
        }
        newApplicationsThisWeek = weeklyCounts.reduce((a, b) => a + b);
      }

      if (candidatesRes is List) {
        totalCandidates =
            candidatesRes.length;
      }

      emit(
        state.copyWith(
          isLoading: false,
          name: name,
          counts: [
            openPositions,
            totalApplications,
            totalCandidates,
          ],
          chartValues: [
            openPositions.toDouble(),
            totalApplications.toDouble(),
            totalCandidates.toDouble(),
          ],
          weeklyCounts: weeklyCounts,
          newApplicationsThisWeek: newApplicationsThisWeek,
          recentApplications: recentAppsList,
          recentCandidates: [],
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString(),
        ),
      );
    }
  }

  void refreshDashboard() {
    loadDashboard();
  }
}