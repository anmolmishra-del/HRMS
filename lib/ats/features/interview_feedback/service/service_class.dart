import 'package:flutter/foundation.dart';
import 'package:flutter_app/ats/core/services/odoo_service.dart';
import 'package:flutter_app/ats/features/interview_feedback/models/model_class.dart';

class ApplicantService {
  final OdooService odooService;

  ApplicantService({
    required this.odooService,
  });

    /// FETCH APPLICANTS    
  Future<List<Applicant>> fetchApplicants() async {
    try {
      final response =
          await odooService.executeModelMethod(
        'hr.applicant',
        'search_read',
        [],
        kwargs: { 
          'fields': [
            'id',
            'candidate_id',
            'email_from',
            'partner_phone',
            'alternate_phone',
            'linkedin_profile',
            'exp_type',
            'job_id',
            'user_id',
            'type_id',
            'availability',
            'department_id',
            'company_id',
            'current_ctc',
            'salary_expected',
            'salary_proposed',
            'current_location',
            'current_organization',
            'total_exp',
            'relevant_exp',
            'notice_period',
            'holding_offer',
            'applicant_comments',
            'recruiter_comments',
            'gender',
            'birthday',
            'blood_group',
            'marital',
            'private_street',
            'permanent_street',
            'application_status',
          ],
          'limit': 100,
          'order': 'create_date desc',
        },
      );

      if (response == null ||
          response is! List) {
        return [];
      }

      return response
          .map<Applicant>(
            (item) => Applicant.fromJson(
              Map<String, dynamic>.from(
                item,
              ),
            ),
          )
          .toList();
    } catch (e) {
      debugPrint(
        'ApplicantService Error: $e',
      );
      return [];
    }
  }

  /// CREATE APPLICANT
  Future<int?> createApplicant(
    Map<String, dynamic> values,
  ) async {
    try {
      final result =
          await odooService.executeModelMethod(
        'hr.applicant',
        'create',
        [values],
      );

      return result as int?;
    } catch (e) {
      debugPrint(
        'Create Applicant Error: $e',
      );
      rethrow;
    }
  }

  /// UPDATE APPLICANT
  Future<bool> updateApplicant(
    int applicantId,
    Map<String, dynamic> values,
  ) async {
    try {
      await odooService.executeModelMethod(
        'hr.applicant',
        'write',
        [
          [applicantId],
          values,
        ],
      );

      return true;
    } catch (e) {
      debugPrint(
        'Update Applicant Error: $e',
      );
      return false;
    }
  }

  /// DELETE APPLICANT
  Future<bool> deleteApplicant(
    int applicantId,
  ) async {
    try {
      await odooService.executeModelMethod(
        'hr.applicant',
        'unlink',
        [
          [applicantId],
        ],
      );

      return true;
    } catch (e) {
      debugPrint(
        'Delete Applicant Error: $e',
      );
      return false;
    }
  }
}