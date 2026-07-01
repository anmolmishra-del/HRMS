import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/features/recruiter/state/recruiter_profile_state.dart';


class RecruiterProfileCubit
    extends Cubit<RecruiterProfileState> {

  RecruiterProfileCubit()
      : super(
          RecruiterProfileState.initial(),
        );

  void updateProfile({

    required String name,
    required String role,
    required String email,
    required String phone,
    required String location,
  }) {

    emit(
      state.copyWith(

        name: name,

        role: role,

        email: email,

        phone: phone,

        location: location,
      ),
    );
  }
}
