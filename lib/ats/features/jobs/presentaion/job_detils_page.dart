import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/core/constants/api_config.dart';
import 'package:flutter_app/ats/core/services/odoo_service.dart';
import 'package:flutter_app/ats/features/applications/presentation/applications_list_page.dart';
import 'package:flutter_app/ats/features/jobs/model/model_class.dart';
import 'package:flutter_app/ats/features/my_applications/cubit/my_application_cubit.dart';
import 'package:flutter_app/ats/features/my_applications/presentaion/my_appication_page.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'create_job.dart';

class CreateJobdetailsPage extends StatefulWidget {
  final JobData job;
  final bool isRecruiter;

  const CreateJobdetailsPage({
    super.key,
    required this.job,
    required this.isRecruiter,
  });

  @override
  State<CreateJobdetailsPage> createState() => _CreateJobdetailsPageState();
}

class _CreateJobdetailsPageState extends State<CreateJobdetailsPage> {
  int _applicantsCount = 0;
  int _documentsCount = 0;
  bool _loadingCounts = true;
  List<Map<String, dynamic>> _documents = [];

  @override
  void initState() {
    super.initState();
    _fetchCounts();
  }

  Future<void> _fetchCounts() async {
    try {
      final odoo = OdooService(ApiConfig.baseUrl);

      final List<dynamic> applicantDomain = [];
      if (widget.job.jobId != null) {
        applicantDomain.add(['job_id', '=', widget.job.jobId]);
      } else if (widget.job.id != null) {
        applicantDomain.add(['hr_job_recruitment', '=', widget.job.id]);
      } else {
        applicantDomain.add(['id', '=', 0]);
      }

      final List<dynamic> docDomain = [
        ['res_model', 'in', ['hr.job', 'hr.job.recruitment']],
        ['res_id', 'in', [widget.job.jobId ?? 0, widget.job.id ?? 0]]
      ];

      final results = await Future.wait([
        odoo.executeModelMethod('hr.applicant', 'search_count', [applicantDomain]),
        odoo.executeModelMethod('ir.attachment', 'search_read', [docDomain], kwargs: {
          'fields': ['id', 'name', 'mimetype'],
        }),
      ]);

      int appCount = 0;
      if (results[0] is int) {
        appCount = results[0] as int;
      }

      List<Map<String, dynamic>> docsList = [];
      if (results[1] is List) {
        docsList = List<Map<String, dynamic>>.from(
          (results[1] as List).map((e) => Map<String, dynamic>.from(e))
        );
      }

      if (mounted) {
        setState(() {
          _applicantsCount = appCount;
          _documents = docsList;
          _documentsCount = docsList.length;
          _loadingCounts = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching counts from Odoo: $e");
      if (mounted) {
        setState(() {
          _loadingCounts = false;
        });
      }
    }
  }

  void _showDocumentsSheet() {
    if (_documents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No documents found for this job position.')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) {
        final sessionId = OdooService(ApiConfig.baseUrl).sessionId?.id ?? '';
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(
                      "Job Documents",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(color: Color(0xFFE2E8F0)),
                const SizedBox(height: 8),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _documents.length,
                    itemBuilder: (context, index) {
                      final doc = _documents[index];
                      final docId = doc['id'];
                      final docName = doc['name'] ?? 'Document';
                      final mimetype = doc['mimetype'] ?? '';
                      final isPdf = mimetype.toString().contains('pdf') || docName.toString().toLowerCase().endsWith('.pdf');

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Theme.of(context).dividerColor),
                        ),
                        child: Material(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isPdf ? const Color(0xFFFEF2F2) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              isPdf ? Icons.picture_as_pdf_rounded : Icons.insert_drive_file_rounded,
                              color: isPdf ? Colors.red : Colors.grey,
                            ),
                          ),
                          title: Text(
                            docName,
                            style:  TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF0F172A),
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                          onTap: () {
                            Navigator.pop(context);
                            final docUrl = "${ApiConfig.baseUrl}/web/content/$docId?download=true";

                            if (isPdf) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Scaffold(
                                    appBar: AppBar(
                                      title: Text(docName),
                                    ),
                                    body: SfPdfViewer.network(
                                      docUrl,
                                      headers: sessionId.isNotEmpty
                                          ? {'Cookie': 'session_id=$sessionId'}
                                          : null,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Downloading: $docName')),
                              );
                            }
                          },
                        ),
                      ),
                    );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getPriorityColor(String priority) {
    final lower = priority.toLowerCase().trim();
    if (lower.contains('very high') || lower == '0' || lower == 'high') return const Color(0xFFEF4444);
    if (lower.contains('medium') || lower == '1') return const Color(0xFFF59E0B);
    return const Color(0xFF10B981);
  }

  Widget _buildSmartButton({
    required IconData icon,
    required String label,
    required int count,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Theme.of(context).dividerColor, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const  Color(0xFFEBF3FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: const  Color(0xFF3B82F6), size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      _loadingCounts
                          ? const SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: const Color(0xFF3B82F6),
                              ),
                            )
                          : Text(
                              "$count",
                              style:  TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final priorityColor = _getPriorityColor(widget.job.priority);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pBadgeBgColor = priorityColor.withOpacity(isDark ? 0.15 : 0.08);
    Color pBadgeTextColor = priorityColor;
    if (isDark) {
      if (priorityColor == const Color(0xFFEF4444)) {
        pBadgeTextColor = const Color(0xFFFCA5A5);
      } else if (priorityColor == const Color(0xFFF59E0B)) {
        pBadgeTextColor = const Color(0xFFFCD34D);
      } else {
        pBadgeTextColor = const Color(0xFF6EE7B7);
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildDetailHeader(context, "Job Details"),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            // 🌟 ODOO SMART BUTTONS SECTION
            Row(
              children: [
                _buildSmartButton(
                  icon: Icons.border_color_rounded,
                  label: "Job Applications form",
                  count: _applicantsCount,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ApplicationsListPage(
                          filterJobId: widget.job.jobId ?? widget.job.id,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 12),
                _buildSmartButton(
                  icon: Icons.description_outlined,
                  label: "Documents",
                  count: _documentsCount,
                  onTap: _showDocumentsSheet,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 🌟 TOP JOB IDENTITY CARD
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).cardColor : const Color(0xFFEBF3FF),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Theme.of(context).dividerColor, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const  Color(0xFF3B82F6).withOpacity(0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.business_center_rounded,
                          color: const Color(0xFF3B82F6),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.job.title,
                              style:  TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF0F172A),
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.job.department,
                              style: const TextStyle(
                                color: const Color(0xFF3B82F6),
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Color(0xFFE2E8F0), height: 1),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 16,
                    runSpacing: 10,
                    children: [
                      _rowInfo(Icons.history_rounded, widget.job.experience.isEmpty ? 'Not Spec' : widget.job.experience),
                      _rowInfo(Icons.monetization_on_outlined, widget.job.salary.isEmpty ? 'N/A' : widget.job.salary),
                      _rowInfo(Icons.location_on_rounded, widget.job.location.isEmpty ? 'N/A' : widget.job.location),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      _pillBadge(
                        icon: widget.job.isPublished ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
                        text: widget.job.isPublished ? 'Published' : 'Draft',
                        bgColor: widget.job.isPublished 
                            ? (isDark ? const Color(0xFF047857).withOpacity(0.15) : const Color(0xFFECFDF5))
                            : (isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFF1F5F9)),
                        textColor: widget.job.isPublished 
                            ? (isDark ? const Color(0xFF6EE7B7) : const Color(0xFF047857))
                            : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
                      ),
                      _pillBadge(
                        icon: Icons.star_rounded,
                        text: "${widget.job.priority} Priority",
                        bgColor: pBadgeBgColor,
                        textColor: pBadgeTextColor,
                      ),
                      _pillBadge(
                        icon: Icons.info_outline_rounded,
                        text: widget.job.status,
                        bgColor: isDark ? const Color(0xFF1D4ED8).withOpacity(0.15) : const Color(0xFFEFF6FF),
                        textColor: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 🌟 PRIMARY SKILLS PANEL
            if (widget.job.primarySkills.isNotEmpty) ...[
              _sectionTitle("Primary Skills Required"),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.job.primarySkills.map((s) {
                  return _tagChip(s, const  Color(0xFF3B82F6), const  Color(0xFFEBF3FF));
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],

            // 🌟 SECONDARY SKILLS PANEL
            if (widget.job.secondarySkills.isNotEmpty) ...[
              _sectionTitle("Secondary Skills Required"),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.job.secondarySkills.map((s) {
                  return _tagChip(s, const Color(0xFFD97706), const Color(0xFFFFFBEB));
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],

            // 🌟 JOB DESCRIPTION CARD
            if (widget.job.description.trim().isNotEmpty) ...[
              _sectionTitle("Job Description"),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: _buildRichDescriptionText(widget.job.description),
              ),
              const SizedBox(height: 24),
            ],

            // 🌟 RESPONSIBILITIES PANEL
            if (widget.job.responsibilities.isNotEmpty) ...[
              _sectionTitle("Key Responsibilities"),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Column(
                  children: widget.job.responsibilities.map((r) => _bulletPoint(r)).toList(),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // 🌟 REQUIREMENTS PANEL
            if (widget.job.requirements.isNotEmpty) ...[
              _sectionTitle("Minimum Requirements"),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Column(
                  children: widget.job.requirements.map((req) => _bulletPoint(req)).toList(),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // 🌟 JOB METADATA SUMMARY DETAILS CARDS
            _sectionTitle("Job Directory Summary"),
            const SizedBox(height: 12),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _metadataCard(Icons.apartment_rounded, "Department", widget.job.department)),
                  const SizedBox(width: 14),
                  Expanded(child: _metadataCard(Icons.work_history_rounded, "Experience Required", widget.job.experience.isEmpty ? 'Not specified' : widget.job.experience)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _metadataCard(Icons.payments_rounded, "Budget / Salary", widget.job.salary.isEmpty ? 'Not specified' : widget.job.salary)),
                  const SizedBox(width: 14),
                  Expanded(child: _metadataCard(Icons.access_time_filled_rounded, "Employment Type", widget.job.type.isEmpty ? 'Full-time' : widget.job.type)),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    ),
  ],
),
);
}

  Widget _buildDetailHeader(BuildContext context, String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 16, 16, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white.withOpacity(0.06),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon:  Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style:  TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(width: 48), // Balance spacing
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : Colors.black54,
        letterSpacing: -0.3,
      ),
    );
  }

  Widget _rowInfo(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Theme.of(context).textTheme.bodyMedium?.color ?? const Color(0xFF64748B), size: 16),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            value,
            style:  TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _pillBadge({
    required IconData icon,
    required String text,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tagChip(String label, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: textColor.withOpacity(0.1)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _bulletPoint(String text) {
    final trimmed = text.trim();
    String cleanLine = trimmed;
    if (trimmed.startsWith('•') || trimmed.startsWith('-') || trimmed.startsWith('*')) {
      cleanLine = trimmed.substring(1).trim();
    }

    final colonIndex = cleanLine.indexOf(':');
    final hasColon = colonIndex > 0 && colonIndex < 35;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: const Color(0xFF3B82F6),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: hasColon
                ? RichText(
                    text: TextSpan(
                      style:  TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                      ),
                      children: [
                        TextSpan(
                          text: cleanLine.substring(0, colonIndex + 1),
                          style:  TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        TextSpan(
                          text: cleanLine.substring(colonIndex + 1),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : Text(
                    cleanLine,
                    style:  TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _metadataCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const  Color(0xFFEBF3FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const  Color(0xFF3B82F6), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style:  TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF0F172A),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRichDescriptionText(String text) {
    final lines = text.split('\n');
    final List<Widget> children = [];

    for (var line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) {
        children.add(const SizedBox(height: 10));
        continue;
      }

      bool isBullet = trimmed.startsWith('•') || trimmed.startsWith('-') || trimmed.startsWith('*');
      String cleanLine = trimmed;
      if (isBullet) {
        cleanLine = trimmed.substring(1).trim();
      }

      final colonIndex = cleanLine.indexOf(':');
      if (colonIndex > 0 && colonIndex < 35) {
        final prefix = cleanLine.substring(0, colonIndex + 1);
        final suffix = cleanLine.substring(colonIndex + 1);

        children.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isBullet) ...[
                  Container(
                    margin: const EdgeInsets.only(top: 6, right: 10),
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: const Color(0xFF3B82F6),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style:  TextStyle(
                        fontSize: 14.5,
                        height: 1.6,
                        color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                      ),
                      children: [
                        TextSpan(
                          text: prefix,
                          style:  TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        TextSpan(
                          text: suffix,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        children.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isBullet) ...[
                  Container(
                    margin: const EdgeInsets.only(top: 6, right: 10),
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: const Color(0xFF3B82F6),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
                Expanded(
                  child: Text(
                    cleanLine,
                    style:  TextStyle(
                      fontSize: 14.5,
                      height: 1.6,
                      color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
