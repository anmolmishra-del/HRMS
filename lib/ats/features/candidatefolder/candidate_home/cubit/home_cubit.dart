import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/features/candidatefolder/candidate_home/state/home_state.dart';
import 'package:flutter_app/ats/features/my_applications/state/my_application_state.dart';

class CandidateHomeCubit
    extends Cubit<CandidateHomeState> {

  CandidateHomeCubit()
      : super(
          CandidateHomeState.initial(),
        );

void loadApplications(
  List<ApplicationData> applications,
)
  {

    emit(
      state.copyWith(
        applications: applications,
      ),
    );
  }
}
