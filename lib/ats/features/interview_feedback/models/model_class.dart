class Applicant {
  final int id;

  final String candidateName;

  final String emailFrom;
  final String partnerPhone;

  final String? alternatePhone;
  final String? linkedinProfile;

  final String recruiter;
  final String jobPosition;

  final double totalExp;
  final double relevantExp;

  final double currentCtc;
  final double expectedSalary;

  final String? currentLocation;
  final String? currentOrganization;

  final String? noticePeriod;

  final String applicationStatus;

  Applicant({
    required this.id,
    required this.candidateName,
    required this.emailFrom,
    required this.partnerPhone,
    this.alternatePhone,
    this.linkedinProfile,
    required this.recruiter,
    required this.jobPosition,
    required this.totalExp,
    required this.relevantExp,
    required this.currentCtc,
    required this.expectedSalary,
    this.currentLocation,
    this.currentOrganization,
    this.noticePeriod,
    required this.applicationStatus,
  });

  factory Applicant.fromJson(Map<String, dynamic> json) {
    String getM2O(dynamic value) {
      if (value is List && value.length > 1) {
        return value[1].toString();
      }
      return '';
    }

    return Applicant(
      id: json['id'] ?? 0,

      candidateName: getM2O(
        json['candidate_id'],
      ),

      emailFrom:
          json['email_from']?.toString() ??
          '',

      partnerPhone:
          json['partner_phone']?.toString() ??
          '',

      alternatePhone:
          json['alternate_phone']
              ?.toString(),

      linkedinProfile:
          json['linkedin_profile']
              ?.toString(),

      recruiter: getM2O(
        json['user_id'],
      ),

      jobPosition: getM2O(
        json['job_id'],
      ),

      totalExp:
          (json['total_exp'] ?? 0)
              .toDouble(),

      relevantExp:
          (json['relevant_exp'] ?? 0)
              .toDouble(),

      currentCtc:
          (json['current_ctc'] ?? 0)
              .toDouble(),

      expectedSalary:
          (json['salary_expected'] ?? 0)
              .toDouble(),

      currentLocation:
          json['current_location']
              ?.toString(),

      currentOrganization:
          json['current_organization']
              ?.toString(),

      noticePeriod:
          json['notice_period']
              ?.toString(),

      applicationStatus:
          json['application_status']
                  ?.toString() ??
              '',
    );
  }
}