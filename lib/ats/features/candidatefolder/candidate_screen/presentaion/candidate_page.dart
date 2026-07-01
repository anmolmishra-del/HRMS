import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/ats/core/constants/app_colors.dart';
import 'package:flutter_app/ats/features/candidatefolder/candidate/cubit/candidate_cubit.dart';
import 'package:flutter_app/ats/features/candidatefolder/candidate/state/candidate_state.dart';
import 'package:flutter_app/ats/features/candidatefolder/candidate/state/hr_candidate_model.dart';
import 'package:flutter_app/ats/features/candidatefolder/candidate_screen/cubit/candidate_screen_cubit.dart';
import 'package:flutter_app/ats/features/candidatefolder/candidate_screen/presentaion/resume_page.dart';

class CandidateProfilePage extends StatefulWidget {
  const CandidateProfilePage({super.key});

  @override
  State<CandidateProfilePage> createState() => _CandidateProfilePageState();
}

class _CandidateProfilePageState extends State<CandidateProfilePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Inline Skills Mapper State
  String selectedSkillType = '';
  String skillName = '';
  String skillLevel = 'Intermediate';
  final TextEditingController skillNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    skillNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(),
      child: BlocBuilder<CandidateCubit, CandidateState>(
        builder: (context, parentState) {
          print("[DEBUG] CandidateProfilePage BlocBuilder rebuilt. Selected candidate: ${parentState.selectedCandidate?.fullName}, Total candidates: ${parentState.candidates.length}");
          
          final candCubit = context.read<CandidateCubit>();
          // Safely fallback if selectedCandidate is null
          final candidate = parentState.selectedCandidate ?? parentState.candidates.first;
          
          print("[DEBUG] Displaying profile for: ${candidate.fullName} (${candidate.emailFrom})");
          
          final double percentage = candidate.matchingSkillPercentage;
          Color matchColor = Colors.orange;
          if (percentage >= 70) {
            matchColor = AppColors.success;
          } else if (percentage >= 40) matchColor = AppColors.primary;

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Column(
              children: [
                _buildDetailHeader(context, "Candidate Profile"),
                // 🌟 HEADER CARD (PREMIUM METADATA VIEW)
                Container(
                  width: double.infinity,
                  color: Theme.of(context).cardColor,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 42,
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: ClipOval(
                              child: candidate.image != null && candidate.image!.isNotEmpty
                                  ? Image.memory(
                                      base64Decode(candidate.image!),
                                      width: 84,
                                      height: 84,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.network(
                                          "https://i.pravatar.cc/150?u=${candidate.emailFrom}",
                                          width: 84,
                                          height: 84,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                  : Image.network(
                                      "https://i.pravatar.cc/150?u=${candidate.emailFrom}",
                                      width: 84,
                                      height: 84,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  candidate.fullName,
                                  style:  TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.school_outlined, size: 15, color: Color(0xFF64748B)),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        candidate.typeId,
                                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Priority evaluation stars
                                Row(
                                  children: List.generate(3, (starIdx) {
                                    return Icon(
                                      Icons.star_rounded,
                                      size: 20,
                                      color: starIdx < (int.tryParse(candidate.priority) ?? 0)
                                          ? AppColors.warning
                                          : const Color(0xFFCBD5E1),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // TAB NAVIGATION
                Container(
                  color: Theme.of(context).cardColor,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 3,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: const Color(0xFF64748B),
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    tabs: const [
                      Tab(text: "Contact & Bio"),
                      // Combined Skills and Meta into one tab (slide)
                      Tab(text: "Skills & Meta"),
                    ],
                  ),
                ),

                // DETAILS CONTENT
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // TAB 1: Contact details
                      _buildContactTab(candidate),
                      // TAB 2: Skills and Meta Information combined in a single slide (view-only)
                      _buildSkillsAndMetaTab(context, candidate, candCubit),
                    ],
                  ),
                ),

                // ⚡ BOTTOM FLOATING ACTIONS FOR ODOO INTERACTIVE METHODS
                _buildFloatingActionsBar(context, candidate, candCubit),
              ],
            ),
          );
        },
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

  Widget _buildContactTab(HrCandidate candidate) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildInfoCard("Primary Contact", [
          _buildDetailRow(Icons.email_outlined, "Email Address", candidate.emailFrom, isCopyable: true),
          _buildDetailRow(Icons.phone_outlined, "Mobile Phone", candidate.partnerPhone),
          _buildDetailRow(Icons.phone_iphone_outlined, "Alternate Phone", candidate.alternatePhone ?? "Not provided"),
          _buildDetailRow(Icons.link_rounded, "LinkedIn Profile", candidate.linkedinProfile ?? "Not linked"),
        ]),
        const SizedBox(height: 16),
        _buildInfoCard("Recruitment Information", [
          _buildDetailRow(Icons.person_pin_outlined, "Contact Partner Name", candidate.partnerId),
          _buildDetailRow(Icons.badge_outlined, "Candidate Manager", candidate.userId),
          _buildDetailRow(Icons.corporate_fare_outlined, "Odoo Company", candidate.companyId),
        ]),
      ],
    );
  }

  /// 🧬 Combined Skills & Meta Information Tab (Single Slide View)
  /// This view displays both Candidate Status details (Meta info) and the Skills List.
  /// Note: Skills are displayed as VIEW-ONLY (no add or delete buttons).
  Widget _buildSkillsAndMetaTab(BuildContext context, HrCandidate candidate, CandidateCubit cubit) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // 1. CANDIDATE STATUS INFO (Formerly Meta & Actions Tab)
        _buildInfoCard("Candidate Status Info", [
          _buildDetailRow(Icons.calendar_month_outlined, "Availability Date", DateFormat('dd MMMM yyyy').format(candidate.availability)),
          _buildDetailRow(Icons.bookmark_outline, "Recruitment Stage", candidate.stage),
          // _buildDetailRow(Icons.app_registration_outlined, "Job Application Link", candidate.linkedApplicationId ?? "None (Draft)"),
        ]),
        if (candidate.categIds.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildTagsCard(candidate.categIds),
        ],
        const SizedBox(height: 24),

        // 2. ODOO SKILLS LIST SECTION (Formerly Skills Mapping Tab, now VIEW-ONLY)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "Odoo Skills List",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (candidate.skills.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text("No skills mapped for this candidate yet.")),
            ),
          )
        else
          ...candidate.skills.map((skill) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.psychology, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              skill.skillId,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: const Color(0xFFCBD5E1)),
                              ),
                              child: Text(
                                skill.skillLevel,
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Type: ${skill.skillTypeId}",
                          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                  // Note: The delete button/IconButton has been removed to enforce VIEW-ONLY mode.
                ],
              ),
            );
          }).toList(),
      ],
    );
  }

  Widget _buildFloatingActionsBar(BuildContext context, HrCandidate candidate, CandidateCubit cubit) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration:  BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Builder(
          builder: (iconContext) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: iconContext.read<ProfileCubit>(),
                      child: ResumePage(
                        candidateId: candidate.odooId,
                        email: candidate.emailFrom,
                      ),
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width:double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).cardColor : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Download Resume', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue)),
                    // const Spacer(),
                    SizedBox(width: 8),
                     Icon(Icons.article_outlined, color: Colors.blue, size: 20),
                    
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }


  // Info card styling helper
  Widget _buildInfoCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF475569)),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }


  Widget _buildDetailRow(IconData icon, String label, String value, {bool isCopyable = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).textTheme.bodyMedium?.color ?? const Color(0xFF94A3B8), size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style:  TextStyle(fontSize: 14, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF0F172A), fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildTagsCard(List<String> tags) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x050F172A),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children:  [
              Icon(Icons.local_offer_outlined, size: 18, color: Color(0xFF64748B)),
              SizedBox(width: 8),
              Text(
                "Candidate Tags",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((tag) {
              final isIt = tag.toLowerCase() == 'it';
              final isReserve = tag.toLowerCase() == 'reserve';
              
              final bgColor = isIt 
                  ? const  Color(0xFFEBF3FF) 
                  : (isReserve ? const Color(0xFFFFF7ED) : const Color(0xFFF1F5F9));
              final textColor = isIt 
                  ? const  Color(0xFF3B82F6) 
                  : (isReserve ? const Color(0xFFEA580C) : const Color(0xFF475569));
              final borderColor = isIt 
                  ? const Color(0xFFC7D2FE) 
                  : (isReserve ? const Color(0xFFFED7AA) : const Color(0xFFE2E8F0));

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

}
