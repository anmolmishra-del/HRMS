
import 'package:flutter_app/ats/features/pre_onboarding/model/model_class.dart';

class PreOnboardingState {
  final bool isLoading;
  final List<OnboardingTaskModel> tasks;

  const PreOnboardingState({
    this.isLoading = false,
    this.tasks = const [],
  });

  int get completedCount =>
      tasks.where((e) => e.isCompleted).length;

  double get progress =>
      tasks.isEmpty ? 0 : completedCount / tasks.length;

  PreOnboardingState copyWith({
    bool? isLoading,
    List<OnboardingTaskModel>? tasks,
  }) {
    return PreOnboardingState(
      isLoading: isLoading ?? this.isLoading,
      tasks: tasks ?? this.tasks,
    );
  }
}
