import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/core/constants/app_colors.dart';
import 'package:flutter_app/features/attendance/cubit/attendance_report_cubit.dart';
import 'package:flutter_app/features/attendance/cubit/attendance_report_state.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'daily_attendance_detail.dart';

/// Main page for displaying the Check-In/Check-Out attendance report.
class InOutReportPage extends StatelessWidget {
  const InOutReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      // Initialize the cubit and fetch the initial report
      create: (context) => AttendanceReportCubit()..fetchReport(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(
          children: [
            const _ReportHeader(), // Sticky header with date range selector
            Expanded(
              child: BlocBuilder<AttendanceReportCubit, AttendanceReportState>(
                builder: (context, state) {
                  // Show loading spinner while fetching data
                  if (state.status == ReportStatus.loading) {
                    final isDark = Theme.of(context).brightness == Brightness.dark;
                    return Shimmer.fromColors(
                      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: 4,
                        itemBuilder: (context, index) => Container(
                          height: 120,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    );
                  }
                  
                  // Show empty state if no records exist for the selected range
                  if (state.records.isEmpty) {
                    return _buildEmptyState(context, l10n);
                  }
                  
                  // Display the list of attendance records
                  final consolidated = _consolidateDailyRecords(state.records);
                  if (consolidated.isEmpty) {
                    return _buildEmptyState(context, l10n);
                  }
                  
                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: consolidated.length,
                    itemBuilder: (context, index) {
                      final record = consolidated[index];
                      return _AttendanceCard(record: record);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _consolidateDailyRecords(List<dynamic> records) {
    final Map<String, List<Map<String, dynamic>>> groups = {};
    for (final rawRec in records) {
      if (rawRec is! Map) continue;
      final rec = Map<String, dynamic>.from(rawRec);
      final rawCheckIn = rec['check_in'];
      if (rawCheckIn == null || rawCheckIn == false) continue;
      
      final String checkInStr = rawCheckIn.toString();
      final DateTime checkInLocal = DateTime.parse("${checkInStr.replaceAll(' ', 'T')}Z").toLocal();
      final dateKey = DateFormat('yyyy-MM-dd').format(checkInLocal);
      
      if (!groups.containsKey(dateKey)) {
        groups[dateKey] = [];
      }
      groups[dateKey]!.add(rec);
    }
    
    final List<Map<String, dynamic>> consolidated = [];
    final sortedKeys = groups.keys.toList()..sort((a, b) => b.compareTo(a));
    
    for (final key in sortedKeys) {
      final dayRecords = groups[key]!;
      if (dayRecords.isEmpty) continue;
      
      dayRecords.sort((a, b) {
        final aIn = a['check_in'].toString();
        final bIn = b['check_in'].toString();
        return aIn.compareTo(bIn);
      });
      
      final earliestRecord = dayRecords.first;
      
      double totalWorkedHours = 0.0;
      double totalOvertimeHours = 0.0;
      double totalValidatedOT = 0.0;
      
      String? latestCheckOutStr;
      DateTime? latestCheckOut;
      Map<String, dynamic>? latestCheckOutRecord;
      bool stillWorking = false;
      
      for (final rec in dayRecords) {
        totalWorkedHours += (rec['worked_hours'] ?? 0.0).toDouble();
        totalOvertimeHours += (rec['overtime_hours'] ?? 0.0).toDouble();
        totalValidatedOT += (rec['validated_overtime_hours'] ?? 0.0).toDouble();
        
        final checkOutVal = rec['check_out'];
        if (checkOutVal == null || checkOutVal == false || checkOutVal.toString().isEmpty) {
          stillWorking = true;
        } else {
          final DateTime outTime = DateTime.parse("${checkOutVal.toString().replaceAll(' ', 'T')}Z").toLocal();
          if (latestCheckOut == null || outTime.isAfter(latestCheckOut)) {
            latestCheckOut = outTime;
            latestCheckOutStr = checkOutVal.toString();
            latestCheckOutRecord = rec;
          }
        }
      }
      
      final Map<String, dynamic> consolidatedRecord = {
        'check_in': earliestRecord['check_in'],
        'check_out': stillWorking ? false : latestCheckOutStr,
        'worked_hours': totalWorkedHours,
        'overtime_hours': totalOvertimeHours,
        'validated_overtime_hours': totalValidatedOT,
        'in_latitude': earliestRecord['in_latitude'],
        'in_longitude': earliestRecord['in_longitude'],
        'out_latitude': latestCheckOutRecord != null ? latestCheckOutRecord['out_latitude'] : null,
        'out_longitude': latestCheckOutRecord != null ? latestCheckOutRecord['out_longitude'] : null,
        'entries': dayRecords,
      };
      
      consolidated.add(consolidatedRecord);
    }
    
    return consolidated;
  }

  /// Helper widget to show when no records are found.
  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_toggle_off, size: 80, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1)),
          const SizedBox(height: 16),
          Text(
            l10n.no_records_found,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

/// Header widget containing the title and date range picker buttons.
class _ReportHeader extends StatelessWidget {
  const _ReportHeader();

  /// Opens the date picker and updates the cubit state.
  Future<void> _selectDate(BuildContext context, bool isFrom, AttendanceReportState state) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? state.fromDate : state.toDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryPurple,
              onPrimary: AppColors.cardBg,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final cubit = context.read<AttendanceReportCubit>();
      if (isFrom) {
        cubit.updateDateRange(picked, state.toDate);
      } else {
        cubit.updateDateRange(state.fromDate, picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<AttendanceReportCubit, AttendanceReportState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
         decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.indigo, AppColors.brightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          child: Column(
            children: [
              // Back button and Page Title
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios, color: AppColors.cardBg, size: 20),
                  ),
                  Expanded(
                    child: Text(
                      l10n.attendance_report,
                      style: const TextStyle(color: AppColors.cardBg, fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 24),
              // From and To date selection buttons
              Row(
                children: [
                  Expanded(
                    child: _DateButton(
                      label: l10n.from,
                      date: state.fromDate,
                      onTap: () => _selectDate(context, true, state),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(Icons.arrow_forward, color: AppColors.lightPurple, size: 16),
                  ),
                  Expanded(
                    child: _DateButton(
                      label: l10n.to,
                      date: state.toDate,
                      onTap: () => _selectDate(context, false, state),
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

/// Custom button for the date picker.
class _DateButton extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback onTap;

  const _DateButton({required this.label, required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.cardBg.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBg.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: AppColors.lightPurple, fontSize: 11)),
            const SizedBox(height: 4),
            Text(
              DateFormat('dd MMM, yyyy').format(date),
              style: const TextStyle(color: AppColors.cardBg, fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual card representing one attendance record.
/// Handles parsing and displaying worked hours, overtime, and location data.
class _AttendanceCard extends StatelessWidget {
  final dynamic record;
  const _AttendanceCard({required this.record});

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Extract raw data from the Odoo response map
    final rawCheckIn = record['check_in'];
    final rawCheckOut = record['check_out'];
    final workedHours = (record['worked_hours'] ?? 0.0).toDouble();
    final overtimeHours = (record['overtime_hours'] ?? 0.0).toDouble();
    final validatedOT = (record['validated_overtime_hours'] ?? 0.0).toDouble();
    
    final inLat = record['in_latitude'];
    final inLong = record['in_longitude'];
    final outLat = record['out_latitude'];
    final outLong = record['out_longitude'];

    // Early exit if check-in is missing
    if (rawCheckIn == null || rawCheckIn == false) return const SizedBox.shrink();

    // Parse Odoo UTC date strings (converting "yyyy-MM-dd HH:mm:ss" to ISO format first)
    final String checkInStr = rawCheckIn.toString();
    final DateTime checkIn = DateTime.parse("${checkInStr.replaceAll(' ', 'T')}Z").toLocal();
    
    DateTime? checkOut;
    if (rawCheckOut != null && rawCheckOut is String && rawCheckOut.isNotEmpty) {
      checkOut = DateTime.parse("${rawCheckOut.replaceAll(' ', 'T')}Z").toLocal();
    }

    final bool isClosed = checkOut != null;

    double displayWorkedHours = workedHours;
    if (!isClosed) {
      displayWorkedHours = DateTime.now().difference(checkIn).inSeconds / 3600.0;
      if (displayWorkedHours < 0) displayWorkedHours = 0.0;
    }

    // Check if location data was captured
    final bool hasInLoc = inLat != null && inLat != 0.0;
    final bool hasOutLoc = outLat != null && outLat != 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border(
          left: BorderSide(
            color: Colors.primaries[record.hashCode % Colors.primaries.length],
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DailyAttendanceDetailPage(record: record),
              ),
            );
          },
          child: Column(
            children: [
              // Upper section: Status icon, Date, and Worked Hours
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: (isClosed ? AppColors.successGreen : AppColors.orange).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isClosed ? Icons.check_circle_outline : Icons.timer_outlined,
                        color: isClosed ? AppColors.successGreen : AppColors.orange,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('EEEE, dd MMM').format(checkIn),
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Theme.of(context).colorScheme.onSurface),
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                isClosed ? l10n.completed : l10n.still_working,
                                style: TextStyle(
                                  color: isClosed ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6) : AppColors.orange,
                                  fontSize: 12,
                                ),
                              ),
                              if (record['entries'] != null && (record['entries'] as List).length > 1) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    l10n.sessions_count((record['entries'] as List).length),
                                    style: const TextStyle(color: AppColors.blue, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _formatDuration(displayWorkedHours, l10n),
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).primaryColor),
                        ),
                        if (overtimeHours > 0)
                          Text(
                            '+${_formatDuration(overtimeHours, l10n)} OT',
                            style: const TextStyle(fontSize: 11, color: AppColors.successGreen, fontWeight: FontWeight.w600),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Lower section: Time Details (In, Out, Break) and Locations
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTimeInfo(context, l10n.in_label, DateFormat('hh:mm:ss a').format(checkIn), AppColors.blue, 
                          subtitle: hasInLoc ? '${inLat.toStringAsFixed(2)}, ${inLong.toStringAsFixed(2)}' : null),
                        _buildTimeInfo(
                          context,
                          l10n.out, 
                          isClosed ? DateFormat('hh:mm:ss a').format(checkOut) : '--:--', 
                          isClosed ? AppColors.dangerRed : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          subtitle: hasOutLoc ? '${outLat.toStringAsFixed(2)}, ${outLong.toStringAsFixed(2)}' : null
                        ),
                      ],
                    ),
                    // Show Validated Overtime row if applicable
                    if (validatedOT > 0) ...[
                      const SizedBox(height: 12),
                      const Divider(height: 1, indent: 20, endIndent: 20),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.verified_outlined, size: 14, color: AppColors.successGreen),
                          const SizedBox(width: 6),
                          Text(
                            '${l10n.validated_overtime}: ${validatedOT.toStringAsFixed(2)} hrs',
                            style: const TextStyle(fontSize: 12, color: AppColors.successGreen, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper to build a column for time info (Label, Time, and optional Subtitle like GPS).
  Widget _buildTimeInfo(BuildContext context, String label, String time, Color color, {String? subtitle}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), fontSize: 11)),
          const SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4), fontSize: 9),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
