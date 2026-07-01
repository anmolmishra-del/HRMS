import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/features/recruiter/cubit/recruiter_cubit.dart';
import 'package:flutter_app/ats/features/recruiter/state/recruiter_profile_state.dart';
import 'package:flutter_app/ats/features/auth/cubit/login_cubit.dart';
import 'package:flutter_app/ats/routes/app_routes.dart';

class RecruiterProfilePage extends StatelessWidget {
  const RecruiterProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RecruiterProfileCubit(),

      child: Scaffold(
        // backgroundColor: Colors.grey.shade100,
        body: BlocBuilder<RecruiterProfileCubit, RecruiterProfileState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 50),
                  // TOP HEADER
                  Row(
                    children: [
                      const SizedBox(width: 16),

                      const Icon(Icons.edit_outlined, color: Colors.black),
                    ],
                  ),

                  // PROFILE CARD
                  Transform.translate(
                    offset: const Offset(0, -30),

                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),

                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        // color: Colors.white,
                        borderRadius: BorderRadius.circular(24),

                        // border: Border.all(
                        //   color: Colors.grey.shade500,
                        // ),
                      ),

                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 50,

                            backgroundColor: const Color(0xFF3B82F6),

                            child: Icon(
                              Icons.person,

                              size: 50,

                              // color:
                              //     Colors.white,
                            ),
                          ),

                          const SizedBox(height: 16),

                          Text(
                            state.name,

                            style: const TextStyle(
                              fontSize: 28,

                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            state.role,

                            style: const TextStyle(
                              color: const Color(0xFF3B82F6),

                              fontSize: 18,
                            ),
                          ),

                          const SizedBox(height: 20),

                          _tile(
                            Icons.email,
                            state.email,
                            iconColor: Colors.deepOrange,
                            // textColor:
                          ),

                          _tile(
                            Icons.phone,
                            state.phone,
                            iconColor: Colors.blue,
                          ),

                          _tile(
                            Icons.location_on,
                            state.location,
                            iconColor: Colors.green,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // STATS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),

                    child: Row(
                      children: [
                        Expanded(
                          child: _statCard(
                            Icons.work,

                            "24",

                            "Jobs Posted",

                            iconColor: Colors.blue,

                            iconBgColor: Colors.blue.shade50,

                            labelColor: Colors.blue,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _statCard(
                            Icons.people,

                            "120",

                            "Applicants",

                            iconColor: Colors.green,

                            iconBgColor: Colors.green.shade50,

                            labelColor: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),

                    child: Row(
                      children: [
                        Expanded(
                          child: _statCard(
                            Icons.person_add_alt,

                            state.hired.toString(),

                            "Hired",
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _statCard(
                            Icons.remove_red_eye,

                            state.profileViews,

                            "Views",
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ABOUT
                  // _sectionCard(

                  //   title: "About Me",

                  //   child: Text(
                  //     state.about,

                  //     style: const TextStyle(
                  //       fontSize: 16,
                  //       height: 1.5,
                  //     ),
                  //   ),
                  // ),

                  // INFO
                  _sectionCard(
                    title: "Information",

                    child: Column(
                      children: [
                        _infoRow("Member Since", state.memberSince),

                        _infoRow("Company", state.company),

                        _infoRow("Designation", state.designation),

                        _infoRow("Website", state.website),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // LOGOUT
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),

                    child: SizedBox(
                      width: double.infinity,
                      height: 60,

                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final cubit = context.read<AtsLoginCubit>();
                          await cubit.logout();

                          if (context.mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.login,
                              (route) => false,
                            );
                          }
                        },
                        icon: const Icon(Icons.logout),

                        label: const Text("Logout"),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),

                          foregroundColor: Colors.white,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _tile(
    IconData icon,
    String text, {

    Color iconColor = const Color(0xFF3B82F6),

    Color textColor = Colors.black,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: Row(
        children: [
          Icon(icon, color: iconColor),

          const SizedBox(width: 10),

          Expanded(
            child: Text(text, style: TextStyle(fontSize: 16, color: textColor)),
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    IconData icon,
    String count,
    String label, {

    Color iconColor = const Color(0xFF3B82F6),

    Color iconBgColor = const Color(0xffEEE8FF),

    Color labelColor = Colors.grey,

    Color countColor = Colors.black,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: Colors.grey.shade400),
      ),

      child: Row(
        children: [
          // LEFT ICON
          Container(
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: iconBgColor,

              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(icon, color: iconColor, size: 28),
          ),

          const SizedBox(width: 10),

          // RIGHT TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text(
                  count,

                  style: TextStyle(
                    fontSize: 22,

                    fontWeight: FontWeight.bold,

                    color: countColor,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  label,

                  maxLines: 2,

                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(color: labelColor, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade500),
        boxShadow: [
          // BoxShadow(
          //   color:
          //       Colors.grey.shade300,

          //   blurRadius: 8,
          // ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,

            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          child,
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),

          Text(value),
        ],
      ),
    );
  }
}
