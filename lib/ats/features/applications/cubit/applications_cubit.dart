import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/core/services/odoo_service.dart';
import 'package:flutter_app/ats/core/constants/api_config.dart';
import '../state/applications_state.dart';
import '../state/hr_applicant_model.dart';

class ApplicationsCubit extends Cubit<ApplicationsState> {
  late OdooService _svc;

  ApplicationsCubit() : super(ApplicationsState.initial()) {
    _svc = OdooService(ApiConfig.baseUrl);
    loadDropdownData();
    loadApplications();
  } 

  Future<void> refresh() async {
    await loadDropdownData();
    await loadApplications();
  }

  Future<void> loadApplications() async {
    emit(state.copyWith(isLoading: true, error: () => null));
    try {
      // 1. Get valid fields from Odoo dynamically to prevent server ValueErrors
      Map<String, dynamic>? fieldsInfo;
      try {
        final rawFields = await _svc.executeModelMethod(
          'hr.applicant',
          'fields_get',
          [],
          kwargs: {'attributes': ['type']},
        );
        if (rawFields is Map) {
          fieldsInfo = Map<String, dynamic>.from(rawFields);
        }
      } catch (fe) {
        print("[ApplicationsCubit] fields_get failed: $fe");
      }

      final List<String> requestedFields = [
        'id',
        'name',
        'partner_name',
        'candidate_id',
        'email_from',
        'partner_phone',
        'alternate_phone',
        'linkedin_profile',
        'exp_type',
        'hr_job_recruitment',
        'job_id',
        'send_second_application_form',
        'second_application_form_status',
        'send_post_onboarding_form',
        'post_onboarding_form_status',
        'joining_form_link',
        'doc_requests_form_status',
        'user_id',
        'interviewer_ids',
        'categ_ids',
        'applicant_notes',
        'type_id',
        'availability',
        'department_id',
        'company_id',
        'current_ctc',
        'salary_expected',
        'salary_proposed',
        'source_id',
        'medium_id',
        'current_location',
        'preferred_location',
        'current_organization',
        'total_exp',
        'relevant_exp',
        'notice_period',
        'salary_negotiable',
        'np_negotiable',
        'holding_offer',
        'applicant_comments',
        'recruiter_comments',
        'skill_type_id',
        'doj',
        'gender',
        'birthday',
        'blood_group',
        'marital',
        'private_street',
        'permanent_street',
        'application_status',
        'stage_id',
      ];

      final List<String> activeFields = fieldsInfo != null
          ? requestedFields.where((f) => fieldsInfo!.containsKey(f)).toList()
          : requestedFields;

      final res = await _svc.executeModelMethod(
        'hr.applicant',
        'search_read',
        [[]],
        kwargs: {
          'fields': activeFields,
        },
      );

      if (res is List) {
        final parsed = res.map((e) => HrApplicant.fromJson(Map<String, dynamic>.from(e))).toList();
        emit(state.copyWith(applications: parsed, isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      print("[ApplicationsCubit] loadApplications error: $e");
      emit(state.copyWith(isLoading: false, error: () => e.toString()));
    }
  }

  Future<void> loadDropdownData() async {
    try {
      final jobsRes = await _svc.executeModelMethod('hr.job', 'search_read', [[]], kwargs: {'fields': ['id', 'name']});
      final usersRes = await _svc.executeModelMethod('res.users', 'search_read', [[]], kwargs: {'fields': ['id', 'name']});
      final deptsRes = await _svc.executeModelMethod('hr.department', 'search_read', [[]], kwargs: {'fields': ['id', 'name']});
      final companiesRes = await _svc.executeModelMethod('res.company', 'search_read', [[]], kwargs: {'fields': ['id', 'name']});
      final degreesRes = await _svc.executeModelMethod('hr.recruitment.degree', 'search_read', [[]], kwargs: {'fields': ['id', 'name']});
      final candidatesRes = await _svc.executeModelMethod('hr.candidate', 'search_read', [[]], kwargs: {'fields': ['id', 'display_name']});
      
      List<Map<String, dynamic>> locations = [];
      try {
        final locRes = await _svc.executeModelMethod('hr.location', 'search_read', [[]], kwargs: {'fields': ['id', 'name']});
        if (locRes is List) locations = List<Map<String, dynamic>>.from(locRes);
      } catch (_) {}

      List<Map<String, dynamic>> skillTypes = [];
      try {
        final skillTypesRes = await _svc.executeModelMethod('hr.skill.type', 'search_read', [[]], kwargs: {'fields': ['id', 'name']});
        if (skillTypesRes is List) skillTypes = List<Map<String, dynamic>>.from(skillTypesRes);
      } catch (_) {}

      List<Map<String, dynamic>> sources = [];
      try {
        final srcRes = await _svc.executeModelMethod('utm.source', 'search_read', [[]], kwargs: {'fields': ['id', 'name']});
        if (srcRes is List) sources = List<Map<String, dynamic>>.from(srcRes);
      } catch (_) {}

      List<Map<String, dynamic>> mediums = [];
      try {
        final medRes = await _svc.executeModelMethod('utm.medium', 'search_read', [[]], kwargs: {'fields': ['id', 'name']});
        if (medRes is List) mediums = List<Map<String, dynamic>>.from(medRes);
      } catch (_) {}

      final List<Map<String, dynamic>> parsedCandidates = candidatesRes is List
          ? List<Map<String, dynamic>>.from(candidatesRes.map((e) => {
              'id': e['id'],
              'name': e['display_name'] ?? 'Unknown Candidate',
            }))
          : [];

      emit(state.copyWith(
        jobs: jobsRes is List ? List<Map<String, dynamic>>.from(jobsRes) : [],
        recruiters: usersRes is List ? List<Map<String, dynamic>>.from(usersRes) : [],
        departments: deptsRes is List ? List<Map<String, dynamic>>.from(deptsRes) : [],
        companies: companiesRes is List ? List<Map<String, dynamic>>.from(companiesRes) : [],
        degrees: degreesRes is List ? List<Map<String, dynamic>>.from(degreesRes) : [],
        candidates: parsedCandidates,
        locations: locations,
        skillTypes: skillTypes,
        sources: sources,
        mediums: mediums,
      ));
    } catch (e) {
      print("[ApplicationsCubit] loadDropdowns error: $e");
    }
  }

  void search(String value) {
    emit(state.copyWith(searchQuery: value));
  }

  void changeTab(String value) {
    emit(state.copyWith(selectedTab: value));
  }

  void selectApplication(HrApplicant application) {
    emit(state.copyWith(selectedApplication: () => application));
  }

  Future<bool> createApplication(HrApplicant app) async {
    emit(state.copyWith(isLoading: true));
    try {
      final payload = app.toJson();
      // Filter null values
      payload.removeWhere((k, v) => v == null);
      
      final createRes = await _svc.executeModelMethod(
        'hr.applicant',
        'create',
        [payload],
      );
      print("[ApplicationsCubit] Create response: $createRes");
      await loadApplications();
      return true;
    } catch (e) {
      print("[ApplicationsCubit] Create failed: $e");
      emit(state.copyWith(isLoading: false, error: () => e.toString()));
      return false;
    }
  }

  Future<bool> updateApplication(int id, Map<String, dynamic> vals) async {
    emit(state.copyWith(isLoading: true));
    try {
      vals.removeWhere((k, v) => v == null);
      final updateRes = await _svc.executeModelMethod(
        'hr.applicant',
        'write',
        [[id], vals],
      );
      print("[ApplicationsCubit] Update response: $updateRes");
      await loadApplications();
      
      // Update selected application if active
      if (state.selectedApplication?.id == id) {
        final found = state.applications.firstWhere((a) => a.id == id);
        emit(state.copyWith(selectedApplication: () => found));
      }
      return true;
    } catch (e) {
      print("[ApplicationsCubit] Update failed: $e");
      emit(state.copyWith(isLoading: false, error: () => e.toString()));
      return false;
    }
  }
}
