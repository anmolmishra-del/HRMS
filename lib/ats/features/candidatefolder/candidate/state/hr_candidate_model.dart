import 'dart:convert';

class HrCandidateSkill {
  final String skillTypeId; // Many2one(hr.skill.type)
  final String skillId;     // Many2one(hr.skill)
  final String skillLevel;  // Skill Level

  const HrCandidateSkill({
    required this.skillTypeId,
    required this.skillId,
    this.skillLevel = 'Intermediate',
  });

  factory HrCandidateSkill.fromJson(Map<String, dynamic> json) {
    return HrCandidateSkill(
      skillTypeId: json['skill_type_id'] ?? '',
      skillId: json['skill_id'] ?? '',
      skillLevel: json['skill_level'] ?? 'Intermediate',
    );
  }

  Map<String, dynamic> toJson() => {
    'skill_type_id': skillTypeId,
    'skill_id': skillId,
    'skill_level': skillLevel,
  };

  HrCandidateSkill copyWith({
    String? skillTypeId,
    String? skillId,
    String? skillLevel,
  }) {
    return HrCandidateSkill(
      skillTypeId: skillTypeId ?? this.skillTypeId,
      skillId: skillId ?? this.skillId,
      skillLevel: skillLevel ?? this.skillLevel,
    );
  }
}

class HrCandidate {
  final int? odooId;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String partnerId; // Many2one(res.partner)
  final String emailFrom;
  final String partnerPhone;
  final String? alternatePhone;
  final String? linkedinProfile;
  final String typeId; // Many2one(hr.recruitment.degree)
  final String userId; // Many2one(res.users) - Candidate Manager
  final String priority; // Selection: '0' (Low), '1' (Medium), '2' (High), '3' (Excellent)
  final DateTime availability;
  final List<String> categIds; // Many2many(hr.applicant.category) - Tags
  final String? resume; // Binary / Path / String base64 or URL
  final String companyId; // many2one(res.company)
  
  // One2many(hr.candidate.skill)
  final List<HrCandidateSkill> skills;

  // Base64 encoded profile picture from Odoo backend
  final String? image;

  // Computed field caches (Odoo-like)
  final double matchingSkillPercentage; // _compute_matching_skill_ids
  final List<String> computedSkillsList; // _compute_skill_ids
  final String stage; // Applied, Screening, HR Round, Technical Round, Presentation
  final String? linkedApplicationId;

  const HrCandidate({
    this.odooId,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.partnerId,
    required this.emailFrom,
    required this.partnerPhone,
    this.alternatePhone,
    this.linkedinProfile,
    required this.typeId,
    required this.userId,
    required this.priority,
    required this.availability,
    required this.categIds,
    this.resume,
    required this.companyId,
    required this.skills,
    this.image,
    this.matchingSkillPercentage = 0.0,
    this.computedSkillsList = const [],
    this.stage = "Applied",
    this.linkedApplicationId,
  });

  String get fullName => "${firstName}${middleName != null && middleName!.isNotEmpty ? ' $middleName' : ''} $lastName";

  /// 🛠️ Odoo Method: Matching Candidate Skills
  /// In the Recruitment module, we computed matching and missing skills between the Candidate and the selected Job Position.
  /// Compares candidate skills with job-required skills and calculates the matching percentage score.
  HrCandidate computeMatchingSkillIds(List<String> requiredSkills) {
    if (requiredSkills.isEmpty || skills.isEmpty) {
      return copyWith(matchingSkillPercentage: 0.0);
    }
    
    // Get lowercase skill names for robust comparison
    final candidateSkillNames = skills.map((s) => s.skillId.toLowerCase()).toSet();
    final matchedCount = requiredSkills
        .where((reqSkill) => candidateSkillNames.contains(reqSkill.toLowerCase()))
        .length;

    final percentage = (matchedCount / requiredSkills.length) * 100.0;
    return copyWith(matchingSkillPercentage: percentage);
  }

  /// 🛠️ Odoo Method: Candidate Skill Mapping
  /// This method computes all candidate skills from the Candidate Skill lines and maps them into the Skill field.
  /// Automatically updates candidate skills whenever skill lines are added or modified.
  HrCandidate computeSkillIds() {
    final list = skills.map((s) => s.skillId).toList();
    return copyWith(computedSkillsList: list);
  }

  /// 🛠️ Odoo Method: Employee Skill Creation
  /// While creating an Employee from a Candidate, this method transfers all candidate skills into the Employee Skill records.
  /// Copies candidate skill details such as Skill, Skill Level, and Skill Type into the Employee profile.
  Map<String, dynamic> getEmployeeCreateVals() {
    return {
      'name': fullName,
      'work_email': emailFrom,
      'work_phone': partnerPhone,
      'private_phone': alternatePhone ?? '',
      'employee_type': 'employee',
      'degree': typeId,
      'company_id': companyId,
      'coach_id': userId,
      'skills_vals': skills.map((s) => {
        'skill_type_id': s.skillTypeId,
        'skill_id': s.skillId,
        'level': s.skillLevel, 
      }).toList(),
    };
  }

  /// 🛠️ Odoo Method: Create Job Application
  /// This method creates a Job Application record for the selected Candidate based on the active Job Position.
  /// Generates applicant records linked to the selected job and redirects to the Applications view.
  HrCandidate actionCreateApplication(String jobPositionId) {
    final appId = "APP-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}";
    return copyWith(
      linkedApplicationId: appId,
      stage: "Applied",
    );
  }

  HrCandidate copyWith({
    int? odooId,
    String? firstName,
    String? middleName,
    String? lastName,
    String? partnerId,
    String? emailFrom,
    String? partnerPhone,
    String? alternatePhone,
    String? linkedinProfile,
    String? typeId,
    String? userId,
    String? priority,
    DateTime? availability,
    List<String>? categIds,
    String? resume,
    String? companyId,
    List<HrCandidateSkill>? skills,
    String? image,
    double? matchingSkillPercentage,
    List<String>? computedSkillsList,
    String? stage,
    String? linkedApplicationId,
  }) {
    return HrCandidate(
      odooId: odooId ?? this.odooId,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      partnerId: partnerId ?? this.partnerId,
      emailFrom: emailFrom ?? this.emailFrom,
      partnerPhone: partnerPhone ?? this.partnerPhone,
      alternatePhone: alternatePhone ?? this.alternatePhone,
      linkedinProfile: linkedinProfile ?? this.linkedinProfile,
      typeId: typeId ?? this.typeId,
      userId: userId ?? this.userId,
      priority: priority ?? this.priority,
      availability: availability ?? this.availability,
      categIds: categIds ?? this.categIds,
      resume: resume ?? this.resume,
      companyId: companyId ?? this.companyId,
      skills: skills ?? this.skills,
      image: image ?? this.image,
      matchingSkillPercentage: matchingSkillPercentage ?? this.matchingSkillPercentage,
      computedSkillsList: computedSkillsList ?? this.computedSkillsList,
      stage: stage ?? this.stage,
      linkedApplicationId: linkedApplicationId ?? this.linkedApplicationId,
    );
  }
}
