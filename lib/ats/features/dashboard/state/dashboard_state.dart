class DashboardState {
  final bool isLoading;
  final String? error;
  final String selectedFilter;
  final List<String> titles;
  final List<int> counts;
  final List<double> chartValues;
  final String name;  
  
  // Lists for dashboard preview
  final List<Map<String, dynamic>> recentApplications;
  final List<Map<String, dynamic>> recentCandidates;

  const DashboardState({
    required this.isLoading,
    required this.error,
    required this.selectedFilter,
    required this.titles,
    required this.counts,
    required this.chartValues,
    required this.name,
    required this.recentApplications,
    required this.recentCandidates,
  });

factory DashboardState.initial() {
  return const DashboardState(
    name: "",
    isLoading: false,
    error: null,
    selectedFilter: "This Month",

    titles: [
      "Open Positions",
      "Applications",
      "Candidates",
    ],

    counts: [],
    chartValues: [],
    recentApplications: [],
    recentCandidates: [],
  );
}

  DashboardState copyWith({
    bool? isLoading,
    String? error,
    String? selectedFilter,
    List<String>? titles,
    List<int>? counts,
    List<double>? chartValues,
    String? name,
    List<Map<String, dynamic>>? recentApplications,
    List<Map<String, dynamic>>? recentCandidates,
  }) {
    return DashboardState(
      name: name ?? this.name,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      titles: titles ?? this.titles,
      counts: counts ?? this.counts,
      chartValues: chartValues ?? this.chartValues,
      recentApplications: recentApplications ?? this.recentApplications,
      recentCandidates: recentCandidates ?? this.recentCandidates,
    );
  }
}
