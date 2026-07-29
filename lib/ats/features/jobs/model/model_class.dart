class JobData {

  final int? id;

  final int? jobId;

  final String title;

  final String department;

  final String experience;

  final String location;

  final String salary;

  final String type;

  final String category;

  final String status;

  final int newCount;

  final List<String> primarySkills;

  final List<String> secondarySkills;

  final String description;

  final List<String> responsibilities;

  final List<String> requirements;

  final bool isPublished;

  final String priority;

  final String company;

  final int noOfRecruitment;

  final int noOfEligibleSubmissions;

  final String recruitmentSequence;

  JobData({
    this.id,
    this.jobId,
    required this.title,
    required this.department,
    this.experience = '',
    this.location = '',
    this.salary = '',
    this.type = 'Full-time',
    this.category = '',
    this.status = '',
    this.newCount = 0,
    this.primarySkills = const [],
    this.secondarySkills = const [],
    this.description = '',
    this.responsibilities = const [],
    this.requirements = const [],
    this.isPublished = false,
    this.priority = 'Medium',
    this.company = '',
    this.noOfRecruitment = 0,
    this.noOfEligibleSubmissions = 0,
    this.recruitmentSequence = '',
  });

  factory JobData.fromJson(
    Map<String, dynamic> json,
  ) {

    return JobData(

      id: json['id'] as int?,

      jobId: json['jobId'] != null 
          ? json['jobId'] as int? 
          : (json['job_id'] is int 
              ? json['job_id'] as int 
              : (json['job_id'] is List && (json['job_id'] as List).isNotEmpty 
                  ? json['job_id'][0] as int? 
                  : null)),

      title:
          json['title'] ??
          json['name'] ??
          "",

      department:
          json['department'] ??
          json['department_id'] ??
          "",

      experience:
          json['experience'] ??
          "",

      location:
          json['location'] ??
          "",

      salary:
          json['salary'] ??
          "",

      type:
          json['type'] ??
          "",

      category:
          json['category'] ??
          json['job_category'] ??
          "",

      status:
          json['recruitment_status'] ??
          "",

      newCount:
          json['newCount'] ??
          0,

      primarySkills:
          List<String>.from(
        json['primarySkills'] ?? [],
      ),

      secondarySkills:
          List<String>.from(
        json['secondarySkills'] ?? [],
      ),

      description:
          json['description'] ??
          "",

      responsibilities:
          List<String>.from(
        json['responsibilities'] ?? [],
      ),

      requirements:
          List<String>.from(
        json['requirements'] ?? [],
      ),

      isPublished:
          json['is_published'] ??
          json['website_published'] ??
          false,

      priority:
          json['priority'] ??
          json['job_priority'] ??
          'Medium',

      company:
          json['company'] ??
          json['company_name'] ??
          "",

      noOfRecruitment:
          json['no_of_recruitment'] ??
          json['noOfRecruitment'] ??
          0,

      noOfEligibleSubmissions:
          json['no_of_eligible_submissions'] ??
          json['noOfEligibleSubmissions'] ??
          0,

      recruitmentSequence:
          json['recruitment_sequence'] ??
          json['recruitmentSequence'] ??
          "",
    );
  }

  Map<String, dynamic> toJson() {

    return {

      'id': id,

      'jobId': jobId,

      'title': title,

      'department': department,

      'experience': experience,

      'location': location,

      'salary': salary,

      'type': type,

      'category': category,

      'recruitment_status': status,

      'newCount': newCount,

      'primarySkills': primarySkills,

      'secondarySkills': secondarySkills,

      'description': description,

      'responsibilities': responsibilities,

      'requirements': requirements,

      'is_published': isPublished,

      'priority': priority,

      'company': company,

      'no_of_recruitment': noOfRecruitment,

      'no_of_eligible_submissions': noOfEligibleSubmissions,

      'recruitment_sequence': recruitmentSequence,
    };
  }
}

class RecruitmentModel {

  // ID

  final int? id;

  // MANY2ONE

  final int? addressId;

  final int? companyId;

  final int? contractTypeId;

  final int? experienceId;

  final int? categoryId;

  final int? jobId;

  final int? requestedById;

  final int? primaryRecruiterId;

  final int? websiteId;

  // TEXT

  final String budget;

  final String description;

  // SELECTION

  final String status;

  final String priority;

  final String recruitmentType;

  // INTEGER

  final int eligibleSubmissions;

  final int noOfRecruitment;

  // DATE

  final String targetFrom;

  // MANY2MANY

  final List<int> interviewerIds;

  final List<int> locationIds;

  final List<int> stageIds;

  final List<int> primarySkillIds;

  final List<int> secondarySkillIds;

  RecruitmentModel({

    this.id,

    // MANY2ONE

    this.addressId,

    this.companyId,

    this.contractTypeId,

    this.experienceId,

    this.categoryId,

    this.jobId,

    this.requestedById,

    this.primaryRecruiterId,

    this.websiteId,

    // TEXT

    required this.budget,

    required this.description,

    // SELECTION

    required this.status,

    required this.priority,

    required this.recruitmentType,

    // INTEGER

    required this.eligibleSubmissions,

    required this.noOfRecruitment,

    // DATE

    required this.targetFrom,

    // MANY2MANY

    required this.interviewerIds,

    required this.locationIds,

    required this.stageIds,

    required this.primarySkillIds,

    required this.secondarySkillIds,
  });

  factory RecruitmentModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return RecruitmentModel(

      id: json['id'],

      // MANY2ONE

      addressId:
          json['address_id'] is List
              ? json['address_id'][0]
              : json['address_id'],

      companyId:
          json['company_id'] is List
              ? json['company_id'][0]
              : json['company_id'],

      contractTypeId:
          json['contract_type_id'] is List
              ? json['contract_type_id'][0]
              : json['contract_type_id'],

      experienceId:
          json['experience'] is List
              ? json['experience'][0]
              : json['experience'],

      categoryId:
          json['job_category'] is List
              ? json['job_category'][0]
              : json['job_category'],

      jobId:
          json['job_id'] is List
              ? json['job_id'][0]
              : json['job_id'],

      requestedById:
          json['requested_by'] is List
              ? json['requested_by'][0]
              : json['requested_by'],

      primaryRecruiterId:
          json['user_id'] is List
              ? json['user_id'][0]
              : json['user_id'],

      websiteId:
          json['website_id'] is List
              ? json['website_id'][0]
              : json['website_id'],

      // TEXT

      budget:
          json['budget'] ?? '',

      description:
          json['description'] ?? '',

      // SELECTION

      status:
          json['status'] ?? '',

      priority:
          json['job_priority'] ?? '',

      recruitmentType:
          json['recruitment_type'] ?? '',

      // INTEGER

      eligibleSubmissions:
          json['no_of_eligible_submissions'] ?? 0,

      noOfRecruitment:
          json['no_of_recruitment'] ?? 0,

      // DATE

      targetFrom:
          json['target_from'] ?? '',

      // MANY2MANY

      interviewerIds:
          List<int>.from(
        json['interviewer_ids'] ?? [],
      ),

      locationIds:
          List<int>.from(
        json['locations'] ?? [],
      ),

      stageIds:
          List<int>.from(
        json['recruitment_stage_ids'] ?? [],
      ),

      primarySkillIds:
          List<int>.from(
        json['skill_ids'] ?? [],
      ),

      secondarySkillIds:
          List<int>.from(
        json['secondary_skill_ids'] ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() {

    return {

      'id': id,

      // MANY2ONE

      'address_id': addressId,

      'company_id': companyId,

      'contract_type_id': contractTypeId,

      'experience': experienceId,

      'job_category': categoryId,

      'job_id': jobId,

      'requested_by': requestedById,

      'user_id': primaryRecruiterId,

      'website_id': websiteId,

      // TEXT

      'budget': budget,

      'description': description,

      // SELECTION

      'status': status,

      'job_priority': priority,

      'recruitment_type': recruitmentType,

      // INTEGER

      'no_of_eligible_submissions':
          eligibleSubmissions,

      'no_of_recruitment':
          noOfRecruitment,

      // DATE

      'target_from': targetFrom,

      // MANY2MANY

      'interviewer_ids': interviewerIds,

      'locations': locationIds,

      'recruitment_stage_ids': stageIds,

      'skill_ids': primarySkillIds,

      'secondary_skill_ids':
          secondarySkillIds,
    };
  }
}