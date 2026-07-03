import 'package:equatable/equatable.dart';

enum AttendanceStatus { initial, loading, success, failure }

class AttendanceState extends Equatable {
  final AttendanceStatus status;
  final bool isCheckedIn;
  final String todayHours;
  final double baseHours; // Total hours from finished sessions
  final List<double> baseWeeklyHours; // Base hours for Mon-Sun fetched from Odoo
  final List<double> weeklyHours; // Live dynamic hours for Mon-Sun (base + active session)
  final String? errorMessage;
  final String? successMessage;

  const AttendanceState({
    this.status = AttendanceStatus.initial,
    this.isCheckedIn = false,
    this.todayHours = "0.00",
    this.baseHours = 0.0,
    this.baseWeeklyHours = const [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
    this.weeklyHours = const [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
    this.errorMessage,
    this.successMessage,
  });

  AttendanceState copyWith({
    AttendanceStatus? status,
    bool? isCheckedIn,
    String? todayHours,
    double? baseHours,
    List<double>? baseWeeklyHours,
    List<double>? weeklyHours,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return AttendanceState(
      status: status ?? this.status,
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
      todayHours: todayHours ?? this.todayHours,
      baseHours: baseHours ?? this.baseHours,
      baseWeeklyHours: baseWeeklyHours ?? this.baseWeeklyHours,
      weeklyHours: weeklyHours ?? this.weeklyHours,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        isCheckedIn,
        todayHours,
        baseHours,
        baseWeeklyHours,
        weeklyHours,
        errorMessage,
        successMessage,
      ];
}
