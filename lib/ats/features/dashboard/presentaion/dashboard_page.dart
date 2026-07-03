import 'package:flutter/material.dart';
import 'package:flutter_app/core/widget/portal_header.dart';
import 'package:flutter_app/core/utils/shared_pref.dart';
import 'package:flutter_app/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/features/profile/cubit/profile_cubit.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:flutter_app/ats/core/constants/app_colors.dart';
import '../cubit/dashboard_cubit.dart';
import '../state/dashboard_state.dart';

class DashboardPage extends StatelessWidget {
  final ValueChanged<int>? onTabChanged;
  const DashboardPage({super.key, this.onTabChanged});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            final cubit = context.read<DashboardCubit>();
            final l10n = AppLocalizations.of(context);
            return Column(
              children: [
                PortalHeader(
                  activePortal: 'ats',
                  showSearchBar: false,
                  onPortalChanged: (val) async {
                    if (val == 'hrms') {
                      await SharedPref().saveString('selected_portal', 'hrms');
                      if (context.mounted) {
                        context.read<ProfileCubit>().fetchProfile();
                      }
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pushReplacementNamed(Routes.main);
                      }
                    }
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(left: 18, right: 18,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       
                        if (state.error != null)
                          Text(
                            state.error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        const SizedBox(height: 20),
                        // 📈 HORIZONTAL PERFORMANCE CARDS
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: [
                              _HorizontalCard(
                                title: l10n?.ats_job_positions ?? "Job Positions",
                                count: state.counts.isNotEmpty ? state.counts[0] : 0,
                                icon: Icons.work_outline_rounded,
                                color: const Color(0xFF3B82F6),
                                label: l10n?.ats_open_roles ?? "Open roles",
                              ),
                              const SizedBox(width: 12),
                              _HorizontalCard(
                                title: l10n?.ats_applications ?? "Applications",
                                count: state.counts.length > 1 ? state.counts[1] : 0,
                                icon: Icons.dashboard_outlined,
                                color: const Color(0xFF8B5CF6),
                                label: l10n?.ats_applications ?? "Applications",
                              ),
                              const SizedBox(width: 12),
                              _HorizontalCard(
                                title: l10n?.ats_candidates ?? "Candidates",
                                count: state.counts.length > 2 ? state.counts[2] : 0,
                                icon: Icons.groups_outlined,
                                color: const Color(0xFF10B981),
                                label: l10n?.ats_candidates ?? "Candidates",
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 📊 WEEKLY PERFORMANCE CHART CARD
                        Container(
                          width: double.infinity,
                          height: 160,
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
                              // Decorative Shape
                              Positioned(
                                right: -25,
                                top: -25,
                                child: Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFF3B82F6).withOpacity(0.04),
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
                                    color: const Color(0xFF8B5CF6).withOpacity(0.03),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          l10n?.ats_this_week ?? "This week",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6) ?? const Color(0xFF94A3B8),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          l10n != null 
                                              ? l10n.ats_new_applications_came_in(state.newApplicationsThisWeek)
                                              : "${state.newApplicationsThisWeek} new applications came in",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).textTheme.bodyLarge?.color,
                                            height: 1.25,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: List.generate(7, (index) {
                                        final val = state.weeklyCounts[index];
                                        final maxVal = state.weeklyCounts.reduce((a, b) => a > b ? a : b);
                                        final double pct = maxVal > 0 ? (val / maxVal) : 0.0;
                                        final double height = 8 + (pct * 62);
                                        final bool isHighlighted = index == 6;

                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              width: 10,
                                              height: height,
                                              decoration: BoxDecoration(
                                                color: isHighlighted
                                                    ? const Color(0xFF3B82F6)
                                                    : const Color(0xFF475569).withOpacity(0.25),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              _getDayLabel(index),
                                              style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                                color: isHighlighted
                                                    ? const Color(0xFF3B82F6)
                                                    : Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5) ?? const Color(0xFF64748B),
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
                        ),
                        const SizedBox(height: 20),

                      

                        // 📄 RECENT APPLICATIONS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Text(
                              l10n?.ats_recent_applications ?? "Recent Applications",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context).textTheme.bodyLarge?.color ?? const Color(0xFF0F172A),
                              ),
                            ),
                            if (state.recentApplications.isNotEmpty)
                              TextButton(
                                onPressed: () {
                                  if (onTabChanged != null) onTabChanged!(2);
                                },
                                child: Text(
                                  l10n?.ats_view_all ?? "View All",
                                  style: const TextStyle(
                                    color: const Color(0xFF3B82F6),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        // const SizedBox(height: 12),

                        if (state.isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: CircularProgressIndicator(
                                color: const Color(0xFF3B82F6),
                              ),
                            ),
                          )
                        else if (state.recentApplications.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: Column(
                              children:  [
                                Icon(
                                  Icons.description_outlined,
                                  size: 40,
                                  color: Color(0xFF94A3B8),
                                ),
                                SizedBox(height: 8),
                                  Text(
                                    l10n?.ats_no_recent_applications ?? "No recent applications",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).textTheme.bodyMedium?.color ?? const Color(0xFF64748B),
                                    ),
                                  ),
                              ],
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.recentApplications.length,
                            itemBuilder: (context, index) {
                              final app = state.recentApplications[index];
                              final partnerName = app['partner_name']
                                  ?.toString();
                              final name =
                                  (partnerName != null &&
                                      partnerName.isNotEmpty &&
                                      partnerName.toLowerCase() != 'false')
                                  ? partnerName
                                  : app['name']?.toString() ??
                                        'Unnamed Candidate';

                              // Extract job title
                              final jobVal = app['job_id'];
                              final jobTitle =
                                  jobVal is List && jobVal.length > 1
                                  ? jobVal[1].toString()
                                  : 'General Position';

                              // Extract stage name
                              final stageVal = app['stage_id'] ?? app['recruitment_stage_id'];
                              final stageName =
                                  stageVal is List && stageVal.length > 1
                                  ? stageVal[1].toString()
                                  : 'Applied';

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF0F172A,
                                      ).withOpacity(0.02),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: const Color(0xFFEBF3FF),
                                      radius: 20,
                                      child: Text(
                                        name.isNotEmpty
                                            ? name[0].toUpperCase()
                                            : 'A',
                                        style: const TextStyle(
                                          color: const Color(0xFF3B82F6),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name,
                                            style:  TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: Theme.of(context).textTheme.bodyLarge?.color ?? const Color(0xFF0F172A),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            jobTitle,
                                            style:  TextStyle(
                                              fontSize: 12,
                                              color: Theme.of(context).textTheme.bodyMedium?.color ?? const Color(0xFF64748B),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEFF6FF),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        stageName,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF1D4ED8),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style:  TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).textTheme.bodyLarge?.color ?? const Color(0xFF334155),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getDayLabel(int index) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final todayWeekday = DateTime.now().weekday;
    final weekdayIndex = (todayWeekday - 1 - (6 - index)) % 7;
    final idx = weekdayIndex < 0 ? weekdayIndex + 7 : weekdayIndex;
    return days[idx];
  }
}

class _ChartBar extends StatelessWidget {
  // final double height;
  final double value;

  final String label;
  const _ChartBar({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,

      children: [
        Container(
          width: 30,
          height: 140,
          padding: const EdgeInsets.all(4),

          decoration: BoxDecoration(
            // color: Colors.deepPurple.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          alignment: Alignment.bottomCenter,
          child: Container(
            height: value <= 0 ? 5 : value * 3,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade600),
            ),
          ),
        ),
        const SizedBox(height: 10),

        /// PERCENTAGE
        Text(
          "${value.toInt()}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 4),

        /// LABEL
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}

class _HorizontalCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;
  final String label;

  const _HorizontalCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 125,
      height: 125,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$count",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6) ?? const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
