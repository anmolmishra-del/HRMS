import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/features/onboard_check/model/model_class.dart';
import 'package:flutter_app/ats/features/onboard_check/state/onboard_checklist_state.dart';


class OnboardingCubit
    extends Cubit<OnboardingState> {

  OnboardingCubit()
      : super(OnboardingInitial()) {

    loadChecklist();
  }

  List<ChecklistModel> checklist = [

    ChecklistModel(
      title: "Offer Accepted",
      isCompleted: true,
    ),

    ChecklistModel(
      title: "Upload Documents",
      isCompleted: true,
    ),

    ChecklistModel(
      title: "Background Verification",
      isCompleted: true,
    ),

    ChecklistModel(
      title: "HR Approval",
      isCompleted: true,
    ),
  ];

  void loadChecklist() {

    emit(
      OnboardingLoaded(
        List.from(checklist),
      ),
    );
  }

  bool isAllCompleted() {

    return checklist.every(
      (item) => item.isCompleted,
    );
  }
}
