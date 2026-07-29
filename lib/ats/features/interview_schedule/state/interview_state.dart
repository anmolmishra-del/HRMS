import 'package:flutter/material.dart';

class Interviewer {
  final String name;
  final String avatar;

  const Interviewer({
    required this.name,
    required this.avatar,
  });
}

class InterviewScheduleState {
  final String candidateName;
  final String interviewType;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;

  final List<Interviewer> interviewers;

  final bool meetingEnabled;
  final String meetingLink;

  final bool isLoading;
  final bool isSuccess;
  final bool isError;
  final String? errorMessage;

  const InterviewScheduleState({
    this.candidateName = "",
    this.interviewType = "Technical Round",
    this.selectedDate,
    this.selectedTime,
    this.interviewers = const [],
    this.meetingEnabled = false,
    this.meetingLink = "",
    this.isLoading = false,
    this.isSuccess = false,
    this.isError = false,
    this.errorMessage,
  });

  factory InterviewScheduleState.initial() {
    return const InterviewScheduleState();
  }

  InterviewScheduleState copyWith({
    String? candidateName,
    String? interviewType,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    List<Interviewer>? interviewers,
    bool? meetingEnabled,
    String? meetingLink,
    bool? isLoading,
    bool? isSuccess,
    bool? isError,
    String? errorMessage,
  }) {
    return InterviewScheduleState(
      candidateName: candidateName ?? this.candidateName,
      interviewType: interviewType ?? this.interviewType,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      interviewers: interviewers ?? List.from(this.interviewers),
      meetingEnabled: meetingEnabled ?? this.meetingEnabled,
      meetingLink: meetingLink ?? this.meetingLink,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
