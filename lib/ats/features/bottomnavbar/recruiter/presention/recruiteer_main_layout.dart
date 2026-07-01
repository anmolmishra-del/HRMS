import 'package:flutter/material.dart';
import 'package:flutter_app/core/constants/app_colors.dart';
import 'package:flutter_app/ats/features/dashboard/presentaion/dashboard_page.dart';
import 'package:flutter_app/ats/utils/shared_ref.dart';
import 'package:flutter_app/ats/routes/app_routes.dart';
import 'package:flutter_app/ats/features/candidatefolder/candidate/presentaion/candidate_page.dart';
import 'package:flutter_app/ats/features/jobs/presentaion/job_page.dart';
import 'package:flutter_app/ats/features/applications/presentation/applications_list_page.dart';
import 'package:flutter_app/ats/features/profile/presentation/profile_page.dart';

class RecruiterMainLayout extends StatefulWidget {
  const RecruiterMainLayout({super.key});

  @override
  State<RecruiterMainLayout> createState() => _RecruiterMainLayoutState();
}

class _RecruiterMainLayoutState extends State<RecruiterMainLayout> {
  int currentIndex = 0;
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    _checkAuth();
    
    pages = [
      DashboardPage(onTabChanged: (index) {
        onTabChanged(index);
      }),
      JobPage(isRecruiter: true),
      ApplicationsListPage(),
      CandidatePage(),
      const RecruiterProfilePage(showBackButton: false),
    ];
  }

  Future<void> _checkAuth() async {
    final prefs = SharedPref();
    final isLoggedIn = await prefs.getBool('isLoggedIn') ?? false;
    if (!isLoggedIn) {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
          (route) => false,
        );
      }
    }
  }



  final List<_NavItem> navItems = const [
    _NavItem(icon: Icons.home_rounded, activeIcon: Icons.home_rounded, label: "Home"),
    _NavItem(icon: Icons.work_outline_rounded, activeIcon: Icons.work_rounded, label: "Jobs"),
    _NavItem(icon: Icons.description_outlined, activeIcon: Icons.description, label: "Applications"),
    _NavItem(icon: Icons.people_outline_rounded, activeIcon: Icons.people_rounded, label: "Candidates"),
    _NavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: "Profile"),
  ];

  void onTabChanged(int index) {
    print("[DEBUG] RecruiterMainLayout: Tab changed from $currentIndex to $index");
    setState(() => currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBody: true,
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: SafeArea(
        child: _buildBottomNav(),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.brightBlue.withOpacity(0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          navItems.length,
          (index) => _buildNavItem(index),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final item = navItems[index];
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTabChanged(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuint,
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 12 : 8, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.brightBlue.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with animated color
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Icon(
                isSelected ? item.activeIcon : item.icon,
                key: ValueKey(isSelected),
                size: 22,
                color: isSelected ? AppColors.brightBlue : AppColors.textGrey,
              ),
            ),

            // Animated label — only shown when selected
            AnimatedSize(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeInOut,
              child: isSelected
                  ? Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        item.label,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.brightBlue,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.1,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
