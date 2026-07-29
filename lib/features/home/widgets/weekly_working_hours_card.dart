import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/features/attendance/cubit/attendance_cubit.dart';
import 'package:flutter_app/features/attendance/cubit/attendance_state.dart';
import 'package:flutter_app/l10n/app_localizations.dart';

class WeeklyWorkingHoursCard extends StatelessWidget {
  const WeeklyWorkingHoursCard({super.key});

  String _formatDuration(double hours, AppLocalizations l10n) {
    if (hours <= 0) return l10n.duration_mins(0);
    final int totalMinutes = (hours * 60).round();
    final int h = totalMinutes ~/ 60;
    final int m = totalMinutes % 60;
    if (h > 0) {
      if (m > 0) {
        return l10n.duration_hours_mins(h, m);
      } else {
        return h == 1 ? l10n.duration_hours_one : l10n.duration_hours(h);
      }
    } else {
      return m == 1 ? l10n.duration_mins_one : l10n.duration_mins(m);
    }
  }

  String _formatCompactDuration(double hours) {
    if (hours <= 0) return '';
    final int totalMinutes = (hours * 60).round();
    final int h = totalMinutes ~/ 60;
    final int m = totalMinutes % 60;
    if (h > 0) {
      return m > 0 ? '${h}h ${m}m' : '${h}h';
    } else {
      return '${m}m';
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> dayColors = [
      const Color(0xFFFF7675), // Coral
      const Color(0xFF6C5CE7), // Purple
      const Color(0xFF00CEC9), // Turquoise
      const Color(0xFF0984E3), // Blue
      const Color(0xFF2ECC71), // Green
      const Color(0xFFFDCB6E), // Amber
      const Color(0xFFE74C3C), // Red
    ];
    final List<String> dayNames = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return BlocBuilder<AttendanceCubit, AttendanceState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        final List<double> hoursList = state.weeklyHours;
        final double totalHours = hoursList.fold(0.0, (sum, val) => sum + val);

        // Find max to scale bar heights, fallback to 8.0/9.0 minimum scale
        double maxHours = hoursList.fold(0.0, (max, val) => val > max ? val : max);
        double scaleLimit = maxHours > 9.0 ? maxHours : 9.0;

        return Container(
          width: double.infinity,
          height: 160,
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Theme.of(context).dividerColor,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor.withOpacity(0.02),
                  ),
                ),
              ),
              Positioned(
                right: 30,
                bottom: -20,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF00CEC9).withOpacity(0.03),
                  ),
                ),
              ),
              Row(
                children: [
                  // Left text column
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.this_week,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6) ?? const Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _formatDuration(totalHours, l10n),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.working_hours_logged,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6) ?? const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Right bar chart
                  Expanded(
                    flex: 6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(7, (index) {
                        final double hours = hoursList[index];
                        final String day = dayNames[index];
                        final Color color = dayColors[index];

                        final double pct = scaleLimit > 0 ? (hours / scaleLimit) : 0.0;
                        final double height = 8 + (pct * 62); // Ranges from 8px to 70px

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              hours > 0 ? _formatCompactDuration(hours) : '',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: hours > 0
                                    ? color
                                    : Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.4) ?? const Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 10,
                              height: height,
                              decoration: BoxDecoration(
                                color: hours > 0 ? color : const Color(0xFF475569).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              day,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: hours > 0
                                    ? color
                                    : Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.4) ?? const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
