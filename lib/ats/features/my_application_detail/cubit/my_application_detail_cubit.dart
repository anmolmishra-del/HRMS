// application_details_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/features/my_application_detail/state/detail_state.dart';

class ApplicationDetailsCubit
    extends Cubit<ApplicationDetailsState> {

  ApplicationDetailsCubit()
      : super(
          ApplicationDetailsState.initial(),
        );

  void changeTab(int index) {
    emit(
      state.copyWith(
        selectedTab: index,
      ),
    );
  }
}
