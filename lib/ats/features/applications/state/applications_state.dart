import 'hr_applicant_model.dart';

class ApplicationsState {
  final List<HrApplicant> applications;
  final HrApplicant? selectedApplication;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final String selectedTab; // stage name or ongoing/hired status filter

  // Dropdown lists fetched from Odoo
  final List<Map<String, dynamic>> jobs;
  final List<Map<String, dynamic>> recruiters;
  final List<Map<String, dynamic>> departments;
  final List<Map<String, dynamic>> companies;
  final List<Map<String, dynamic>> degrees;
  final List<Map<String, dynamic>> candidates;
  final List<Map<String, dynamic>> locations;
  final List<Map<String, dynamic>> skillTypes;
  final List<Map<String, dynamic>> sources;
  final List<Map<String, dynamic>> mediums;

  const ApplicationsState({
    required this.applications,
    this.selectedApplication,
    required this.isLoading,
    this.error,
    required this.searchQuery,
    required this.selectedTab,
    required this.jobs,
    required this.recruiters,
    required this.departments,
    required this.companies,
    required this.degrees,
    required this.candidates,
    required this.locations,
    required this.skillTypes,
    required this.sources,
    required this.mediums,
  });

  factory ApplicationsState.initial() {
    return const ApplicationsState(
      applications: [],
      selectedApplication: null,
      isLoading: false,
      error: null,
      searchQuery: '',
      selectedTab: 'All',
      jobs: [],
      recruiters: [],
      departments: [],
      companies: [],
      degrees: [],
      candidates: [],
      locations: [],
      skillTypes: [],
      sources: [],
      mediums: [],
    );
  }

  ApplicationsState copyWith({
    List<HrApplicant>? applications,
    HrApplicant? Function()? selectedApplication,
    bool? isLoading,
    String? Function()? error,
    String? searchQuery,
    String? selectedTab,
    List<Map<String, dynamic>>? jobs,
    List<Map<String, dynamic>>? recruiters,
    List<Map<String, dynamic>>? departments,
    List<Map<String, dynamic>>? companies,
    List<Map<String, dynamic>>? degrees,
    List<Map<String, dynamic>>? candidates,
    List<Map<String, dynamic>>? locations,
    List<Map<String, dynamic>>? skillTypes,
    List<Map<String, dynamic>>? sources,
    List<Map<String, dynamic>>? mediums,
  }) {
    return ApplicationsState(
      applications: applications ?? this.applications,
      selectedApplication: selectedApplication != null ? selectedApplication() : this.selectedApplication,
      isLoading: isLoading ?? this.isLoading,
      error: error != null ? error() : this.error,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedTab: selectedTab ?? this.selectedTab,
      jobs: jobs ?? this.jobs,
      recruiters: recruiters ?? this.recruiters,
      departments: departments ?? this.departments,
      companies: companies ?? this.companies,
      degrees: degrees ?? this.degrees,
      candidates: candidates ?? this.candidates,
      locations: locations ?? this.locations,
      skillTypes: skillTypes ?? this.skillTypes,
      sources: sources ?? this.sources,
      mediums: mediums ?? this.mediums,
    );
  }
}
