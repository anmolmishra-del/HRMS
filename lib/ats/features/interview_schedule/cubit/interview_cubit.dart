import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/features/my_applications/cubit/my_application_cubit.dart';
import '../state/interview_state.dart';

class InterviewScheduleCubit extends Cubit<InterviewScheduleState> {
  InterviewScheduleCubit() : super(InterviewScheduleState.initial());

  // ================= CONTROLLERS =================
  final candidateController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final linkController = TextEditingController();
final interviewerController = TextEditingController();
final emailController = TextEditingController();
  // ================= UPDATE TYPE =================
  void updateInterviewType(String type) {
    emit(state.copyWith(interviewType: type));
  }

  void toggleMeeting(bool value) {
    emit(state.copyWith(meetingEnabled: value));
  }

  // ================= DATE PICKER =================
  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final formatted = "${picked.year}-${picked.month}-${picked.day}";
      dateController.text = formatted;

      emit(state.copyWith(selectedDate: picked));
    }
  }

  // ================= TIME PICKER =================
  Future<void> pickTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      final formattedTime = time.format(context);
      timeController.text = formattedTime;

      emit(state.copyWith(selectedTime: time));
    }
  }

  // ================= VALIDATION =================
  bool _validate() {
    return candidateController.text.trim().isNotEmpty &&
        dateController.text.isNotEmpty &&
        timeController.text.isNotEmpty;
  }

  // ================= SUBMIT =================
  Future<void> schedule(BuildContext context) async {
    // ❗ validate FIRST (FIXED)
    if (!_validate()) {
      emit(state.copyWith(
        isError: true,
        errorMessage: "Please fill all required fields",
      ));
      return;
    }

    emit(state.copyWith(
      isLoading: true,
      isError: false,
      isSuccess: false,
    ));

    try {
      final requestBody = {
        "candidate": candidateController.text.trim(),
        "interviewType": state.interviewType,
        "date": dateController.text,
        "time": timeController.text,
        "meetingLink": linkController.text.trim(),
        "interviewers": state.interviewers
            .map((e) => {
                  "name": e.name,
                  "avatar": e.avatar,
                })
            .toList(),
      };

      debugPrint("📦 Interview Request: $requestBody");

      // 🔥 Replace with real API
      await Future.delayed(const Duration(seconds: 2),);
       context
        .read<MyApplicationCubit>()
        .scheduleInterview(

          candidateName:
              candidateController.text,

          interviewDate:
              dateController.text,

          interviewTime:
              timeController.text,

          meetingLink:
              linkController.text,

          interviewType:
              state.interviewType,
        );

      

      emit(state.copyWith(
        isLoading: false,
        isSuccess: true,
      ));

      _clearForm();
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isError: true,
        errorMessage: e.toString(),
      ));
    }
  }

  // ================= INTERVIEWERS =================
  void addInterviewer(String name) {
    if (name.trim().isEmpty) return;

    final updated = List<Interviewer>.from(state.interviewers)
      ..add(
        Interviewer(
          name: name.trim(),
          avatar: "https://i.pravatar.cc/150?u=$name",
        ),
      );

    emit(state.copyWith(interviewers: updated));
  }

  void removeInterviewer(String name) {
    final updated = List<Interviewer>.from(state.interviewers)
      ..removeWhere((e) => e.name == name);

    emit(state.copyWith(interviewers: updated));
  }

  // ================= CLEAR FORM =================
  void _clearForm() {
    candidateController.clear();
    dateController.clear();
    timeController.clear();
    linkController.clear();

    emit(state.copyWith(
      selectedDate: null,
      selectedTime: null,
      interviewType: "Technical Round",
      meetingEnabled: false,
    ));
  }

  // ================= DISPOSE =================
  @override
  Future<void> close() {
    candidateController.dispose();
    dateController.dispose();
    timeController.dispose();
    linkController.dispose();
      interviewerController.dispose();
        emailController.dispose();
    return super.close();
  }
}
