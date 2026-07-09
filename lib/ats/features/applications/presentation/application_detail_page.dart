import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:flutter_app/ats/utils/ats_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/ats/core/constants/app_colors.dart';
import '../cubit/applications_cubit.dart';
import '../state/applications_state.dart';
import '../state/hr_applicant_model.dart';

class ApplicationDetailPage extends StatefulWidget {
  const ApplicationDetailPage({super.key});

  @override
  State<ApplicationDetailPage> createState() => _ApplicationDetailPageState();
}

class _ApplicationDetailPageState extends State<ApplicationDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicationsCubit, ApplicationsState>(
      builder: (context, state) {
        final app = state.selectedApplication;
        if (app == null) {
          return const Scaffold(
            body: Center(child: Text("No application selected")),
          );
        }

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Sleek, modern slate background
          body: Column(
            children: [
              _buildDetailHeader(context, AppLocalizations.of(context)!.applicationProfile),
              // Premium Info Summary Card with Gradient Profile Layout
              _buildTopSummary(app),

              // Glassmorphic Custom Tab Navigation
              Container(
                color: Theme.of(context).cardColor,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  physics: const BouncingScrollPhysics(),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: AppColors.primary.withOpacity(0.12),
                  ),
                  labelColor: AppColors.primary,
                  unselectedLabelColor: const Color(0xFF64748B),
                  labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 0.3),
                  tabs: [
                    Tab(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(AtsLocalizations.translate(context, "Info")))),
                    Tab(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(AtsLocalizations.translate(context, "Details")))),
                    Tab(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(AtsLocalizations.translate(context, "Additional Info")))),
                    Tab(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(AtsLocalizations.translate(context, "Notes & Comments")))),
                  ],
                ),
              ),
              
              // Content Tab Views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildInfoTab(app),
                    _buildDetailsTab(app),
                    _buildAdditionalInfoTab(app),
                    _buildNotesTab(app),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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

  Widget _buildTopSummary(HrApplicant app) {
    Color statusColor = const Color(0xFFF59E0B);
    if (app.applicationStatus == 'Hired') statusColor = const Color(0xFF10B981);
    if (app.applicationStatus == 'Refused') statusColor = const Color(0xFFEF4444);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.06), // Soft light pastel primary color accent
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        border: Border(
          bottom: BorderSide(color: AppColors.primary.withOpacity(0.1), width: 1.5),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar with beautiful gradient border
              Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child:  CircleAvatar(
                  radius: 34,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: const Color(0xFFEBF3FF),
                    child: Icon(Icons.description_rounded, color: AppColors.primary, size: 28),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app.name,
                      style:  TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.work_rounded, size: 13, color: AppColors.primary),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            app.jobName.isNotEmpty ? app.jobName : AtsLocalizations.translate(context, "No Linked Position"),
                            style:  TextStyle(color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : const Color(0xFF475569), fontSize: 13, fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
               ),
             ],
           ),
           const SizedBox(height: 24),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               // _buildSummaryIndicator("Status", app.applicationStatus, statusColor),
               _buildSummaryIndicator(AtsLocalizations.translate(context, "Stage"), app.stageName, AppColors.primary),
               _buildSummaryIndicator(
                 AtsLocalizations.translate(context, "Availability"),
                 app.availability != null ? DateFormat('dd MMM yyyy').format(app.availability!) : AtsLocalizations.translate(context, "Not specified"),
                 const Color(0xFF0EA5E9),
               ),
             ],
           ),
        ],
      ),
    );
  }

  Widget _buildSummaryIndicator(String label, String value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withOpacity(0.08)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x04000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF94A3B8),
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.09),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w800),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTab(HrApplicant app) {
    return ListView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      children: [
        _buildInfoCard(AtsLocalizations.translate(context, "Candidate Identity"), [
          _buildDetailRow(Icons.person, AtsLocalizations.translate(context, "Candidate Name"), app.candidateName, const  Color(0xFF3B82F6)),
          _buildDetailRow(Icons.email, AtsLocalizations.translate(context, "Email Address"), app.emailFrom, const Color(0xFFEF4444)),
          _buildDetailRow(Icons.phone, AtsLocalizations.translate(context, "Phone Number"), app.partnerPhone, const Color(0xFF10B981)),
          _buildDetailRow(Icons.link, AtsLocalizations.translate(context, "LinkedIn Profile"), app.linkedinProfile.isNotEmpty ? app.linkedinProfile : AtsLocalizations.translate(context, "Not linked"), const Color(0xFF0077B5)),
        ]),
        const SizedBox(height: 16),
        _buildInfoCard(AtsLocalizations.translate(context, "Salary details"), [
          _buildDetailRow(Icons.payments_outlined, AtsLocalizations.translate(context, "Current CTC"), "\$${app.currentCtc.toStringAsFixed(2)}", const Color(0xFFF59E0B)),
          _buildDetailRow(Icons.trending_up, AtsLocalizations.translate(context, "Expected Salary"), "\$${app.salaryExpected.toStringAsFixed(2)}", const Color(0xFF10B981)),
          _buildDetailRow(Icons.price_check, AtsLocalizations.translate(context, "Proposed Salary"), "\$${app.salaryProposed.toStringAsFixed(2)}", const Color(0xFF8B5CF6)),
          _buildDetailRow(Icons.handshake, AtsLocalizations.translate(context, "Salary Negotiable"), app.salaryNegotiable ? AtsLocalizations.translate(context, "Yes") : AtsLocalizations.translate(context, "No"), const Color(0xFFEC4899)),
        ]),
      ],
    );
  }

  Widget _buildDetailsTab(HrApplicant app) {
    return ListView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      children: [
        _buildInfoCard(AtsLocalizations.translate(context, "Experience details"), [
          _buildDetailRow(Icons.history_toggle_off, AtsLocalizations.translate(context, "Total Experience"), "${app.totalExp} Years", const  Color(0xFF3B82F6)),
          _buildDetailRow(Icons.star_rounded, AtsLocalizations.translate(context, "Relevant Experience"), "${app.relevantExp} Years", const Color(0xFFF59E0B)),
          _buildDetailRow(Icons.hourglass_empty, AtsLocalizations.translate(context, "Notice Period"), app.noticePeriod.isNotEmpty ? app.noticePeriod : AtsLocalizations.translate(context, "No"), const Color(0xFFEF4444)),
          _buildDetailRow(Icons.edit_calendar, AtsLocalizations.translate(context, "NP Negotiable"), app.npNegotiable ? AtsLocalizations.translate(context, "Yes") : AtsLocalizations.translate(context, "No"), const Color(0xFF0EA5E9)),
          _buildDetailRow(Icons.card_giftcard, AtsLocalizations.translate(context, "Holding Offer"), app.holdingOffer.isNotEmpty ? app.holdingOffer : AtsLocalizations.translate(context, "No"), const Color(0xFF10B981)),
        ]),
        const SizedBox(height: 16),
        _buildInfoCard(AtsLocalizations.translate(context, "Recruitment Assignments"), [
          _buildDetailRow(Icons.badge, AtsLocalizations.translate(context, "Recruiter / Handler"), app.userName.isNotEmpty ? app.userName : AtsLocalizations.translate(context, "Not assigned"), const Color(0xFF8B5CF6)),
          _buildDetailRow(Icons.business_center, AtsLocalizations.translate(context, "Job Position"), app.jobName.isNotEmpty ? app.jobName : AtsLocalizations.translate(context, "Not specified"), const Color(0xFFEC4899)),
          _buildDetailRow(Icons.timeline, AtsLocalizations.translate(context, "Experience Type"), app.expType.isNotEmpty ? app.expType : AtsLocalizations.translate(context, "Not specified"), const Color(0xFF0EA5E9)),
          _buildDetailRow(Icons.corporate_fare, AtsLocalizations.translate(context, "Company"), app.companyName.isNotEmpty ? app.companyName : AtsLocalizations.translate(context, "Not specified"), const Color(0xFF64748B)),
        ]),
      ],
    );
  }

  Widget _buildAdditionalInfoTab(HrApplicant app) {
    return ListView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      children: [
        _buildInfoCard(AtsLocalizations.translate(context, "Bio details"), [
          _buildDetailRow(Icons.wc, AtsLocalizations.translate(context, "Gender"), app.gender.isNotEmpty ? app.gender.toUpperCase() : AtsLocalizations.translate(context, "Not specified"), const Color(0xFFEC4899)),
          _buildDetailRow(Icons.cake, AtsLocalizations.translate(context, "Birthday"), app.birthday != null ? DateFormat('dd MMMM yyyy').format(app.birthday!) : AtsLocalizations.translate(context, "Not specified"), const Color(0xFFF59E0B)),
          _buildDetailRow(Icons.bloodtype, AtsLocalizations.translate(context, "Blood Group"), app.bloodGroup.isNotEmpty ? app.bloodGroup : AtsLocalizations.translate(context, "Not specified"), const Color(0xFFEF4444)),
          _buildDetailRow(Icons.favorite_rounded, AtsLocalizations.translate(context, "Marital Status"), app.marital.isNotEmpty ? app.marital.toUpperCase() : AtsLocalizations.translate(context, "Not specified"), const Color(0xFF10B981)),
        ]),
        const SizedBox(height: 16),
        _buildInfoCard(AtsLocalizations.translate(context, "Contact Addresses"), [
          _buildDetailRow(Icons.home, AtsLocalizations.translate(context, "Current Address"), app.privateStreet.isNotEmpty ? app.privateStreet : AtsLocalizations.translate(context, "Not specified"), const  Color(0xFF3B82F6)),
          _buildDetailRow(Icons.location_on, AtsLocalizations.translate(context, "Permanent Address"), app.permanentStreet.isNotEmpty ? app.permanentStreet : AtsLocalizations.translate(context, "Not specified"), const Color(0xFF0EA5E9)),
        ]),
      ],
    );
  }

  Widget _buildNotesTab(HrApplicant app) {
    return ListView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      children: [
        _buildCommentCard(AtsLocalizations.translate(context, "Applicant Comments"), app.applicantComments, const  Color(0xFF3B82F6)),
        const SizedBox(height: 16),
        _buildCommentCard(AtsLocalizations.translate(context, "Recruiter Comments"), app.recruiterComments, const Color(0xFF8B5CF6)),
        const SizedBox(height: 16),
        _buildCommentCard(AtsLocalizations.translate(context, "General Notes"), app.applicantNotes, const Color(0xFF0EA5E9)),
      ],
    );
  }

  Widget _buildCommentCard(String title, String content, Color themeColor) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x02000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 18,
                decoration: BoxDecoration(
                  color: themeColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Color(0xFF1E293B), letterSpacing: 0.3),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            content.isNotEmpty ? content : AtsLocalizations.translate(context, "No records provided."),
            style:  TextStyle(fontSize: 14, color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : const Color(0xFF475569), height: 1.5, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x020F172A),
            blurRadius: 16,
            offset: Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Color(0xFF1E293B), letterSpacing: 0.3),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.w800, letterSpacing: 0.5),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style:  TextStyle(fontSize: 14, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF0F172A), fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
