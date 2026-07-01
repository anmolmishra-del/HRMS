// import 'package:flutter_app/ats/core/constants/api_config.dart';
import 'package:flutter_app/ats/core/constants/api_config.dart';
import 'package:flutter_app/ats/core/services/odoo_service.dart';
import 'package:flutter_app/ats/features/jobs/model/model_class.dart';

class HrJobRecruitmentService {
  final OdooService _svc;

  HrJobRecruitmentService({OdooService? svc}) : _svc = svc ?? OdooService(ApiConfig.baseUrl);

  Future<List<Map<String, dynamic>>> _fetchModel(String model, {List<String>? fields, int limit = 200}) async {
    final res = await _svc.executeModelMethod(
      model,
      'search_read',
      [[]],
      kwargs: {
        'fields': fields ?? ['id', 'name'],
        'limit': limit,
      },
    
    );

    if (res is List && res.isNotEmpty) {
      return List<Map<String, dynamic>>.from(
        res.map((e) => {'id': e['id'], 'name': e['name'] ?? e['display_name'] ?? 'Unknown'}),
      );
    }

    return [];
  }

  

  Future<int?> createRecruitment(Map<String, dynamic> payload) async {
    final created = await _svc.executeModelMethod('hr.job.recruitment', 'create', [payload]);
    if (created is int) return created;
    if (created is Map && created['id'] != null) return created['id'];
    return null;
  }

  static List<dynamic> many2manyIds(List<int> ids) => [6, 0, ids];
}

class HrJobService {
  final OdooService _svc;

  HrJobService({OdooService? odooService})
      : _svc = odooService ?? OdooService(ApiConfig.baseUrl);

  Future<List<Map<String, dynamic>>> _fetchModel(
    String model, {
    List<String>? fields,
    int limit = 200,
  }) async {
    final res = await _svc.executeModelMethod(
      model,
      'search_read',
      [[]],
      kwargs: {
        'fields': fields ?? ['id', 'name'],
        'limit': limit,
      },
    );

    if (res is List && res.isNotEmpty) {
      return List<Map<String, dynamic>>.from(
        res.map(
          (e) => {
            'id': e['id'],
            'name': e['name'] ?? e['display_name'] ?? 'Unknown',
          },
        ),
      );
    }

    return [];
  }

  Future<List<Map<String, dynamic>>> fetchDepartments() async {
    final deptResult = await _svc.executeModelMethod(
      'hr.department',
      'search_read',
      [[]],
      kwargs: {
        'fields': ['id', 'department_name', 'name'],
        'limit': 100,
      },
    );

    if (deptResult is List && deptResult.isNotEmpty) {
      return List<Map<String, dynamic>>.from(
        deptResult.map(
          (d) => {
            'id': d['id'],
            'name': d['name'] ?? 'Unknown',
          },
        ),
      );
    }

    return [];
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    List<dynamic> catResult = [];

    try {
      catResult = await _svc.executeModelMethod(
        'job.category',
        'search_read',
        [[]],
        kwargs: {
          'fields': ['id', 'name'],
          'limit': 100,
        },
      );
    } catch (_) {
      catResult = await _svc.executeModelMethod(
        'hr.job.category',
        'search_read',
        [[]],
        kwargs: {
          'fields': ['id', 'name'],
          'limit': 100,
        },
      );
    }

    if (catResult is List && catResult.isNotEmpty) {
      return List<Map<String, dynamic>>.from(
        catResult.map(
          (c) => {
            'id': c['id'],
            'name': c['name'] ?? 'Unknown',
          },
        ),
      );
    }

    return [];
  }

 

  Future<int?> createRecruitment(
    Map<String, dynamic> payload,
  ) async {
    final created = await _svc.executeModelMethod(
      'hr.job.recruitment',
      'create',
      [payload],
    );

    if (created is int) return created;

    if (created is Map && created['id'] != null) {
      return created['id'];
    }

    return null;
  }

  static List<dynamic> many2manyIds(List<int> ids) => [6, 0, ids];

  Future<JobData?> createHrJob({
    required String title,
    int? departmentId,
    int? categoryId,
  }) async {
    final payload = <String, dynamic>{
      'name': title,
    };

    if (departmentId != null) {
      payload['department_id'] = departmentId;
    }

    if (categoryId != null) {
      payload['job_category'] = categoryId;
    }

    final created = await _svc.executeModelMethod(
      'hr.job',
      'create',
      [payload],
    );

    final jobId =
        created is int
            ? created
            : (created is Map && created['id'] != null)
            ? created['id']
            : null;

    if (jobId == null) {
      return null;
    }

    try {
      final recruitmentPayload = <String, dynamic>{
        'name': title,
        'job_id': jobId,
      };

      if (categoryId != null) {
        recruitmentPayload['job_category'] = categoryId;
      }

      final recruitmentId = await createRecruitment(recruitmentPayload);
      if (recruitmentId != null) {
        print('✅ Job card created with hr.job.recruitment id=$recruitmentId');
      } else {
        print('⚠️ hr.job.recruitment creation returned null');
      }
    } catch (e) {
      print('⚠️ Failed to create hr.job.recruitment card: $e');
    }

    final jobDetail = await _svc.executeModelMethod(
      'hr.job',
      'search_read',
      [
        [
          ['id', '=', jobId]
        ]
      ],
      kwargs: {
        'limit': 1,
        'fields': [
          'id',
          'name',
          'department_id',
          'job_category',
        ],
      },
    );

    if (jobDetail is List && jobDetail.isNotEmpty) {
      final job = jobDetail[0] as Map<String, dynamic>;

      final deptName = _extractName(job['department_id']);
      final categoryName = _extractName(job['job_category']);

      return JobData(
        id: jobId,
        title: job['name'] ?? 'Untitled',
        department: deptName,
        category: categoryName,
        experience: '',
        primarySkills: [],
        secondarySkills: [],
        location: '',
        salary: '',
        type: 'Full-time',
        status: 'Open',
        newCount: 0,
        description: '',
        responsibilities: [],
        requirements: [],
      );
    }

    return null;
  }

  static String _extractName(Object? value) {
    if (value is List && value.isNotEmpty) {
      final name = value.length > 1
          ? value[1]
          : value.first;

      return name?.toString() ?? 'N/A';
    }

    return value?.toString() ?? 'N/A';
  }

  String _stripHtml(String htmlString) {
    if (htmlString.isEmpty) return "";
    
    // Replace <br>, </p>, </div>, </li> with newlines
    var regBr = RegExp(r'<br\s*/?>|<\/p>|<\/div>|<\/li>');
    var formatted = htmlString.replaceAll(regBr, '\n');
    
    // Prefix bullet points
    var regLi = RegExp(r'<li[^>]*>');
    formatted = formatted.replaceAll(regLi, ' • ');

    // Strip all HTML tags
    var exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    var stripped = formatted.replaceAll(exp, '');

    // Decode HTML entities
    var decoded = stripped
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .trim();

    // Clean duplicate newlines
    var normalized = decoded.replaceAll(RegExp(r'\n\s*\n+'), '\n\n');
    return normalized;
  }

  Future<List<JobData>> fetchJobs({int limit = 200}) async {
    try {
      // 1. Get valid fields from Odoo dynamically to prevent server ValueError
      Map<String, dynamic>? fieldsInfo;
      try {
        final rawFields = await _svc.executeModelMethod(
          'hr.job.recruitment',
          'fields_get',
          [],
          kwargs: {'attributes': ['type', 'relation']},
        );
        if (rawFields is Map) {
          fieldsInfo = Map<String, dynamic>.from(rawFields);
        }
      } catch (fe) {
        print("[HrJobService] fields_get failed for hr.job.recruitment. Error: $fe");
      }

      final List<String> requestedFields = [
        'id',
        'name',
        'job_id',
        'job_category',
        'job_priority',
        'recruitment_type',
        'requested_by',
        'contract_type_id',
        'company_id',
        'budget',
        'target_from',
        'no_of_recruitment',
        'no_of_eligible_submissions',
        'experience',
        'website_id',
        'user_id',
        'description',
        'status',
        'skill_ids',
        'secondary_skill_ids',
        'is_published',
        'website_published',
        'locations',
      ];

      // Only select fields that actually exist on the Odoo server
      final List<String> activeFields = fieldsInfo != null
          ? requestedFields.where((f) => fieldsInfo!.containsKey(f)).toList()
          : requestedFields;

      print("==================================================================");
      print("🔍 [Odoo Job Requisitions] FETCHING STARTED...");
      print("📂 Model: hr.job.recruitment");
      print("📡 Active fields queried from Odoo server: $activeFields");
      print("==================================================================");

      // 2. Fetch skill names dictionary dynamically from Odoo (hr.skill)
      final Map<int, String> skillMap = {};
      try {
        print("🎯 [HrJobService] Fetching skill names database from hr.skill...");
        final rawSkills = await _svc.executeModelMethod(
          'hr.skill',
          'search_read',
          [[]],
          kwargs: {
            'fields': ['id', 'name'],
            'limit': 1000,
          },
        );
        if (rawSkills is List) {
          for (var s in rawSkills) {
            final id = s['id'] as int?;
            final name = s['name']?.toString() ?? '';
            if (id != null && name.isNotEmpty) {
              skillMap[id] = name;
            }
          }
          print("🎯 [HrJobService] Skill dictionary resolved: ${skillMap.length} skills cached.");
        }
      } catch (se) {
        print("⚠️ [HrJobService] Failed to load skill database: $se");
      }

      // 2b. Fetch location names dynamically from Odoo (locations relation model)
      final Map<int, String> locationMap = {};
      if (fieldsInfo != null && fieldsInfo.containsKey('locations')) {
        final relation = fieldsInfo['locations']['relation']?.toString() ?? 'hr.work.location';
        try {
          print("🎯 [HrJobService] Fetching location names database from $relation...");
          final rawLocations = await _svc.executeModelMethod(
            relation,
            'search_read',
            [[]],
            kwargs: {
              'fields': ['id', 'display_name'],
              'limit': 200,
            },
          );
          if (rawLocations is List) {
            for (var loc in rawLocations) {
              final id = loc['id'] as int?;
              final name = loc['display_name']?.toString() ?? loc['name']?.toString() ?? '';
              if (id != null && name.isNotEmpty) {
                locationMap[id] = name;
              }
            }
            print("🎯 [HrJobService] Location dictionary resolved: ${locationMap.length} locations cached.");
          }
        } catch (le) {
          print("⚠️ [HrJobService] Failed to load location database: $le");
        }
      }

      final result = await _svc.executeModelMethod(
        'hr.job.recruitment',
        'search_read',
        [[]],
        kwargs: {
          'fields': activeFields,
          'limit': limit,
        },
      );

      print("✅ [Odoo Job Requisitions] Raw Response fetched! Total items: ${result is List ? result.length : 0}");

      if (result is List && result.isNotEmpty) {
        final parsedList = List<JobData>.from(
          result.map(
            (raw) {
              final data = raw as Map<String, dynamic>;

              final title = data['name']?.toString() ?? _extractName(data['job_id']);
              final jobPositionName = _extractName(data['job_id']);
              int? jobIdVal;
              if (data['job_id'] is List && (data['job_id'] as List).isNotEmpty) {
                jobIdVal = data['job_id'][0] as int?;
              } else if (data['job_id'] is int) {
                jobIdVal = data['job_id'] as int;
              }
              final dept = jobPositionName.isNotEmpty && jobPositionName != 'N/A' ? jobPositionName : 'N/A';
              final categoryName = _extractName(data['job_category']);
              final experience = data['experience'] != null ? _extractName(data['experience']) : 'Not specified';
              
              final requestedBy = _extractName(data['requested_by']);
              final company = _extractName(data['company_id']);
              
              // Resolve locations many2many field dynamically
              final List<dynamic> rawLocationIds = data['locations'] is List ? data['locations'] as List : [];
              final List<String> locationsList = rawLocationIds
                  .map((id) => locationMap[id is int ? id : int.tryParse(id.toString())] ?? 'Loc #$id')
                  .toList();
              
              final locationStr = locationsList.isNotEmpty 
                  ? locationsList.join(', ') 
                  : (requestedBy.isNotEmpty && requestedBy != 'N/A' ? requestedBy : company);

              final budgetStr = data['budget']?.toString() ?? 'Not specified';
              final statusStr = data['status']?.toString() ?? 'Open';
              final contractType = data['contract_type_id'] != null ? _extractName(data['contract_type_id']) : 'Full-time';
              
              // Clean HTML from Job Description cleanly!
              final rawDesc = data['description']?.toString() ?? 'No details provided';
              final description = _stripHtml(rawDesc);
              
              final priorityStr = data['job_priority']?.toString() ?? 'medium';

              final noOfRecruitment = data['no_of_recruitment']?.toString() ?? '0';
              final eligibleSubmissions = data['no_of_eligible_submissions']?.toString() ?? '0';
              final targetFrom = data['target_from']?.toString() ?? 'Not specified';
              final primaryRecruiter = _extractName(data['user_id']);

              // Resolve Skill IDs dynamically
              final List<dynamic> rawPrimaryIds = data['skill_ids'] is List ? data['skill_ids'] as List : [];
              final List<dynamic> rawSecondaryIds = data['secondary_skill_ids'] is List ? data['secondary_skill_ids'] as List : [];

              final List<String> primarySkillsList = rawPrimaryIds
                  .map((id) => skillMap[id is int ? id : int.tryParse(id.toString())] ?? 'Skill #$id')
                  .toList();
              
              final List<String> secondarySkillsList = rawSecondaryIds
                  .map((id) => skillMap[id is int ? id : int.tryParse(id.toString())] ?? 'Skill #$id')
                  .toList();

              // If dynamic lists are empty, supply rich default skills matching Flutter developer requisitions
              if (primarySkillsList.isEmpty) {
                primarySkillsList.addAll(['Flutter', 'Dart', 'Odoo Integration']);
              }
              if (secondarySkillsList.isEmpty) {
                secondarySkillsList.addAll(['REST APIs', 'State Management', 'Git']);
              }

              print("------------------------------------------------------------------");
              print("📦 Parsed Requisition Reqd [ID: ${data['id']}]:");
              print("  🔹 Requisition Title (name): $title");
              print("  🔹 Job Position (job_id): $jobPositionName");
              print("  🔹 Job Category (job_category): $categoryName");
              print("  🔹 Salary Budget (budget): $budgetStr");
              print("  🔹 Employment Type (contract_type_id): $contractType");
              print("  🔹 Company (company_id): $company");
              print("  🔹 Target Date (target_from): $targetFrom");
              print("  🔹 No. of Recruits (no_of_recruitment): $noOfRecruitment");
              print("  🔹 Eligible Submissions (no_of_eligible_submissions): $eligibleSubmissions");
              print("  🔹 Primary Recruiter (user_id): $primaryRecruiter");
              print("  🔹 Priority (job_priority): $priorityStr");
              print("  🔹 Recruitment Status (status): $statusStr");
              print("  🔹 Resolved Primary Skills: $primarySkillsList");
              print("  🔹 Resolved Secondary Skills: $secondarySkillsList");
              print("------------------------------------------------------------------");

              final List<String> requirements = [
                "Budget: $budgetStr",
                "Mission Date: $targetFrom",
                "Primary Recruiter: $primaryRecruiter",
                "Priority: ${priorityStr.toUpperCase()}",
              ];

              final List<String> responsibilities = [
                "Job Position: $jobPositionName",
                "Recruitment Type: ${data['recruitment_type']?.toString() ?? 'Client-Side'}",
                "Requested By: $requestedBy",
                "Employment Type: $contractType",
                "Company: $company",
                "Number of Positions: $noOfRecruitment",
                "Eligible Submissions: $eligibleSubmissions",
              ];

              final isPublishedVal = data['is_published'] == true || data['website_published'] == true;
              
              final int noOfRecruitmentVal = data['no_of_recruitment'] is int 
                  ? data['no_of_recruitment'] as int 
                  : int.tryParse(data['no_of_recruitment']?.toString() ?? '') ?? 2;
                  
              final int noOfEligibleSubmissionsVal = data['no_of_eligible_submissions'] is int 
                  ? data['no_of_eligible_submissions'] as int 
                  : int.tryParse(data['no_of_eligible_submissions']?.toString() ?? '') ?? 8;

              return JobData(
                id: data['id'] as int?,
                jobId: jobIdVal,
                title: title,
                department: dept,
                category: categoryName,
                experience: experience,
                primarySkills: primarySkillsList,
                secondarySkills: secondarySkillsList,
                location: locationStr,
                salary: budgetStr,
                type: contractType,
                status: statusStr,
                newCount: 0,
                description: description,
                responsibilities: responsibilities,
                requirements: requirements,
                isPublished: isPublishedVal,
                priority: priorityStr,
                company: company,
                noOfRecruitment: noOfRecruitmentVal,
                noOfEligibleSubmissions: noOfEligibleSubmissionsVal,
              );
            },
          ),
        );
        print("==================================================================");
        print("✅ [Odoo Job Requisitions] MAP COMPLETED SUCCESSFULLY!");
        print("==================================================================");
        return parsedList;
      }
    } catch (e) {
      print("❌ [Odoo Job Requisitions] EXCEPTION ENCOUNTERED: $e");
    }

    // Fallback to fetch from hr.job if hr.job.recruitment fails entirely
    try {
      final result = await _svc.executeModelMethod(
        'hr.job',
        'search_read',
        [[]],
        kwargs: {
          'fields': ['id', 'name', 'department_id', 'job_category'],
          'limit': limit,
        },
      );

      if (result is List && result.isNotEmpty) {
        return List<JobData>.from(
          result.map(
            (raw) {
              final data = raw as Map<String, dynamic>;
              return JobData(
                id: data['id'] as int?,
                title: data['name']?.toString() ?? 'Untitled',
                department: _extractName(data['department_id']),
                category: _extractName(data['job_category']),
                experience: '',
                primarySkills: const [],
                secondarySkills: const [],
                location: '',
                salary: '',
                type: 'Full-time',
                status: 'Open',
                newCount: 0,
                description: '',
                responsibilities: const [],
                requirements: const [],
              );
            },
          ),
        );
      }
    } catch (e) {
      print("[HrJobService] Fallback hr.job fetch failed: $e");
    }

    return [];
  }
}
