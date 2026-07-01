import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/features/interview_feedback/state/interview_feedback_state.dart';

class InterviewFeedbackCubit extends Cubit<InterviewFeedbackState> {
  InterviewFeedbackCubit() : super(InterviewFeedbackState());

  void changeTab(int index) {
    emit(state.copyWith(selectedTab: index));
  }

  void setRating(int round, String type, int value) {
    if (type == "overall") {
      final map = {...state.overallRating};
      map[round] = value;
      emit(state.copyWith(overallRating: map));
    }

    if (type == "tech") {
      final map = {...state.technical};
      map[round] = value;
      emit(state.copyWith(technical: map));
    }

    if (type == "communication") {
      final map = {...state.communication};
      map[round] = value;
      emit(state.copyWith(communication: map));
    }

    if (type == "problem") {
      final map = {...state.problemSolving};
      map[round] = value;
      emit(state.copyWith(problemSolving: map));
    }
  }

  void setRemark(int round, String value) {
    final map = {...state.remarks};
    map[round] = value;
    emit(state.copyWith(remarks: map));
  }

  void setComment(int round, String value) {
    final map = {...state.comments};
    map[round] = value;
    emit(state.copyWith(comments: map));
  }

  Future<bool> submit(int round) async {
    emit(state.copyWith(isSubmitting: true));

    await Future.delayed(const Duration(seconds: 1)); // API CALL

    emit(state.copyWith(isSubmitting: false, success: true));
    return true;
  }
  bool canSubmit(
  int round,
  InterviewFeedbackState state,
) {

  final comment =
      state.comments[round] ?? "";

  // / ROUND 1
  if (round == 0) {

    return

        (state.technical[round] ?? 0) > 0 &&

        (state.communication[round] ?? 0) > 0 &&

        (state.overallRating[round] ?? 0) > 0 &&

        comment.trim().isNotEmpty;
  }

  /// ROUND 2
  if (round == 1) {

    return

        (state.technical[round] ?? 0) > 0 &&

        (state.communication[round] ?? 0) > 0 &&

        (state.problemSolving[round] ?? 0) > 0 &&

        comment.trim().isNotEmpty;
  }

  /// ROUND 3
  return

      (state.technical[round] ?? 0) > 0 &&

      (state.communication[round] ?? 0) > 0 &&

      (state.problemSolving[round] ?? 0) > 0 &&

      comment.trim().isNotEmpty;
}
}

  // bool canSubmit(int round, InterviewFeedbackState state) {}}
