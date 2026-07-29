import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/features/my_applications/state/my_application_state.dart';

class MyApplicationCubit
    extends Cubit<MyApplicationState> {

  MyApplicationCubit()
      : super(MyApplicationState.initial());

  // APPLY JOB
 void applyJob({
  required String title,
  required String company,

  required String location,
  required String experience,
  required String salary,

  required String status,
required String type,
required String candidateName,

}) {

    final newApplication =
    ApplicationData(

  title: title,
  company: company,
candidateName: candidateName,
  location: location,
  experience: experience,
  salary: salary,

  status: status,
type: type,
  isCompleted: false,
  currentStep: 0,
);

    final updated = [
      newApplication,
      ...state.applications,
    ];

    emit(
      state.copyWith(
        applications: updated,
      ),
    );
  }

  // INTERVIEW SCHEDULE
  // void scheduleInterview(int index) {

  //   final updated =
  //       List<ApplicationData>.from(
  //     state.applications,
  //   );

  //   updated[index] =
  //       updated[index].copyWith(
  //     status: "Interview Scheduled",
  //   );

  //   emit(
  //     state.copyWith(
  //       applications: updated,
  //     ),
  //   );
  // }
void scheduleInterview({

  required String candidateName,

  required String interviewDate,

  required String interviewTime,

  required String meetingLink,

  required String interviewType,
}) {

  final updated =
      state.applications.map((e) {
debugPrint(
  "TOTAL APPS: ${state.applications.length}",
);
    if (e.candidateName.trim().toLowerCase() ==
        candidateName.trim().toLowerCase()) {

      return e.copyWith(

        status: interviewType,

        interviewDate:
            interviewDate,

        interviewTime:
            interviewTime,

        meetingLink:
            meetingLink,
      );
    }

    return e;

  }).toList();

  emit(
    state.copyWith(
      applications: updated,
    ),
  );
}
  // COMPLETE APPLICATION
  void completeApplication(int index) {

    final updated =
        List<ApplicationData>.from(
      state.applications,
    );

    updated[index] =
        updated[index].copyWith(
      status: "Completed",
      isCompleted: true,
    );

    emit(
      state.copyWith(
        applications: updated,
      ),
    );
  }

  // ACTIVE TAB
  void showActive() {
    emit(
      state.copyWith(
        showCompleted: false,
      ),
    );
  }

  // COMPLETED TAB
  void showCompleted() {
    emit(
      state.copyWith(
        showCompleted: true,
      ),
    );
  }
}
