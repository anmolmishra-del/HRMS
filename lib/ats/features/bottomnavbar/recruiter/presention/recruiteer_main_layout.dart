import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/core/constants/app_colors.dart';
import 'package:flutter_app/ats/features/dashboard/presentaion/dashboard_page.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:flutter_app/ats/utils/shared_ref.dart';
import 'package:flutter_app/ats/routes/app_routes.dart';
import 'package:flutter_app/ats/features/candidatefolder/candidate/presentaion/candidate_page.dart';
import 'package:flutter_app/ats/features/jobs/presentaion/job_page.dart';
import 'package:flutter_app/ats/features/applications/presentation/applications_list_page.dart';
import 'package:flutter_app/features/profile/profile_screen.dart';
import 'package:flutter_app/features/profile/cubit/profile_cubit.dart';
import 'package:flutter_app/features/profile/cubit/profile_state.dart';
import 'package:flutter_app/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      const JobPage(isRecruiter: true, showBackButton: false),
      const ApplicationsListPage(showBackButton: false),
      const CandidatePage(showBackButton: false),
      const ProfileScreen(),
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



  List<_NavItem> _getNavItems(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      _NavItem(icon: Icons.home_rounded, activeIcon: Icons.home_rounded, label: l10n?.ats_home ?? "Home"),
      _NavItem(icon: Icons.work_outline_rounded, activeIcon: Icons.work_rounded, label: l10n?.ats_jobs ?? "Jobs"),
      _NavItem(icon: Icons.description_outlined, activeIcon: Icons.description, label: l10n?.ats_applications ?? "Applications"),
      _NavItem(icon: Icons.people_outline_rounded, activeIcon: Icons.people_rounded, label: l10n?.ats_candidates ?? "Candidates"),
      _NavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: l10n?.ats_profile ?? "Profile"),
    ];
  }

  void onTabChanged(int index) {
    print("[DEBUG] RecruiterMainLayout: Tab changed from $currentIndex to $index");
    setState(() => currentIndex = index);
  }

  Future<bool> _showExitConfirmationDialog() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: isDark ? Theme.of(context).colorScheme.surface : Colors.white,
        title: Row(
          children: [
            Icon(Icons.exit_to_app_rounded, color: Colors.orange.shade400, size: 28),
            const SizedBox(width: 12),
            const Text(
              "Exit App",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        content: const Text(
          "Are you sure you want to exit the application?",
          style: TextStyle(fontSize: 15, height: 1.4),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: isDark ? Colors.white70 : Colors.grey.shade600,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text("Exit", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _switchToHrms(BuildContext context) async {
    await SharedPref().saveString('selected_portal', 'hrms');
    if (context.mounted) {
      context.read<ProfileCubit>().fetchProfile();
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.main, (route) => false);
    }
  }

  void _showAccessDisabledDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Access Denied'),
        content: const Text('You no longer have access to the ATS portal. Switching you back to HRMS portal.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              _switchToHrms(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) => current.status == ProfileStatus.success && !current.isAtsEnabled,
      listener: (context, state) {
        _showAccessDisabledDialog(context);
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, dynamic result) async {
          if (didPop) return;

          if (currentIndex != 0) {
            // If not on Home tab, return to Home tab
            setState(() {
              currentIndex = 0;
            });
          } else {
            // If on Home tab, show exit confirmation prompt
            final shouldExit = await _showExitConfirmationDialog();
            if (shouldExit) {
              await SystemNavigator.pop();
            }
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          extendBody: true,
          body: IndexedStack(
            index: currentIndex,
            children: pages,
          ),
          bottomNavigationBar: SafeArea(
            child: _buildBottomNav(),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = _getNavItems(context);
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
          items.length,
          (index) => _buildNavItem(index),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final items = _getNavItems(context);
    final item = items[index];
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
