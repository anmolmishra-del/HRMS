// import 'package:flutter/material.dart';
// import 'package:flutter_app/ats/features/candidatefolder/candidate/state/hr_candidate_model.dart';

// class CandidateDetailsPage extends StatelessWidget {
//   final HrCandidate candidate;

//   const CandidateDetailsPage({
//     super.key,
//     required this.candidate,
//   });

//   Widget buildStars(String priority) {
//     int rating = int.tryParse(priority) ?? 0;

//     if (rating > 5) rating = 5;

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(
//         5,
//         (index) => Icon(
//           Icons.star,
//           size: 20,
//           color: index < rating
//               ? Colors.amber
//               : Colors.grey.shade300,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final fullName = candidate.fullName;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(candidate.firstName),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             CircleAvatar(
//               radius: 45,
//               child: Text(
//                 candidate.firstName.isNotEmpty
//                     ? candidate.firstName[0].toUpperCase()
//                     : "?",
//                 style: const TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             Text(
//               fullName,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//             const SizedBox(height: 8),

//             Text(
//               "Candidate ID : ${candidate.odooId ?? '-'}",
//               style: const TextStyle(fontSize: 14),
//             ),

//             const SizedBox(height: 12),

//             buildStars(candidate.priority),

//             const SizedBox(height: 20),

//             Card(
//               child: ListTile(
//                 leading: const Icon(Icons.school),
//                 title: Text(candidate.typeId),
//                 subtitle: const Text("Degree"),
//               ),
//             ),

//             Card(
//               child: ListTile(
//                 leading: const Icon(Icons.email),
//                 title: Text(
//                   candidate.emailFrom.isEmpty
//                       ? "-"
//                       : candidate.emailFrom,
//                 ),
//                 subtitle: const Text("Email"),
//               ),
//             ),

//             Card(
//               child: ListTile(
//                 leading: const Icon(Icons.phone),
//                 title: Text(
//                   candidate.partnerPhone.isEmpty
//                       ? "-"
//                       : candidate.partnerPhone,
//                 ),
//                 subtitle: const Text("Phone"),
//               ),
//             ),

//             if (candidate.alternatePhone != null &&
//                 candidate.alternatePhone!.isNotEmpty)
//               Card(
//                 child: ListTile(
//                   leading: const Icon(Icons.phone_android),
//                   title: Text(candidate.alternatePhone!),
//                   subtitle: const Text("Alternate Phone"),
//                 ),
//               ),

//             Card(
//               child: ListTile(
//                 leading: const Icon(Icons.person),
//                 title: Text(candidate.userId),
//                 subtitle: const Text("Candidate Manager"),
//               ),
//             ),

//             Card(
//               child: ListTile(
//                 leading: const Icon(Icons.business),
//                 title: Text(candidate.companyId),
//                 subtitle: const Text("Company"),
//               ),
//             ),

//             Card(
//               child: ListTile(
//                 leading: const Icon(Icons.link),
//                 title: Text(
//                   candidate.linkedinProfile?.isNotEmpty == true
//                       ? candidate.linkedinProfile!
//                       : "-",
//                 ),
//                 subtitle: const Text("LinkedIn Profile"),
//               ),
//             ),

//             Card(
//               child: ListTile(
//                 leading: const Icon(Icons.calendar_month),
//                 title: Text(
//                   candidate.availability
//                       .toString()
//                       .split(' ')
//                       .first,
//                 ),
//                 subtitle: const Text("Availability"),
//               ),
//             ),

//             Card(
//               child: ListTile(
//                 leading: const Icon(Icons.flag),
//                 title: Text(candidate.stage),
//                 subtitle: const Text("Current Stage"),
//               ),
//             ),

//             Card(
//               child: ListTile(
//                 leading: const Icon(Icons.percent),
//                 title: Text(
//                   "${candidate.matchingSkillPercentage.toStringAsFixed(1)}%",
//                 ),
//                 subtitle: const Text("Matching Skill Percentage"),
//               ),
//             ),

//             if (candidate.skills.isNotEmpty) ...[
//               const SizedBox(height: 16),

//               const Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   "Skills",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 8),

//               ...candidate.skills.map(
//                 (skill) => Card(
//                   child: ListTile(
//                     leading: const Icon(Icons.star_outline),
//                     title: Text(skill.skillId),
//                     subtitle: Text(
//                       "${skill.skillTypeId} • ${skill.skillLevel}",
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }