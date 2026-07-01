import 'dart:convert';

class HrApplicant {
  final int? id;
  final String name; // Application Subject/Title
  final int? candidateId;
  final String candidateName;
  final String emailFrom;
  final String partnerPhone;
  final String alternatePhone;
  final String linkedinProfile;
  final String expType; // selection
  final int? hrJobRecruitmentId;
  final String hrJobRecruitmentName;
  final int? jobId;
  final String jobName;
  final bool sendSecondApplicationForm;
  final String secondApplicationFormStatus; // selection
  final bool sendPostOnboardingForm;
  final String postOnboardingFormStatus; // selection
  final String joiningFormLink;
  final String docRequestsFormStatus; // selection
  final int? userId; // Recruiter ID
  final String userName; // Recruiter Name
  final List<int> interviewerIds;
  final List<String> interviewerNames;
  final List<int> categIds; // Tags IDs
  final List<String> categNames; // Tags Names
  final String applicantNotes;
  final int? typeId; // Degree ID
  final String degreeName;
  final DateTime? availability;
  final int? departmentId;
  final String departmentName;
  final int? companyId;
  final String companyName;
  final double currentCtc;
  final double salaryExpected;
  final double salaryProposed;
  final int? sourceId;
  final String sourceName;
  final int? mediumId;
  final String mediumName;
  final String currentLocation;
  final List<int> preferredLocationIds;
  final List<String> preferredLocationNames;
  final String currentOrganization;
  final double totalExp;
  final double relevantExp;
  final String noticePeriod;
  final bool salaryNegotiable;
  final bool npNegotiable;
  final String holdingOffer;
  final String applicantComments;
  final String recruiterComments;
  final int? skillTypeId;
  final String skillTypeName;
  final DateTime? doj;
  final String gender; // Selection
  final DateTime? birthday;
  final String bloodGroup; // selection
  final String marital; // selection
  final String privateStreet;
  final String permanentStreet;
  final String applicationStatus; // selection (Ongoing, Hired, Refused, Archived)
  final String stageId;
  final String stageName;

  const HrApplicant({
    this.id,
    required this.name,
    this.candidateId,
    this.candidateName = '',
    this.emailFrom = '',
    this.partnerPhone = '',
    this.alternatePhone = '',
    this.linkedinProfile = '',
    this.expType = '',
    this.hrJobRecruitmentId,
    this.hrJobRecruitmentName = '',
    this.jobId,
    this.jobName = '',
    this.sendSecondApplicationForm = false,
    this.secondApplicationFormStatus = '',
    this.sendPostOnboardingForm = false,
    this.postOnboardingFormStatus = '',
    this.joiningFormLink = '',
    this.docRequestsFormStatus = '',
    this.userId,
    this.userName = '',
    this.interviewerIds = const [],
    this.interviewerNames = const [],
    this.categIds = const [],
    this.categNames = const [],
    this.applicantNotes = '',
    this.typeId,
    this.degreeName = '',
    this.availability,
    this.departmentId,
    this.departmentName = '',
    this.companyId,
    this.companyName = '',
    this.currentCtc = 0.0,
    this.salaryExpected = 0.0,
    this.salaryProposed = 0.0,
    this.sourceId,
    this.sourceName = '',
    this.mediumId,
    this.mediumName = '',
    this.currentLocation = '',
    this.preferredLocationIds = const [],
    this.preferredLocationNames = const [],
    this.currentOrganization = '',
    this.totalExp = 0.0,
    this.relevantExp = 0.0,
    this.noticePeriod = '',
    this.salaryNegotiable = false,
    this.npNegotiable = false,
    this.holdingOffer = '',
    this.applicantComments = '',
    this.recruiterComments = '',
    this.skillTypeId,
    this.skillTypeName = '',
    this.doj,
    this.gender = '',
    this.birthday,
    this.bloodGroup = '',
    this.marital = '',
    this.privateStreet = '',
    this.permanentStreet = '',
    this.applicationStatus = 'Ongoing',
    this.stageId = '',
    this.stageName = 'Applied',
  });

  factory HrApplicant.fromJson(Map<String, dynamic> json) {
    // Parse Many2one helper
    int? getM2oId(dynamic val) {
      if (val is List && val.isNotEmpty) return val[0] as int;
      if (val is int) return val;
      return null;
    }

    String getM2oName(dynamic val) {
      if (val is List && val.length > 1) return val[1].toString();
      if (val is String) return val;
      return '';
    }

    // Parse DateTime helper
    DateTime? parseDate(dynamic val) {
      if (val == null || val == false || val.toString().isEmpty) return null;
      try {
        return DateTime.parse(val.toString());
      } catch (_) {
        return null;
      }
    }

    // Parse Double helper
    double parseDouble(dynamic val) {
      if (val is num) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    String getString(dynamic val) {
      if (val == null || val == false || val == 'false') return '';
      return val.toString();
    }

    String nameVal = getString(json['name']);
    if (nameVal.isEmpty) {
      nameVal = getString(json['partner_name']);
    }
    if (nameVal.isEmpty) {
      nameVal = getM2oName(json['candidate_id']);
    }
    if (nameVal.isEmpty) {
      nameVal = 'Untitled Application';
    }

    return HrApplicant(
      id: json['id'] is int ? json['id'] as int : null,
      name: nameVal,
      candidateId: getM2oId(json['candidate_id']),
      candidateName: getM2oName(json['candidate_id']),
      emailFrom: getString(json['email_from']),
      partnerPhone: getString(json['partner_phone']),
      alternatePhone: getString(json['alternate_phone']),
      linkedinProfile: getString(json['linkedin_profile']),
      expType: getString(json['exp_type']),
      hrJobRecruitmentId: getM2oId(json['hr_job_recruitment']),
      hrJobRecruitmentName: getM2oName(json['hr_job_recruitment']),
      jobId: getM2oId(json['job_id']),
      jobName: getM2oName(json['job_id']),
      sendSecondApplicationForm: json['send_second_application_form'] == true,
      secondApplicationFormStatus: getString(json['second_application_form_status']),
      sendPostOnboardingForm: json['send_post_onboarding_form'] == true,
      postOnboardingFormStatus: getString(json['post_onboarding_form_status']),
      joiningFormLink: getString(json['joining_form_link']),
      docRequestsFormStatus: getString(json['doc_requests_form_status']),
      userId: getM2oId(json['user_id']),
      userName: getM2oName(json['user_id']),
      interviewerIds: json['interviewer_ids'] is List ? List<int>.from(json['interviewer_ids']) : const [],
      applicantNotes: getString(json['applicant_notes']),
      typeId: getM2oId(json['type_id']),
      degreeName: getM2oName(json['type_id']),
      availability: parseDate(json['availability']),
      departmentId: getM2oId(json['department_id']),
      departmentName: getM2oName(json['department_id']),
      companyId: getM2oId(json['company_id']),
      companyName: getM2oName(json['company_id']),
      currentCtc: parseDouble(json['current_ctc']),
      salaryExpected: parseDouble(json['salary_expected']),
      salaryProposed: parseDouble(json['salary_proposed']),
      sourceId: getM2oId(json['source_id']),
      sourceName: getM2oName(json['source_id']),
      mediumId: getM2oId(json['medium_id']),
      mediumName: getM2oName(json['medium_id']),
      currentLocation: getString(json['current_location']),
      preferredLocationIds: json['preferred_location'] is List ? List<int>.from(json['preferred_location']) : const [],
      currentOrganization: getString(json['current_organization']),
      totalExp: parseDouble(json['total_exp']),
      relevantExp: parseDouble(json['relevant_exp']),
      noticePeriod: getString(json['notice_period']),
      salaryNegotiable: json['salary_negotiable'] == true,
      npNegotiable: json['np_negotiable'] == true,
      holdingOffer: getString(json['holding_offer']),
      applicantComments: getString(json['applicant_comments']),
      recruiterComments: getString(json['recruiter_comments']),
      skillTypeId: getM2oId(json['skill_type_id']),
      skillTypeName: getM2oName(json['skill_type_id']),
      doj: parseDate(json['doj']),
      gender: getString(json['gender']),
      birthday: parseDate(json['birthday']),
      bloodGroup: getString(json['blood_group']),
      marital: getString(json['marital']),
      privateStreet: getString(json['private_street']),
      permanentStreet: getString(json['permanent_street']),
      applicationStatus: getString(json['application_status']).isNotEmpty ? getString(json['application_status']) : 'Ongoing',
      stageId: getM2oId(json['stage_id'])?.toString() ?? '',
      stageName: getM2oName(json['stage_id']).isNotEmpty ? getM2oName(json['stage_id']) : 'Applied',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'candidate_id': candidateId,
      'email_from': emailFrom,
      'partner_phone': partnerPhone,
      'alternate_phone': alternatePhone,
      'linkedin_profile': linkedinProfile,
      'exp_type': expType,
      'hr_job_recruitment': hrJobRecruitmentId,
      'job_id': jobId,
      'send_second_application_form': sendSecondApplicationForm,
      'second_application_form_status': secondApplicationFormStatus,
      'send_post_onboarding_form': sendPostOnboardingForm,
      'post_onboarding_form_status': postOnboardingFormStatus,
      'joining_form_link': joiningFormLink,
      'doc_requests_form_status': docRequestsFormStatus,
      'user_id': userId,
      'applicant_notes': applicantNotes,
      'type_id': typeId,
      'availability': availability?.toIso8601String().split('T').first,
      'department_id': departmentId,
      'company_id': companyId,
      'current_ctc': currentCtc,
      'salary_expected': salaryExpected,
      'salary_proposed': salaryProposed,
      'source_id': sourceId,
      'medium_id': mediumId,
      'current_location': currentLocation,
      'current_organization': currentOrganization,
      'total_exp': totalExp,
      'relevant_exp': relevantExp,
      'notice_period': noticePeriod,
      'salary_negotiable': salaryNegotiable,
      'np_negotiable': npNegotiable,
      'holding_offer': holdingOffer,
      'applicant_comments': applicantComments,
      'recruiter_comments': recruiterComments,
      'skill_type_id': skillTypeId,
      'doj': doj?.toIso8601String().split('T').first,
      'gender': gender,
      'birthday': birthday?.toIso8601String().split('T').first,
      'blood_group': bloodGroup,
      'marital': marital,
      'private_street': privateStreet,
      'permanent_street': permanentStreet,
      'application_status': applicationStatus,
    };
  }

  HrApplicant copyWith({
    int? id,
    String? name,
    int? candidateId,
    String? candidateName,
    String? emailFrom,
    String? partnerPhone,
    String? alternatePhone,
    String? linkedinProfile,
    String? expType,
    int? hrJobRecruitmentId,
    String? hrJobRecruitmentName,
    int? jobId,
    String? jobName,
    bool? sendSecondApplicationForm,
    String? secondApplicationFormStatus,
    bool? sendPostOnboardingForm,
    String? postOnboardingFormStatus,
    String? joiningFormLink,
    String? docRequestsFormStatus,
    int? userId,
    String? userName,
    List<int>? interviewerIds,
    List<String>? interviewerNames,
    List<int>? categIds,
    List<String>? categNames,
    String? applicantNotes,
    int? typeId,
    String? degreeName,
    DateTime? availability,
    int? departmentId,
    String? departmentName,
    int? companyId,
    String? companyName,
    double? currentCtc,
    double? salaryExpected,
    double? salaryProposed,
    int? sourceId,
    String? sourceName,
    int? mediumId,
    String? mediumName,
    String? currentLocation,
    List<int>? preferredLocationIds,
    List<String>? preferredLocationNames,
    String? currentOrganization,
    double? totalExp,
    double? relevantExp,
    String? noticePeriod,
    bool? salaryNegotiable,
    bool? npNegotiable,
    String? holdingOffer,
    String? applicantComments,
    String? recruiterComments,
    int? skillTypeId,
    String? skillTypeName,
    DateTime? doj,
    String? gender,
    DateTime? birthday,
    String? bloodGroup,
    String? marital,
    String? privateStreet,
    String? permanentStreet,
    String? applicationStatus,
    String? stageId,
    String? stageName,
  }) {
    return HrApplicant(
      id: id ?? this.id,
      name: name ?? this.name,
      candidateId: candidateId ?? this.candidateId,
      candidateName: candidateName ?? this.candidateName,
      emailFrom: emailFrom ?? this.emailFrom,
      partnerPhone: partnerPhone ?? this.partnerPhone,
      alternatePhone: alternatePhone ?? this.alternatePhone,
      linkedinProfile: linkedinProfile ?? this.linkedinProfile,
      expType: expType ?? this.expType,
      hrJobRecruitmentId: hrJobRecruitmentId ?? this.hrJobRecruitmentId,
      hrJobRecruitmentName: hrJobRecruitmentName ?? this.hrJobRecruitmentName,
      jobId: jobId ?? this.jobId,
      jobName: jobName ?? this.jobName,
      sendSecondApplicationForm: sendSecondApplicationForm ?? this.sendSecondApplicationForm,
      secondApplicationFormStatus: secondApplicationFormStatus ?? this.secondApplicationFormStatus,
      sendPostOnboardingForm: sendPostOnboardingForm ?? this.sendPostOnboardingForm,
      postOnboardingFormStatus: postOnboardingFormStatus ?? this.postOnboardingFormStatus,
      joiningFormLink: joiningFormLink ?? this.joiningFormLink,
      docRequestsFormStatus: docRequestsFormStatus ?? this.docRequestsFormStatus,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      interviewerIds: interviewerIds ?? this.interviewerIds,
      interviewerNames: interviewerNames ?? this.interviewerNames,
      categIds: categIds ?? this.categIds,
      categNames: categNames ?? this.categNames,
      applicantNotes: applicantNotes ?? this.applicantNotes,
      typeId: typeId ?? this.typeId,
      degreeName: degreeName ?? this.degreeName,
      availability: availability ?? this.availability,
      departmentId: departmentId ?? this.departmentId,
      departmentName: departmentName ?? this.departmentName,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      currentCtc: currentCtc ?? this.currentCtc,
      salaryExpected: salaryExpected ?? this.salaryExpected,
      salaryProposed: salaryProposed ?? this.salaryProposed,
      sourceId: sourceId ?? this.sourceId,
      sourceName: sourceName ?? this.sourceName,
      mediumId: mediumId ?? this.mediumId,
      mediumName: mediumName ?? this.mediumName,
      currentLocation: currentLocation ?? this.currentLocation,
      preferredLocationIds: preferredLocationIds ?? this.preferredLocationIds,
      preferredLocationNames: preferredLocationNames ?? this.preferredLocationNames,
      currentOrganization: currentOrganization ?? this.currentOrganization,
      totalExp: totalExp ?? this.totalExp,
      relevantExp: relevantExp ?? this.relevantExp,
      noticePeriod: noticePeriod ?? this.noticePeriod,
      salaryNegotiable: salaryNegotiable ?? this.salaryNegotiable,
      npNegotiable: npNegotiable ?? this.npNegotiable,
      holdingOffer: holdingOffer ?? this.holdingOffer,
      applicantComments: applicantComments ?? this.applicantComments,
      recruiterComments: recruiterComments ?? this.recruiterComments,
      skillTypeId: skillTypeId ?? this.skillTypeId,
      skillTypeName: skillTypeName ?? this.skillTypeName,
      doj: doj ?? this.doj,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      marital: marital ?? this.marital,
      privateStreet: privateStreet ?? this.privateStreet,
      permanentStreet: permanentStreet ?? this.permanentStreet,
      applicationStatus: applicationStatus ?? this.applicationStatus,
      stageId: stageId ?? this.stageId,
      stageName: stageName ?? this.stageName,
    );
  }
}
