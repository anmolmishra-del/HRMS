import 'package:flutter/material.dart';
import 'package:flutter_app/core/widget/portal_header.dart';
import 'package:flutter_app/core/utils/shared_pref.dart';
import 'package:flutter_app/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/features/profile/cubit/profile_cubit.dart';
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
                        // GRID
                        GridView.builder(
                          shrinkWrap: true,
                        
                          physics: const NeverScrollableScrollPhysics(),
                        
                          itemCount: state.titles.length,
                        
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                        
                                crossAxisSpacing: 16,
                        
                                mainAxisSpacing: 16,
                        
                                childAspectRatio: 1.4,
                              ),
                        
                          itemBuilder: (context, index) {
                            return _Card(
                              title: state.titles[index],
                        
                              count:
                                  state.counts.isNotEmpty &&
                                      index < state.counts.length
                                  ? state.counts[index]
                                  : 0,
                            );
                          },
                        ),

                      

                        // 📄 RECENT APPLICATIONS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Text(
                              "Recent Applications",
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
                                child: const Text(
                                  "View All",
                                  style: TextStyle(
                                    color: const Color(0xFF3B82F6),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),

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
                                  "No recent applications",
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
                              final stageVal = app['stage_id'];
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

class _Card extends StatelessWidget {
  final String title;
  final int count;

  const _Card({required this.title, required this.count});

  // IconData getIcon() {
  //   switch (title) {
  //     case "Open Positions":
  //       return Icons.work_outline;
  //     case "New Applications":
  //       return Icons.description_outlined;
  //     case "Interviews Today":
  //       return Icons.calendar_today;
  //     case "Offers Pending":
  //       return Icons.timelapse;
  //     case "Hired This Month":
  //       return Icons.person;
  //     default:
  //       return Icons.cancel;
  //   }
  // }
  IconData getIcon() {
    switch (title) {
      case "Open Positions":
        return Icons.work_outline_rounded;

      case "New Applications":
        return Icons.description_outlined;

      case "Candidates":
        return Icons.groups_outlined;

      default:
        return Icons.dashboard_outlined;
    }
  }

  Color getColor() {
    switch (title) {
      case "Open Positions":
        return Colors.blue;

      case "New Applications":
        return Colors.orange;

      case "Candidates":
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 140, // 👈 control card height
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),

      //     decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //     colors: [
      //       getColor().withOpacity(.15),
      //       Colors.white,
      //     ],
      //     begin: Alignment.topLeft,
      //     end: Alignment.bottomRight,
      //   ),
      //   borderRadius: BorderRadius.circular(22),
      //   border: Border.all(
      //     color: Colors.grey.shade400,
      //   ),
      //   boxShadow: [
      //     BoxShadow(
      //       color: getColor().withOpacity(.08),
      //       blurRadius: 15,
      //       offset: const Offset(0, 8),
      //     ),
      //   ],
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          /// TITLE
          Text(
            title,

            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),

            maxLines: 2,

            overflow: TextOverflow.ellipsis,
          ),

          const Spacer(),

          /// ICON + NUMBER
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: getColor().withOpacity(.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: getColor().withOpacity(.2)),
                ),
                child: Icon(
                  getIcon(),
                  shadows: [Shadow(color: Colors.red)],
                  color: getColor(),
                  size: 28,
                ),
              ),

              const SizedBox(width: 10),

              Text(
                "$count",

                style: const TextStyle(
                  fontSize: 28,

                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
