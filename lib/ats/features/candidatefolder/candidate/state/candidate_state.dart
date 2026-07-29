import 'hr_candidate_model.dart';

class CandidateState {
  final String selectedTab;
  final String searchQuery;
  final List<HrCandidate> candidates;
  final bool isLoading;
  final HrCandidate? selectedCandidate;
  final List<String> activeRequiredSkills;

  // Dynamic dropdown lists fetched from Odoo backend
  final List<Map<String, dynamic>> degrees;
  final List<Map<String, dynamic>> managers;
  final List<Map<String, dynamic>> companies;
  final List<Map<String, dynamic>> skillTypes;
  final List<Map<String, dynamic>> skillLevels;
  final List<Map<String, dynamic>> skills;
  //
  // final List<Map<String, dynamic>> jobPositions;
  // final List<Map<String, dynamic>> applicationStatuses;

  const CandidateState({
    required this.selectedTab,
    required this.searchQuery,
    required this.candidates,
    this.isLoading = false,
    this.selectedCandidate,
    this.activeRequiredSkills = const ['Flutter', 'Dart', 'Firebase', 'REST API', 'Git', 'Bloc'],
    this.degrees = const [],
    this.managers = const [],
    this.companies = const [],
    this.skillTypes = const [],
    this.skillLevels = const [],
    this.skills = const [],
    // this.jobPositions = const [],
    // this.applicationStatuses = const [],  
  });

  // Dynamically compute counts based on the current candidate lists
  Map<String, int> get tabCounts {
    final counts = {
      "Applied": 0,
      "Screening": 0,
      "HR Round": 0,
      "Technical Round": 0,
      "Presentation": 0,
    };
    for (var c in candidates) {
      if (counts.containsKey(c.stage)) {
        counts[c.stage] = counts[c.stage]! + 1;
      }
    }
    return counts;
  }

  factory CandidateState.initial() {
    final initialCandidates = const <HrCandidate>[];

    return CandidateState(
      selectedTab: "Applied",
      searchQuery: "",
      candidates: initialCandidates,
      isLoading: false,
      degrees: const [],
      managers: const [],
      companies: const [],
      skillTypes: const [],
      skillLevels: const [],
      skills: const [],
      // jobPositions: const [],
      // applicationStatuses: const [],  
    );
  }

  CandidateState copyWith({
    String? selectedTab,
    String? searchQuery,
    List<HrCandidate>? candidates,
    bool? isLoading,
    HrCandidate? selectedCandidate,
    List<String>? activeRequiredSkills,
    List<Map<String, dynamic>>? degrees,
    List<Map<String, dynamic>>? managers,
    List<Map<String, dynamic>>? companies,
    List<Map<String, dynamic>>? skillTypes,
    List<Map<String, dynamic>>? skillLevels,
    List<Map<String, dynamic>>? skills,
  }) {
    return CandidateState(
      selectedTab: selectedTab ?? this.selectedTab,
      searchQuery: searchQuery ?? this.searchQuery,
      candidates: candidates ?? this.candidates,
      isLoading: isLoading ?? this.isLoading,
      selectedCandidate: selectedCandidate ?? this.selectedCandidate,
      activeRequiredSkills: activeRequiredSkills ?? this.activeRequiredSkills,
      degrees: degrees ?? this.degrees,
      managers: managers ?? this.managers,
      companies: companies ?? this.companies,
      skillTypes: skillTypes ?? this.skillTypes,
      skillLevels: skillLevels ?? this.skillLevels,
      skills: skills ?? this.skills,
    );
  }
}
