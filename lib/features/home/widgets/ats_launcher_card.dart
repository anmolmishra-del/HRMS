import 'package:flutter/material.dart';
import 'package:flutter_app/ats/routes/app_routes.dart';

class AtsLauncherCard extends StatelessWidget {
  const AtsLauncherCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6C63FF),
            Color(0xFF3B82F6),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Decorative background glowing circles
            Positioned(
              right: -30,
              top: -30,
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Colors.white.withOpacity(0.08),
              ),
            ),
            Positioned(
              left: -20,
              bottom: -40,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white.withOpacity(0.05),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Navigate to the Recruiter main layout of the integrated ATS module
                  Navigator.pushNamed(context, AppRoutes.recruitermainlayout);
                },
                splashColor: Colors.white.withOpacity(0.12),
                highlightColor: Colors.white.withOpacity(0.06),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Row(
                    children: [
                      // Circular icon badge
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.5),
                        ),
                        child: const Icon(
                          Icons.person_search_rounded, 
                          color: Colors.white, 
                          size: 28
                        ),
                      ),
                      const SizedBox(width: 18),
                      // Text details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Recruiter Role tag
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "RECRUITER PORTAL",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Open ATS Portal",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Manage applicant queues and jobs",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Launch Chevron Icon
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white.withOpacity(0.9),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
