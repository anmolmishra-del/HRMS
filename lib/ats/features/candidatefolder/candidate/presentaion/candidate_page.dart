import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/ats/core/constants/app_colors.dart';
import 'package:flutter_app/ats/features/candidatefolder/candidate_screen/presentaion/candidate_page.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:flutter_app/ats/utils/ats_localization.dart';

import '../cubit/candidate_cubit.dart';
import '../state/candidate_state.dart';
import '../state/hr_candidate_model.dart';

class CandidatePage extends StatelessWidget {
  const CandidatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Sleek, modern slate background
      body: BlocBuilder<CandidateCubit, CandidateState>(
        builder: (context, state) {
          print("[DEBUG] CandidatePage BlocBuilder rebuilt. Candidates count: ${state.candidates.length}, Selected Tab: ${state.selectedTab}");
          
          final cubit = context.read<CandidateCubit>();
          final l10n = AppLocalizations.of(context);
          final tabCounts = state.tabCounts;
          final searchLower = state.searchQuery.toLowerCase();
        
        final filtered = state.candidates.where((candidate) {
          final matchTab = candidate.stage == state.selectedTab;
          
          final nameMatch = candidate.fullName.toLowerCase().contains(searchLower);
          final emailMatch = candidate.emailFrom.toLowerCase().contains(searchLower);
          final degreeMatch = candidate.typeId.toLowerCase().contains(searchLower);
          final skillMatch = candidate.skills.any((s) => s.skillId.toLowerCase().contains(searchLower));
          
          return matchTab && (nameMatch || emailMatch || degreeMatch || skillMatch);
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🌟 CUSTOM PREMIUM HEADER
            Container(
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
                                l10n?.ats_recruitment ?? "Recruitment",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                               Text(
                                l10n?.ats_candidates_folder ?? "Candidates Folder",
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        onChanged: cubit.search,
                        style:  TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF0F172A), fontSize: 15),
                        decoration: InputDecoration(
                          hintText: l10n?.ats_search_candidate_hint ?? "Search name, degree, email, or skill...",
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
            ),
            
            // const SizedBox(height: 16),
            
            // 🧬 HORIZONTAL TABS FOR ODOO RECRUITMENT STAGES
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: SingleChildScrollView(
            //     scrollDirection: Axis.horizontal,
            //     physics: const BouncingScrollPhysics(),
            //     child: Row(
            //       children: tabCounts.entries.map((entry) {
            //         final isActive = state.selectedTab == entry.key;
            //         return GestureDetector(
            //           onTap: () => cubit.changeTab(entry.key),
            //           child: AnimatedContainer(
            //             duration: const Duration(milliseconds: 250),
            //             margin: const EdgeInsets.only(right: 12),
            //             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            //             decoration: BoxDecoration(
            //               gradient: isActive
            //                   ? const LinearGradient(
            //                       colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
            //                       begin: Alignment.topLeft,
            //                       end: Alignment.bottomRight,
            //                     )
            //                   : null,
            //               color: isActive ? null : Colors.white,
            //               borderRadius: BorderRadius.circular(16),
            //               boxShadow: isActive
            //                   ? [
            //                       BoxShadow(
            //                         color: AppColors.primary.withOpacity(0.2),
            //                         blurRadius: 8,
            //                         offset: const Offset(0, 4),
            //                       ),
            //                     ]
            //                   : [
            //                       const BoxShadow(
            //                         color: Color(0x05000000),
            //                         blurRadius: 4,
            //                         offset: Offset(0, 2),
            //                       ),
            //                     ],
            //             ),
            //             child: Row(
            //               children: [
            //                 Text(
            //                   entry.key,
            //                   style: TextStyle(
            //                     color: isActive ? Colors.white : const Color(0xFF475569),
            //                     fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
            //                     fontSize: 14,
            //                   ),
            //                 ),
            //                 const SizedBox(width: 8),
            //                 Container(
            //                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            //                   decoration: BoxDecoration(
            //                     color: isActive ? Colors.white.withOpacity(0.2) : const Color(0xFFF1F5F9),
            //                     borderRadius: BorderRadius.circular(10),
            //                   ),
            //                   child: Text(
            //                     "${entry.value}",
            //                     style: TextStyle(
            //                       color: isActive ? Colors.white : const Color(0xFF64748B),
            //                       fontSize: 12,
            //                       fontWeight: FontWeight.bold,
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         );
            //       }).toList(),
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 16),
            
            // 👥 CANDIDATES LIST
            Expanded(
              child: state.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  : filtered.isEmpty
                      ? Center(
                          child: Text(
                            l10n?.ats_no_candidates ?? "No candidates in this stage.",
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 100),
                          physics: const BouncingScrollPhysics(),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final candidate = filtered[index];
                            print("[DEBUG] Displaying candidate #$index: ${candidate.fullName} (${candidate.emailFrom})");
                            return _buildCandidateCard(context, candidate, cubit);
                          },
                        ),
            ),
          ],
        );
      },
    ),
  );
}

  // Beautiful Card Widget displaying candidate and Odoo skills matching score
  Widget _buildCandidateCard(BuildContext context, HrCandidate candidate, CandidateCubit cubit) {
    // Determine skill color based on score
    final double score = candidate.matchingSkillPercentage;
    Color scoreColor = Colors.orange;
    if (score >= 70) scoreColor = AppColors.success;
    else if (score >= 40) scoreColor = Colors.blue;

    final int stars = int.tryParse(candidate.priority) ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border:Border(left: BorderSide(color:   Colors.primaries[candidate.userId.hashCode % Colors.primaries.length], width: 4)),
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
              cubit.selectCandidate(candidate);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: cubit,
                    child: const CandidateProfilePage(),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar with gradient border
                      Container(
                        padding: const EdgeInsets.all(2.5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)],
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 26,
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                            child: ClipOval(
                              child: candidate.image != null && candidate.image!.isNotEmpty
                                  ? Image.memory(
                                      base64Decode(candidate.image!),
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.network(
                                          "https://i.pravatar.cc/150?u=${candidate.emailFrom}",
                                          width: 48,
                                          height: 48,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                  : Image.network(
                                      "https://i.pravatar.cc/150?u=${candidate.emailFrom}",
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Core details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              candidate.fullName,
                              style:  TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              candidate.typeId, // Degree
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            // Evaluation priority stars
                            Row(
                              children: List.generate(3, (starIdx) {
                                return Icon(
                                  Icons.star_rounded,
                                  size: 16,
                                  color: starIdx < stars ? AppColors.warning : const Color(0xFFCBD5E1),
                                );
                              }),
                            ),
                            if (candidate.categIds.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: candidate.categIds.take(3).map((tag) {
                                  final isIt = tag.toLowerCase() == 'it';
                                  final isReserve = tag.toLowerCase() == 'reserve';
                                  final bgColor = isIt 
                                      ? const  Color(0xFFEBF3FF) 
                                      : (isReserve ? const Color(0xFFFFF7ED) : const Color(0xFFF1F5F9));
                                  final textColor = isIt 
                                      ? const  Color(0xFF3B82F6) 
                                      : (isReserve ? const Color(0xFFEA580C) : const Color(0xFF475569));
                                  
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: bgColor,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      tag,
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Matching score dial
                      // Column(
                      //   children: [
                      //     Container(
                      //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      //       decoration: BoxDecoration(
                      //         color: scoreColor.withOpacity(0.09),
                      //         borderRadius: BorderRadius.circular(16),
                      //       ),
                      //       child: Column(
                      //         children: [
                      //           Text(
                      //             "${score.toInt()}%",
                      //             style: TextStyle(
                      //               fontSize: 15,
                      //               fontWeight: FontWeight.w900,
                      //               color: scoreColor,
                      //             ),
                      //           ),
                      //           const Text(
                      //             "Skill Match",
                      //             style: TextStyle(
                      //               fontSize: 9,
                      //               fontWeight: FontWeight.w600,
                      //               color: Color(0xFF64748B),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Divider(color: Theme.of(context).dividerColor, height: 1),
                  const SizedBox(height: 12),
                  // Alternative display: skills mapping tags
                  Row(
                    children: [
                      const Icon(Icons.psychology_outlined, size: 16, color: Color(0xFF64748B)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: candidate.skills.map((skill) {
                              return Container(
                                margin: const EdgeInsets.only(right: 6),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Theme.of(context).dividerColor, width: 1),
                                ),
                                child: Text(
                                  skill.skillId,
                                  style:  TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Availability row
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 15, color: Color(0xFF64748B)),
                      const SizedBox(width: 6),
                      Text(
                        "Availability: ${DateFormat('dd MMM yyyy').format(candidate.availability)}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      // Display if Job Application is linked
                      if (candidate.linkedApplicationId != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle, color: AppColors.primary, size: 12),
                              const SizedBox(width: 4),
                              Text(
                                candidate.linkedApplicationId!,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
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

  }

