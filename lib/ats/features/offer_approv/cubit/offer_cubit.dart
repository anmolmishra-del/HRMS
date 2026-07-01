import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_app/ats/core/controllers.dart/controller.dart';

import 'package:flutter_app/ats/features/offer_approv/service/service_file.dart';

import 'package:flutter_app/ats/features/offer_approv/state/offer_state.dart';

class ApprovalCubit extends Cubit<ApprovalState> {

  final ApprovalService service;

  final ApprovalController controller;

  ApprovalCubit({

    required this.service,
    required this.controller,

  }) : super(
    ApprovalState(
      steps: [],
    ),
  );

  Future<void> loadApprovals() async {

    try {

      emit(
        state.copyWith(
          loading: true,
        ),
      );

      final data =
      await service.fetchApprovals();

      emit(
        state.copyWith(
          steps: data,
          loading: false,
        ),
      );

    } catch (e) {

      emit(
        state.copyWith(
          loading: false,
        ),
      );
    }
  }

  void approve(String approvedBy) {

    final updated =
    controller.approveCurrentStep(

      state.steps,

      approvedBy,
    );

    emit(
      state.copyWith(
        steps: updated,
      ),
    );
  }

  void reject({

    required String rejectedBy,

    required String reason,

  }) {

    final updated =
    controller.rejectCurrentStep(

      state.steps,

      rejectedBy,

      reason,
    );

    emit(
      state.copyWith(
        steps: updated,
      ),
    );
  }
}
