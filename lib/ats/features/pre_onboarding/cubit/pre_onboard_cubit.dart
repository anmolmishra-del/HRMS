import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/features/pre_onboarding/model/model_class.dart';
import 'package:flutter_app/ats/features/pre_onboarding/state/pre_onboard_state.dart';


class PreOnboardingCubit extends Cubit<PreOnboardingState> {
  PreOnboardingCubit() : super(const PreOnboardingState()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    emit(state.copyWith(isLoading: true));

    await Future.delayed(const Duration(milliseconds: 500));

    final tasks = [
      OnboardingTaskModel(
        title: 'Personal Information',
        isCompleted: true,
      ),
      OnboardingTaskModel(
        title: 'Document Upload',
        isCompleted: true,
      ),
      OnboardingTaskModel(
        title: 'Bank Details',
        isCompleted: true,
      ),
      OnboardingTaskModel(
        title: 'Tax Declaration',
        isCompleted: true,
      ),
      OnboardingTaskModel(
        title: 'Policy Acknowledgement',
        isCompleted: true,
      ),
      OnboardingTaskModel(
        title: 'IT Setup Request',
      ),
      OnboardingTaskModel(
        title: 'Asset Request',
      ),
      OnboardingTaskModel(
        title: 'Introduction Video',
      ),
    ];

    emit(state.copyWith(
      isLoading: false,
      tasks: tasks,
    ));
  }

  void toggleTask(int index) {
    final updatedTasks = List<OnboardingTaskModel>.from(state.tasks);

    updatedTasks[index].isCompleted =
        !updatedTasks[index].isCompleted;

    emit(state.copyWith(tasks: updatedTasks));
  }
}
