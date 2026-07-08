import 'package:flutter/material.dart';
import 'package:flutter_app/core/constants/app_colors.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class DailyAttendanceDetailPage extends StatelessWidget {
  final Map<String, dynamic> record;

  const DailyAttendanceDetailPage({super.key, required this.record});

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final rawCheckIn = record['check_in'];
    final rawCheckOut = record['check_out'];
    final workedHours = (record['worked_hours'] ?? 0.0).toDouble();
    final overtimeHours = (record['overtime_hours'] ?? 0.0).toDouble();
    final validatedOT = (record['validated_overtime_hours'] ?? 0.0).toDouble();
    final entries = (record['entries'] as List? ?? [record])
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    // Sort entries chronological (earliest check-in first)
    entries.sort((a, b) {
      final aIn = a['check_in'].toString();
      final bIn = b['check_in'].toString();
      return aIn.compareTo(bIn);
    });

    final String checkInStr = rawCheckIn.toString();
    final DateTime checkInDate = DateTime.parse("${checkInStr.replaceAll(' ', 'T')}Z").toLocal();

    DateTime? checkOutDate;
    if (rawCheckOut != null && rawCheckOut is String && rawCheckOut.isNotEmpty) {
      checkOutDate = DateTime.parse("${rawCheckOut.replaceAll(' ', 'T')}Z").toLocal();
    }
    final bool isClosed = checkOutDate != null;

    double displayWorkedHours = workedHours;
    if (!isClosed) {
      displayWorkedHours = DateTime.now().difference(checkInDate).inSeconds / 3600.0;
      if (displayWorkedHours < 0) displayWorkedHours = 0.0;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          DateFormat('EEEE, dd MMM yyyy').format(checkInDate),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daily summary card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark 
                      ? [AppColors.indigo.withOpacity(0.8), AppColors.brightBlue.withOpacity(0.8)]
                      : [AppColors.indigo, AppColors.brightBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.indigo.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.total_worked.toUpperCase(),
                            style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _formatDuration(displayWorkedHours, l10n),
                            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isClosed ? Icons.verified_user_rounded : Icons.pending_actions_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white24, height: 1),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSummaryStat(l10n.overtime, "+${_formatDuration(overtimeHours, l10n)}", Colors.white),
                      _buildSummaryStat(l10n.validated_overtime, _formatDuration(validatedOT, l10n), Colors.white),
                      _buildSummaryStat(l10n.sessions_label, "${entries.length}", Colors.white),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              l10n.session_timeline,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),

            // Timeline builder
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                final entryIn = DateTime.parse("${entry['check_in'].toString().replaceAll(' ', 'T')}Z").toLocal();
                final entryOutVal = entry['check_out'];
                final entryOut = (entryOutVal != null && entryOutVal != false && entryOutVal.toString().isNotEmpty)
                    ? DateTime.parse("${entryOutVal.toString().replaceAll(' ', 'T')}Z").toLocal()
                    : null;
                final entryHours = (entry['worked_hours'] ?? 0.0).toDouble();

                final inLat = entry['in_latitude'];
                final inLong = entry['in_longitude'];
                final outLat = entry['out_latitude'];
                final outLong = entry['out_longitude'];
                final hasInLoc = inLat != null && inLat != 0.0;
                final hasOutLoc = outLat != null && outLat != 0.0;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline nodes and lines
                    Column(
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: entryOut != null ? AppColors.indigo : AppColors.orange,
                            shape: BoxShape.circle,
                            border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2),
                          ),
                        ),
                        if (index < entries.length - 1)
                          Container(
                            width: 2,
                            height: 140, // Height matching details card height
                            color: Colors.grey.withOpacity(0.3),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),

                    // Details Card
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardTheme.color ?? Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).shadowColor.withOpacity(0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(
                            color: Theme.of(context).dividerColor.withOpacity(0.05),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${l10n.session_label} #${index + 1}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: (entryOut != null ? AppColors.successGreen : AppColors.orange).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _formatDuration(entryHours, l10n),
                                    style: TextStyle(
                                      color: entryOut != null ? AppColors.successGreen : AppColors.orange,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTimelinePoint(
                                    context,
                                    l10n.check_in.toUpperCase(),
                                    DateFormat('hh:mm:ss a').format(entryIn),
                                    Icons.login_rounded,
                                    AppColors.blue,
                                    subtitle: hasInLoc ? "${inLat.toStringAsFixed(4)}, ${inLong.toStringAsFixed(4)}" : l10n.no_gps_location,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildTimelinePoint(
                                    context,
                                    l10n.check_out.toUpperCase(),
                                    entryOut != null ? DateFormat('hh:mm:ss a').format(entryOut) : "--:--",
                                    Icons.logout_rounded,
                                    entryOut != null ? AppColors.dangerRed : Colors.grey,
                                    subtitle: hasOutLoc ? "${outLat.toStringAsFixed(4)}, ${outLong.toStringAsFixed(4)}" : (entryOut != null ? l10n.no_gps_location : l10n.session_active),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(color: color.withOpacity(0.7), fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTimelinePoint(BuildContext context, String label, String time, IconData icon, Color color, {required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          time,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.location_on_outlined, size: 10, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3)),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                subtitle,
                style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
