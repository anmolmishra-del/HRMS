import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/ats/core/constants/app_colors.dart';
import '../cubit/applications_cubit.dart';
import '../state/applications_state.dart';
import '../state/hr_applicant_model.dart';
import 'application_detail_page.dart';

class ApplicationsListPage extends StatelessWidget {
  final int? filterJobId;
  const ApplicationsListPage({super.key, this.filterJobId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ApplicationsCubit(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlocBuilder<ApplicationsCubit, ApplicationsState>(
          builder: (context, state) {
            final cubit = context.read<ApplicationsCubit>();
            final searchLower = state.searchQuery.toLowerCase();

            final filtered = state.applications.where((app) {
              // 0. Job ID Filter
              if (filterJobId != null && app.jobId != filterJobId && app.hrJobRecruitmentId != filterJobId) {
                return false;
              }

              // 1. Stage/Status Filter
              bool matchesTab = true;
              if (state.selectedTab != 'All') {
                matchesTab = app.applicationStatus.toLowerCase() == state.selectedTab.toLowerCase() ||
                             app.stageName.toLowerCase() == state.selectedTab.toLowerCase();
              }

              // 2. Search Query Filter
              final matchesSearch = app.name.toLowerCase().contains(searchLower) ||
                  app.candidateName.toLowerCase().contains(searchLower) ||
                  app.emailFrom.toLowerCase().contains(searchLower) ||
                  app.jobName.toLowerCase().contains(searchLower) ||
                  app.degreeName.toLowerCase().contains(searchLower) ||
                  app.userName.toLowerCase().contains(searchLower);

              return matchesTab && matchesSearch;
            }).toList();

            return Column(
              children: [
                // Premium Header Card
                _buildHeader(context, cubit, state),
                
                // Horizontal Tabs for Status/Stages
                _buildStageTabs(cubit, state),

                const SizedBox(height: 8),

                // Applications List
                Expanded(
                  child: state.isLoading
                      ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                      : filtered.isEmpty
                          ? _buildEmptyState(state.selectedTab)
                          : ListView.builder(
                              padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 100),
                              physics: const BouncingScrollPhysics(),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                return _buildApplicationCard(context, filtered[index], cubit);
                              },
                            ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ApplicationsCubit cubit, ApplicationsState state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 16, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white.withOpacity(0.06),
            ),
          ),
          Positioned(
            left: -10,
            bottom: -30,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white.withOpacity(0.04),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Odoo Recruitment",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.85),
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                       Text(
                        "Applications",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: cubit.refresh,
                    icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                onChanged: cubit.search,
                style:  TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF0F172A), fontSize: 15),
                decoration: InputDecoration(
                  hintText: "Search subject, job, email, or candidate...",
                  hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                  prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 22),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStageTabs(ApplicationsCubit cubit, ApplicationsState state) {
    final tabs = ['All', 'Ongoing', 'Hired', 'Refused', 'Archived'];
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final tab = tabs[index];
          final isActive = state.selectedTab == tab;
          return GestureDetector(
            onTap: () => cubit.changeTab(tab),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive ? Colors.transparent : const Color(0xFFE2E8F0),
                ),
                boxShadow: [
                  if (isActive)
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Center(
                child: Text(
                  tab,
                  style: TextStyle(
                    color: isActive ? Colors.white : const Color(0xFF64748B),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildApplicationCard(BuildContext context, HrApplicant app, ApplicationsCubit cubit) {
    Color statusColor = Colors.orange;
    if (app.applicationStatus == 'Hired') statusColor = Colors.green;
    if (app.applicationStatus == 'Refused') statusColor = Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: Colors.primaries[app.userId.hashCode % Colors.primaries.length], width: 4)),
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x050F172A),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              cubit.selectApplication(app);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: cubit,
                    child: const ApplicationDetailPage(),
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: const Icon(Icons.description_outlined, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              app.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              "Candidate: ${app.candidateName}",
                              style: TextStyle(fontSize: 13, color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          app.applicationStatus,
                          style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Divider(color: Theme.of(context).dividerColor, height: 1),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.work_outline, size: 16, color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                      const SizedBox(width: 6),
                      Text(
                        app.jobName.isNotEmpty ? app.jobName : "No job linked",
                        style: TextStyle(fontSize: 12, color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      Icon(Icons.person_outline, size: 16, color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                      const SizedBox(width: 4),
                      Text(
                        app.userName.isNotEmpty ? app.userName : "Unassigned",
                        style: TextStyle(fontSize: 12, color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.bookmark_border, size: 16, color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                      const SizedBox(width: 6),
                      Text(
                        "Stage: ${app.stageName}",
                        style: TextStyle(fontSize: 12, color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                      ),
                      const Spacer(),
                      if (app.availability != null)
                        Text(
                          "Avail: ${DateFormat('dd MMM').format(app.availability!)}",
                          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String tab) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            "No applications in '$tab' stage",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
