
import 'package:flutter_app/ats/features/jobs/model/model_class.dart';

class JobState {

  final String selectedTab;

  final String searchQuery;

  final List<JobData> jobs;

  final bool isLoading;

  // True during silent background re-fetch — does NOT show the full loading spinner
  final bool isRefreshing;

  final String? error;

  const JobState({

    required this.selectedTab,

    required this.searchQuery,

    required this.jobs,

    required this.isLoading,

    this.isRefreshing = false,

    this.error,
  });

  factory JobState.initial() {

    return const JobState(

      selectedTab: "All",

      searchQuery: "",

      jobs: [],

      isLoading: false,

      error: null,
    );
  }

  JobState copyWith({

    String? selectedTab,

    String? searchQuery,

    List<JobData>? jobs,

    bool? isLoading,

    bool? isRefreshing,

    String? error,

  }) {

    return JobState(

      selectedTab:
          selectedTab ?? this.selectedTab,

      searchQuery:
          searchQuery ?? this.searchQuery,

      jobs:
          jobs ?? this.jobs,

      isLoading:
          isLoading ?? this.isLoading,

      isRefreshing:
          isRefreshing ?? this.isRefreshing,

      error:
          error,
    );
  }
}

class RecruitmentState {

  final List<RecruitmentModel>
      recruitments;

  final bool loading;

  // DROPDOWN DATA

  final List<Map<String, dynamic>>
      addresses;

  final List<Map<String, dynamic>>
      partners;

  final List<Map<String, dynamic>>
      companies;

  final List<Map<String, dynamic>>
      jobs;

  final List<Map<String, dynamic>>
      contractTypes;

  final List<Map<String, dynamic>>
      experiences;

  final List<Map<String, dynamic>>
      categories;

  final List<Map<String, dynamic>>
      recruiters;

  final List<Map<String, dynamic>>
      websites;

  final List<Map<String, dynamic>>
      skills;

  final List<Map<String, dynamic>>
      locations;

  final List<Map<String, dynamic>>
      stages;

  // SELECTED VALUES

  final String selectedRecruitmentType;

  final int? selectedAddressId;

  final int? selectedRequestedById;

  final int? selectedCompanyId;

  final int? selectedJobId;

  final int? selectedContractTypeId;

  final int? selectedExperienceId;

  final int? selectedCategoryId;

  final int? selectedRecruiterId;

  final int? selectedWebsiteId;

  // MANY2MANY

  final List<int>
      selectedInterviewerIds;

  final List<int>
      selectedLocationIds;

  final List<int>
      selectedStageIds;

  final List<int>
      selectedPrimarySkillIds;

  final List<int>
      selectedSecondarySkillIds;

  RecruitmentState({

    required this.recruitments,

    required this.loading,

    required this.addresses,

    required this.partners,

    required this.companies,

    required this.jobs,

    required this.contractTypes,

    required this.experiences,

    required this.categories,

    required this.recruiters,

    required this.websites,

    required this.skills,

    required this.locations,

    required this.stages,

    required this.selectedRecruitmentType,

    required this.selectedAddressId,

    required this.selectedRequestedById,

    required this.selectedCompanyId,

    required this.selectedJobId,

    required this.selectedContractTypeId,

    required this.selectedExperienceId,

    required this.selectedCategoryId,

    required this.selectedRecruiterId,

    required this.selectedWebsiteId,

    required this.selectedInterviewerIds,

    required this.selectedLocationIds,

    required this.selectedStageIds,

    required this.selectedPrimarySkillIds,

    required this.selectedSecondarySkillIds,
  });

  factory RecruitmentState.initial() {

    return RecruitmentState(

      recruitments: [],

      loading: false,

      // DROPDOWNS

      addresses: [],

      partners: [],

      companies: [],

      jobs: [],

      contractTypes: [],

      experiences: [],

      categories: [],

      recruiters: [],

      websites: [],

      skills: [],

      locations: [],

      stages: [],

      // SELECTED

      selectedRecruitmentType:
          'internal',

      selectedAddressId: null,

      selectedRequestedById: null,

      selectedCompanyId: null,

      selectedJobId: null,

      selectedContractTypeId: null,

      selectedExperienceId: null,

      selectedCategoryId: null,

      selectedRecruiterId: null,

      selectedWebsiteId: null,

      // MANY2MANY

      selectedInterviewerIds: [],

      selectedLocationIds: [],

      selectedStageIds: [],

      selectedPrimarySkillIds: [],

      selectedSecondarySkillIds: [],
      
    );
  }

  RecruitmentState copyWith({

    List<RecruitmentModel>?
        recruitments,

    bool? loading,

    List<Map<String, dynamic>>?
        addresses,

    List<Map<String, dynamic>>?
        partners,

    List<Map<String, dynamic>>?
        companies,

    List<Map<String, dynamic>>?
        jobs,

    List<Map<String, dynamic>>?
        contractTypes,

    List<Map<String, dynamic>>?
        experiences,

    List<Map<String, dynamic>>?
        categories,

    List<Map<String, dynamic>>?
        recruiters,

    List<Map<String, dynamic>>?
        websites,

    List<Map<String, dynamic>>?
        skills,

    List<Map<String, dynamic>>?
        locations,

    List<Map<String, dynamic>>?
        stages,

    String?
        selectedRecruitmentType,

    int? selectedAddressId,

    int? selectedRequestedById,

    int? selectedCompanyId,

    int? selectedJobId,

    int? selectedContractTypeId,

    int? selectedExperienceId,

    int? selectedCategoryId,

    int? selectedRecruiterId,

    int? selectedWebsiteId,

    List<int>?
        selectedInterviewerIds,

    List<int>?
        selectedLocationIds,

    List<int>?
        selectedStageIds,

    List<int>?
        selectedPrimarySkillIds,

    List<int>?
        selectedSecondarySkillIds,

  }) {

    return RecruitmentState(

      recruitments:
          recruitments ??
          this.recruitments,

      loading:
          loading ??
          this.loading,

      addresses:
          addresses ??
          this.addresses,

      partners:
          partners ??
          this.partners,

      companies:
          companies ??
          this.companies,

      jobs:
          jobs ??
          this.jobs,

      contractTypes:
          contractTypes ??
          this.contractTypes,

      experiences:
          experiences ??
          this.experiences,

      categories:
          categories ??
          this.categories,

      recruiters:
          recruiters ??
          this.recruiters,

      websites:
          websites ??
          this.websites,

      skills:
          skills ??
          this.skills,

      locations:
          locations ??
          this.locations,

      stages:
          stages ??
          this.stages,

      selectedRecruitmentType:
          selectedRecruitmentType ??
          this.selectedRecruitmentType,

      selectedAddressId:
          selectedAddressId ??
          this.selectedAddressId,

      selectedRequestedById:
          selectedRequestedById ??
          this.selectedRequestedById,

      selectedCompanyId:
          selectedCompanyId ??
          this.selectedCompanyId,

      selectedJobId:
          selectedJobId ??
          this.selectedJobId,

      selectedContractTypeId:
          selectedContractTypeId ??
          this.selectedContractTypeId,

      selectedExperienceId:
          selectedExperienceId ??
          this.selectedExperienceId,

      selectedCategoryId:
          selectedCategoryId ??
          this.selectedCategoryId,

      selectedRecruiterId:
          selectedRecruiterId ??
          this.selectedRecruiterId,

      selectedWebsiteId:
          selectedWebsiteId ??
          this.selectedWebsiteId,

      selectedInterviewerIds:
          selectedInterviewerIds ??
          this.selectedInterviewerIds,

      selectedLocationIds:
          selectedLocationIds ??
          this.selectedLocationIds,

      selectedStageIds:
          selectedStageIds ??
          this.selectedStageIds,

      selectedPrimarySkillIds:
          selectedPrimarySkillIds ??
          this.selectedPrimarySkillIds,

      selectedSecondarySkillIds:
          selectedSecondarySkillIds ??
          this.selectedSecondarySkillIds,
    );
  }
}

