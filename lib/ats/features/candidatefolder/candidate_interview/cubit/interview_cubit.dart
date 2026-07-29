import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/features/candidatefolder/candidate_interview/state/interview_state.dart';
import '../../../my_applications/state/my_application_state.dart';

class CandidateInterviewCubit
    extends Cubit<CandidateInterviewState> {

  CandidateInterviewCubit()
      : super(
          CandidateInterviewState.initial(),
        );

  void changeTab(String tab) {

    emit(
      state.copyWith(
        selectedTab: tab,
      ),
    );
  }

  void loadInterviews(
    List<ApplicationData> interviews,
  ) {

    emit(
      state.copyWith(
        interviews: interviews,
      ),
    );
  }
}
