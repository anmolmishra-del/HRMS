
import 'package:flutter_app/ats/core/services/odoo_service.dart';
import 'package:flutter_app/ats/features/jobs/model/model_class.dart';

class RecruitmentService {
  final OdooService odooService;

  RecruitmentService(this.odooService);

  Future<List<RecruitmentModel>> fetchRecruitments() async {
    final result = await odooService.callKw({
      'model': 'hr.job.recruitment',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'fields': [
          'job_id',
          'company_id',
          'budget',
          'status',
          'job_priority',
        ],
      },
    });
    return (result as List)
        .map((e) => RecruitmentModel.fromJson(e))
        .toList();
  }

  Future<List<Map<String, dynamic>>> fetchCompanies() async {
    final result = await odooService.callKw({
      'model': 'res.company',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'fields': ['id', 'name'],
      },
    });

    return List<Map<String, dynamic>>.from(result);
  }

  Future<List<Map<String, dynamic>>> fetchJobs() async {
    final result = await odooService.callKw({
      'model': 'hr.job',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'fields': ['id', 'name'],
      },
    });

    return List<Map<String, dynamic>>.from(result);
  }
  Future<List<Map<String, dynamic>>> fetchAddresses() async {
    final result = await odooService.callKw({
      'model': 'res.partner',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'fields': ['id', 'name'],
      },
    });

    return List<Map<String, dynamic>>.from(result);
  }
    Future<List<Map<String, dynamic>>> fetchContractTypes() async {
    final result = await odooService.callKw({
      'model': 'hr.contract.type',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'fields': ['id', 'name'],
      },
    });

    return List<Map<String, dynamic>>.from(result);
  }
  Future<List<Map<String, dynamic>>> fetchSkills() async {
    final result = await odooService.callKw({
      'model': 'hr.skill',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'fields': ['id', 'name'],
      },
    });

    return List<Map<String, dynamic>>.from(result);
  }
 Future<List<Map<String, dynamic>>> fetchExperiences() async {
    final result = await odooService.callKw({
      'model': 'candidate.experience',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'fields': ['id', 'name'],
      },
    });

    return List<Map<String, dynamic>>.from(result);
  }
   Future<List<Map<String, dynamic>>> fetchCategories() async {
    final result = await odooService.callKw({
      'model': 'hr.category',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'fields': ['id', 'name'],
      },
    });

    return List<Map<String, dynamic>>.from(result);
  }
     Future<List<Map<String, dynamic>>> fetchRecruiters() async {
    final result = await odooService.callKw({
      'model': 'use.users',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'fields': ['id', 'name'],
      },
    });

    return List<Map<String, dynamic>>.from(result);
  }
      Future<List<Map<String, dynamic>>> fetchWebsites() async {
    final result = await odooService.callKw({
      'model': 'website',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'fields': ['id', 'name'],
      },
    });

    return List<Map<String, dynamic>>.from(result);
  }


  Future<void> createRecruitment({
    required int jobId,
    required int companyId,
    required String budget,
    required String status,
    required String priority,
    required List<int> skillIds,
  }) async {
    await odooService.callKw({
      'model': 'hr.job.recruitment',
      'method': 'create',
      'args': [
        {
          'job_id': jobId,
          'company_id': companyId,
          'budget': budget,
          'status': status,
          'job_priority': priority,
          'skill_ids': [
            [6, 0, skillIds]
          ],
        }
      ],
      'kwargs': {},
    });
  }
}