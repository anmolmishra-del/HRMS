class InterviewFeedbackState {
  final int selectedTab;

  final Map<int, int> overallRating;
  final Map<int, int> technical;
  final Map<int, int> communication;
  final Map<int, int> problemSolving;

  final Map<int, String> remarks; // good/bad
  final Map<int, String> comments;

  final bool isSubmitting;
  final bool success;

  InterviewFeedbackState({
    this.selectedTab = 0,
    this.overallRating = const {},
    this.technical = const {},
    this.communication = const {},
    this.problemSolving = const {},
    this.remarks = const {},
    this.comments = const {},
    this.isSubmitting = false,
    this.success = false,
  });

  InterviewFeedbackState copyWith({
    int? selectedTab,
    Map<int, int>? overallRating,
    Map<int, int>? technical,
    Map<int, int>? communication,
    Map<int, int>? problemSolving,
    Map<int, String>? remarks,
    Map<int, String>? comments,
    bool? isSubmitting,
    bool? success,
  }) {
    return InterviewFeedbackState(
      selectedTab: selectedTab ?? this.selectedTab,
      overallRating: overallRating ?? this.overallRating,
      technical: technical ?? this.technical,
      communication: communication ?? this.communication,
      problemSolving: problemSolving ?? this.problemSolving,
      remarks: remarks ?? this.remarks,
      comments: comments ?? this.comments,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      success: success ?? this.success,
    );
  }
}
