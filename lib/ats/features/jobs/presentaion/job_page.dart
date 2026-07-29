import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:flutter_app/ats/utils/ats_localization.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_app/ats/core/constants/api_config.dart';
import 'package:flutter_app/ats/features/jobs/model/model_class.dart';
import 'package:flutter_app/ats/features/jobs/presentaion/create_job.dart';
import 'package:flutter_app/ats/features/jobs/presentaion/job_detils_page.dart';
import 'package:flutter_app/ats/features/jobs/repository/hr_job_service file.dart';
import '../cubit/job_cubit.dart';
import '../state/job_state.dart';
import 'package:flutter_app/core/widget/loading_overlay.dart';

class JobPage extends StatefulWidget {
  final bool isRecruiter;
  final bool showBackButton;

  const JobPage({
    super.key,
    required this.isRecruiter,
    this.showBackButton = true,
  });

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {

  @override
  void initState() {
    super.initState();
    // Initial load — Cubit auto-starts 30s polling after this completes
    context.read<JobCubit>().fetchJobs();
  }

  Color _getCategoryBgColor(BuildContext context, String category) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lower = category.toLowerCase().trim();
    if (lower == 'development') return isDark ? const Color(0xFF1D4ED8).withOpacity(0.15) : const Color(0xFFEFF6FF); // Soft blue
    if (lower == 'testing') return isDark ? const Color(0xFF7E22CE).withOpacity(0.15) : const Color(0xFFF3E8FF); // Soft purple
    if (lower == 'integration') return isDark ? const Color(0xFF047857).withOpacity(0.15) : const Color(0xFFECFDF5); // Soft green
    if (lower == 'screening' || lower == 'hr') return isDark ? const Color(0xFFC2410C).withOpacity(0.15) : const Color(0xFFFFF7ED); // Soft orange
    return isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFF1F5F9); // Soft grey
  }

  Color _getCategoryTextColor(BuildContext context, String category) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lower = category.toLowerCase().trim();
    if (lower == 'development') return isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8);
    if (lower == 'testing') return isDark ? const Color(0xFFD8B4FE) : const Color(0xFF7E22CE);
    if (lower == 'integration') return isDark ? const Color(0xFF6EE7B7) : const Color(0xFF047857);
    if (lower == 'screening' || lower == 'hr') return isDark ? const Color(0xFFFDBA74) : const Color(0xFFC2410C);
    return isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
  }

  String _cleanCategoryName(String category) {
    final trimmed = category.trim();
    if (trimmed.isEmpty || trimmed.toLowerCase() == 'false' || trimmed.toLowerCase() == 'null' || trimmed.toLowerCase() == 'n/a') {
      return 'Development'; // Default clean category
    }
    return trimmed;
  }

  /// Converts raw Odoo priority values (false, empty, '0', '1', '2') to human-readable labels.
  String _cleanPriority(String priority) {
    final lower = priority.toLowerCase().trim();
    if (lower.isEmpty || lower == 'false' || lower == 'null') return 'N/A';
    if (lower == '0') return 'Normal';
    if (lower == '1') return 'Good';
    if (lower == '2') return 'Very Good';
    if (lower == '3') return 'Excellent';
    return priority.trim();
  }

  Color _getPriorityBgColor(BuildContext context, String priority) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lower = priority.toLowerCase().trim();
    if (lower.contains('very high') || lower == '0' || lower == 'high') {
      return isDark ? const Color(0xFFDC2626).withOpacity(0.15) : const Color(0xFFFEF2F2); // Red 50
    }
    if (lower.contains('medium') || lower == '1') {
      return isDark ? const Color(0xFFD97706).withOpacity(0.15) : const Color(0xFFFFFBEB); // Amber 50
    }
    return isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFF8FAFC); // Slate 50
  }

  Color _getPriorityTextColor(BuildContext context, String priority) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lower = priority.toLowerCase().trim();
    if (lower.contains('very high') || lower == '0' || lower == 'high') {
      return isDark ? const Color(0xFFFCA5A5) : const Color(0xFFDC2626); // Red 600
    }
    if (lower.contains('medium') || lower == '1') {
      return isDark ? const Color(0xFFFCD34D) : const Color(0xFFD97706); // Amber 600
    }
    return isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B); // Slate 600
  }

  Widget _buildSmallBadge({
    required IconData icon,
    required String label,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Modern slate background
      body: BlocConsumer<JobCubit, JobState>(
            listener: (context, state) {
              if (state.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to sync jobs from Odoo: ${state.error}')),
                );
              }
            },
            builder: (context, state) {
              final cubit = context.read<JobCubit>();
              final l10n = AppLocalizations.of(context);
              
              // FILTER LOGIC
              List<JobData> filteredJobs = state.jobs.where((job) {
                final matchTab = state.selectedTab == "All"
                    ? true
                    : state.selectedTab == "Published"
                        ? job.isPublished == true
                        : state.selectedTab == "Unpublished"
                            ? job.isPublished == false
                            : true;
                final matchSearch = job.title.toLowerCase().contains(
                  state.searchQuery.toLowerCase(),
                );
                return matchTab && matchSearch;
              }).toList();

              return LoadingOverlay(
                isLoading: state.isLoading,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  _buildHeader(context, cubit, state),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                  // 📊 TAB CONTROLS (PILL DESIGN)
                  Container(
                    height: 48,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.08) : const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(14),border: Border.all(color: Theme.of(context).dividerColor, width: 1),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: _tab("All", l10n?.tab_all ?? "All", state.selectedTab, cubit)),
                        Expanded(child: _tab("Published", l10n?.tab_published ?? "Published", state.selectedTab, cubit)),
                        Expanded(child: _tab("Unpublished", l10n?.tab_unpublished ?? "Unpublished", state.selectedTab, cubit)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // 💼 JOB LIST
                  Expanded(
                    child: filteredJobs.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.work_off_outlined, size: 64, color: Colors.grey),
                                const SizedBox(height: 12),
                                 Text(
                                  l10n?.ats_no_jobs_found ?? "No job requisitions found",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                 Text(
                                  l10n?.ats_tweak_filters ?? "Try tweaking your search or filters",
                                  style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () => context.read<JobCubit>().fetchJobs(),
                            color: const  Color(0xFF3B82F6),
                            child: ListView.builder(
                              padding: const EdgeInsets.only(top: 8, bottom: 100),
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: filteredJobs.length,
                              itemBuilder: (context, index) {
                                final job = filteredJobs[index];
                                final cleanCat = _cleanCategoryName(job.category);
                                final catBg = _getCategoryBgColor(context, cleanCat);
                                final catText = _getCategoryTextColor(context, cleanCat);

                                // Dynamic Accent Color based on Status
                                Color statusAccent = const Color(0xFF10B981); // Emerald Green for Open
                                if (job.status.toLowerCase() == 'draft') {
                                  statusAccent = const Color(0xFFF59E0B); // Amber
                                } else if (job.status.toLowerCase() == 'closed') {
                                  statusAccent = const Color(0xFFEF4444); // Red
                                }

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 14),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Theme.of(context).dividerColor, width: 1),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF0F172A).withOpacity(0.04),
                                        blurRadius: 14,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: IntrinsicHeight(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          // 🟢 Left Accent Status Line
                                          Container(
                                            width: 5,
                                            decoration: BoxDecoration(
                                              border: Border(
                                                left: BorderSide(
                                                  color: Colors.primaries[job.hashCode % Colors.primaries.length],
                                                  width: 4,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) => CreateJobdetailsPage(
                                                          job: job,
                                                          isRecruiter: widget.isRecruiter,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(16),
                                                    child: Row(
                                                      children: [
                                                        // Icon avatar
                                                        Container(
                                                          padding: const EdgeInsets.all(12),
                                                          decoration: BoxDecoration(
                                                            color: const  Color(0xFFEBF3FF),
                                                            borderRadius: BorderRadius.circular(16),
                                                          ),
                                                          child: const Icon(
                                                            Icons.business_center_rounded,
                                                            color: const Color(0xFF3B82F6),
                                                            size: 24,
                                                          ),
                                                        ),
                                                        const SizedBox(width: 16),
                                                        // Details
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              if (job.recruitmentSequence.isNotEmpty) ...[
                                                                Text(
                                                                  job.recruitmentSequence,
                                                                  style: const TextStyle(
                                                                    fontSize: 11,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Color(0xFF3B82F6),
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 2),
                                                              ],
                                                              Text(
                                                                job.title,
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.w800,
                                                                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF0F172A),
                                                                ),
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                              const SizedBox(height: 4),
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons.badge_outlined,
                                                                    size: 13,
                                                                    color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                                                  ),
                                                                  const SizedBox(width: 4),
                                                                  Expanded(
                                                                    child: Text(
                                                                      "Job Position: ${job.department}",
                                                                      style: TextStyle(
                                                                        fontSize: 13,
                                                                        color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                                                        fontWeight: FontWeight.w500,
                                                                      ),
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(height: 8),
                                                              Wrap(
                                                                spacing: 6,
                                                                runSpacing: 4,
                                                                children: [
                                                                  // Priority Badge
                                                                  _buildSmallBadge(
                                                                    icon: Icons.star_rounded,
                                                                    label: _cleanPriority(job.priority),
                                                                    bgColor: _getPriorityBgColor(context, job.priority),
                                                                    textColor: _getPriorityTextColor(context, job.priority),
                                                                  ),
                                                                  // Budget Badge
                                                                  _buildSmallBadge(
                                                                    icon: Icons.monetization_on_outlined,
                                                                    label: job.salary.isEmpty ? 'N/A' : job.salary,
                                                                    bgColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1D4ED8).withOpacity(0.15) : const Color(0xFFEFF6FF),
                                                                    textColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                                                                  ),
                                                                  // Published Badge
                                                                  _buildSmallBadge(
                                                                    icon: job.isPublished ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
                                                                    label: job.isPublished ? 'Published' : 'Draft',
                                                                    bgColor: job.isPublished ? const Color(0xFFECFDF5) : (Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.08) : const Color(0xFFF1F5F9)),
                                                                    textColor: job.isPublished ? const Color(0xFF047857) : (Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8),
                                                        // Category Capsule Badge
                                                        Container(
                                                          padding: const EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                            vertical: 6,
                                                          ),
                                                          decoration: BoxDecoration(
                                                            color: catBg,
                                                            borderRadius: BorderRadius.circular(30),
                                                          ),
                                                          child: Text(
                                                            cleanCat,
                                                            style: TextStyle(
                                                              color: catText,
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.w700,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      TextButton.icon(
                                                        style: TextButton.styleFrom(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                        ),
                                                        onPressed: () {
                                                          final jobUrl = "${ApiConfig.baseUrl}/jobs/detail/${job.id}";
                                                          Share.share(jobUrl, subject: job.title);
                                                        },
                                                        icon: const Icon(Icons.share_rounded, size: 14, color: Color(0xFF0284C7)),
                                                        label: const Text(
                                                          "Job Page",
                                                          style: TextStyle(
                                                            color: Color(0xFF0284C7),
                                                            fontWeight: FontWeight.w800,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                                
                              },
                            ),
                          ),
                       ) ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
    );
  }

  Widget _buildHeader(BuildContext context, JobCubit cubit, JobState state) {
    final l10n = AppLocalizations.of(context);
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
                  Expanded(
                    child: Row(
                      children: [
                        if (widget.showBackButton)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                l10n?.ats_job_positions ?? "Job Positions",
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => cubit.fetchJobs(),
                    icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                    tooltip: 'Refresh jobs',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Search bar inside the header!
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: TextField(
                  onChanged: (v) => cubit.search(v),
                  style:  TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF0F172A), fontSize: 15),
                  decoration: InputDecoration(
                    hintText: l10n?.ats_search_hint ?? "Search ...",
                    hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                    prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 20),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tab(String key, String label, String selected, JobCubit cubit) {
    final isActive = key == selected;

    return GestureDetector(
      onTap: () => cubit.changeTab(key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? (Theme.of(context).brightness == Brightness.dark ? Theme.of(context).cardColor : Colors.white) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withOpacity(0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: isActive 
                ? const Color(0xFF3B82F6) 
                : (Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
          )
        ),
      ),
    );
  }



//   void _showCreateJobModal(BuildContext context, {JobData? job}) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => DraggableScrollableSheet(
//         expand: false,
//         initialChildSize: 0.9,
//         maxChildSize: 0.95,
//         minChildSize: 0.5,
//         builder: (context, scrollController) => _CreateJobForm(
//           scrollController: scrollController,
//           cubit: context.read<JobCubit>(),
//           job: job,
//           onSuccess: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//     );
//   }
// }

// class _CreateJobForm extends StatefulWidget {
//   final ScrollController scrollController;
//   final JobCubit cubit;
//   final VoidCallback onSuccess;
//   final JobData? job;

//   const _CreateJobForm({
//     required this.scrollController,
//     required this.cubit,
//     required this.onSuccess,
//     this.job,
//   });

//   @override
//   State<_CreateJobForm> createState() => _CreateJobFormState();
// }

// class _CreateJobFormState extends State<_CreateJobForm> {
//   final _titleCtrl = TextEditingController();

//   int? _selectedDeptId;
//   int? _selectedCategoryId;

//   List<Map<String, dynamic>> _departments = [];
//   List<Map<String, dynamic>> _categories = [];
//   final _service = HrJobService();

//   bool _loading = false;
//   bool _loadingDropdowns = false;

//   @override
//   void initState() {
//     super.initState();
//     _titleCtrl.text = widget.job?.title ?? '';
//     _fetchDropdowns();
//   }

//   Future<void> _fetchDropdowns() async {
//     setState(() => _loadingDropdowns = true);
//     print('🔄 _fetchDropdowns: Starting fetch...');

//     try {
//       print('📦 Fetching departments...');
//       final departments = await _service.fetchDepartments();
//       print('✅ Departments fetched: ${departments.length} items');

//       print('📦 Fetching categories...');
//       final categories = await _service.fetchCategories();
//       print('✅ Categories fetched: ${categories.length} items');

//       if (mounted) {
//         setState(() {
//           _departments = departments;
//           _categories = categories;
//         });
//         print('✅ UI state updated with dropdowns');
//         // If editing an existing job, attempt to preselect department/category by name
//         if (widget.job != null) {
//           final job = widget.job!;
//           try {
//             final dept = _departments.firstWhere((d) => (d['name'] ?? '').toString() == job.department);
//             _selectedDeptId = dept['id'] as int?;
//           } catch (_) {}

//           try {
//             final cat = _categories.firstWhere((c) => (c['name'] ?? '').toString() == job.category);
//             _selectedCategoryId = cat['id'] as int?;
//           } catch (_) {}
//         }
//       }
//     } catch (e) {
//       print('❌ _fetchDropdowns error: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to fetch dropdowns: $e')),
//         );
//       }
//     } finally {
//       if (mounted) setState(() => _loadingDropdowns = false);
//       print('✅ _fetchDropdowns: Complete');
//     }
//   }

//   Future<void> _createHrJob() async {
//     final title = _titleCtrl.text.trim();
//     print('🚀 _createHrJob: Starting with title="$title"');

//     if (title.isEmpty) {
//       print('⚠️ _createHrJob: Title is empty!');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter job position')),
//       );
//       return;
//     }

//     setState(() => _loading = true);

//     try {
//       print('📤 Calling _service.createHrJob()...');
//       final newJob = await _service.createHrJob(
//         title: title,
//         departmentId: _selectedDeptId,
//         categoryId: _selectedCategoryId,
//       );
//       print('📥 Service response: $newJob');

//       if (newJob == null) {
//         print('❌ newJob is NULL - creation failed');
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Failed to create job. Check the form and try again.'),
//               duration: Duration(seconds: 3),
//             ),
//           );
//         }
//         return;
//       }

//       print('✅ newJob created: title=${newJob.title}');

//       if (mounted) {
//         print('📝 Adding job to cubit...');
//         widget.cubit.addJob(newJob);
//         print('✅ Job added to cubit');

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Job created successfully')),
//         );
//         print('✅ Calling onSuccess callback...');
//         widget.onSuccess();
//       }
//     } catch (e) {
//       print('❌ _createHrJob exception: $e');

//       if (mounted) {
//         String errorMsg = 'Failed to create job';
//         final err = e.toString();

//         if (err.contains('must be unique')) {
//           errorMsg = 'Job position name must be unique in this department.\nTry a different name or department.';
//           print('⚠️ Unique constraint violation');
//         } else if (err.contains('Permission denied') || err.contains('AccessError')) {
//           errorMsg = "Permission denied: you need 'Recruitment/Officer' access.";
//           print('🔐 Permission error detected');
//         } else if (err.contains('Exception:')) {
//           final match = RegExp(r"Exception: (.+?)(?:\)|$)").firstMatch(err);
//           if (match != null) {
//             errorMsg = match.group(1) ?? 'Failed to create job';
//           }
//         }

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(errorMsg),
//             duration: const Duration(seconds: 4),
//           ),
//         );
//       }
//     } finally {
//       if (mounted) setState(() => _loading = false);
//       print('✅ _createHrJob: Complete');
//     }
//   }

//   @override
//   void dispose() {
//     _titleCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _loadingDropdowns
//         ? const Center(child: CircularProgressIndicator())
//         : ListView(
//             controller: widget.scrollController,
//             padding: const EdgeInsets.all(16),
//             children: [
//               // HEADER
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Create Job Position',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () => Navigator.pop(context),
//                     icon: const Icon(Icons.close),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),

//               // JOB TITLE
//               TextField(
//                 controller: _titleCtrl,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black87,
//                 ),
//                 decoration: InputDecoration(
//                   labelText: 'Job Position *',
//                   hintText: 'Enter job title',
//                   prefixIcon: const Icon(Icons.work_outline, color: Colors.grey),
//                   filled: true,
//                   fillColor: Colors.grey.shade50,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(color: Colors.grey.shade300),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(color: Colors.grey.shade300),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // DEPARTMENT DROPDOWN
//               DropdownButtonFormField<int>(
//                 value: _selectedDeptId,
//                 hint: const Text('Select Department'),
//                 decoration: InputDecoration(
//                   labelText: 'Department',
//                   prefixIcon: const Icon(Icons.apartment, color: Colors.grey),
//                   filled: true,
//                   fillColor: Colors.grey.shade50,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(color: Colors.grey.shade300),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(color: Colors.grey.shade300),
//                   ),
//                 ),
//                 items: _departments.map((dept) {
//                   return DropdownMenuItem<int>(
//                     value: dept['id'] as int,
//                     child: Text(dept['name']?.toString() ?? 'Unknown'),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() => _selectedDeptId = value);
//                 },
//               ),
//               const SizedBox(height: 16),

//               // CATEGORY DROPDOWN
//               DropdownButtonFormField<int>(
//                 value: _selectedCategoryId,
//                 hint: const Text('Select Category'),
//                 decoration: InputDecoration(
//                   labelText: 'Job Category',
//                   prefixIcon: const Icon(Icons.category, color: Colors.grey),
//                   filled: true,
//                   fillColor: Colors.grey.shade50,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(color: Colors.grey.shade300),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(color: Colors.grey.shade300),
//                   ),
//                 ),
//                 items: _categories.map((cat) {
//                   return DropdownMenuItem<int>(
//                     value: cat['id'] as int,
//                     child: Text(cat['name']?.toString() ?? 'Unknown'),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() => _selectedCategoryId = value);
//                 },
//               ),
//               const SizedBox(height: 32),

//               // CREATE BUTTON
//               ElevatedButton(
//                 onPressed: _loading ? null : _createHrJob,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepPurple,
//                   disabledBackgroundColor: Colors.grey,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: _loading
//                     ? const SizedBox(
//                         height: 20,
//                         width: 20,
//                         child: CircularProgressIndicator(
//                           valueColor: AlwaysStoppedAnimation(Colors.white),
//                           strokeWidth: 2,
//                         ),
//                       )
//                     : const Text(
//                         'Create Job Position',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Theme.of(context).cardColor,
//                         ),
//                       ),
//               ),
//               const SizedBox(height: 24),
//             ],
//           );
//   }
// }
}