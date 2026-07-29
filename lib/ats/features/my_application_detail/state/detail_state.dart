// application_details_state.dart

class ApplicationDetailsState {
  final int selectedTab;

  const ApplicationDetailsState({
    required this.selectedTab,
  });

  factory ApplicationDetailsState.initial() {
    return const ApplicationDetailsState(
      selectedTab: 0,
    );
  }

  ApplicationDetailsState copyWith({
    int? selectedTab,
  }) {
    return ApplicationDetailsState(
      selectedTab:
          selectedTab ?? this.selectedTab,
    );
  }
}
