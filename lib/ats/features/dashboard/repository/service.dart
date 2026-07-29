import 'package:flutter_app/ats/core/constants/api_config.dart';
import 'package:flutter_app/ats/core/services/odoo_service.dart';

class DashboardRepository {
  Future<Map<String, dynamic>> getDashboardStats() async {
    String name = "";

    try {
      final user =
          await OdooService(ApiConfig.baseUrl).callKw({
        'model': 'res.users',
        'method': 'search_read',
        'args': [
          [
            ['id', '=', OdooService.currentUserId]
          ]
        ],
        'kwargs': {
          'fields': ['name'],
          'limit': 1,
        },
      });

      if (user is List && user.isNotEmpty) {
        name = user[0]['name'] ?? "";
      }
    } catch (e) {
      print("USER ERROR => $e");
    }

    final results = await Future.wait([
      /// JOBS
      OdooService(ApiConfig.baseUrl).callKw({
        'model': 'hr.job.recruitment',
        'method': 'search_count',
        'args': [
          [
            ['user_id', '=', OdooService.currentUserId]
          ]
        ],
        'kwargs': {},
      }),

      /// APPLICATIONS
      OdooService(ApiConfig.baseUrl).callKw({
        'model': 'hr.applicant',
        'method': 'search_count',
        'args': [
          [
            ['user_id', '=', OdooService.currentUserId]
          ]
        ],
        'kwargs': {},
      }),

      /// CANDIDATES
      OdooService(ApiConfig.baseUrl).callKw({
        'model': 'hr.candidate',
        'method': 'search_count',
        'args': [[]],
        'kwargs': {},
      }),
    ]);

    final jobs = results[0] ?? 0;
    final applications = results[1] ?? 0;
    final candidates = results[2] ?? 0;

    return {
      'recruiterName': name,

      'counts': [
        jobs,
        applications,
        candidates,
      ],

      'chartValues': [
        jobs.toDouble(),
        applications.toDouble(),
        candidates.toDouble(),
      ],
    };
  }
}