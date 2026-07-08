import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/features/profile/cubit/profile_cubit.dart';
import 'package:flutter_app/ats/features/profile/state/profile_state.dart';
import 'package:flutter_app/ats/routes/app_routes.dart';
import 'package:flutter_app/ats/features/auth/cubit/login_cubit.dart';
import 'package:flutter_app/core/theme/theme_cubit.dart';
import 'package:flutter_app/routes.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:flutter_app/core/widget/loading_overlay.dart';

class RecruiterProfilePage extends StatelessWidget {
  final bool showBackButton;
  const RecruiterProfilePage({super.key, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<RecruiterProfileCubit, RecruiterProfileState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Stack(
              children: [
                // 1. Gradient Header Background
                Container(
                  height: 260,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -50,
                        right: -50,
                        child: CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      Positioned(
                        bottom: -20,
                        left: -30,
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      // Back Button
                      if (showBackButton)
                        Positioned(
                          top: 48,
                          left: 16,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      // Title
                      Positioned(
                        top: 60,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Text(
                            l10n.my_profile,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Profile Content overlapping the header
                Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: state.isLoading
                      ? const Padding(
                          padding: EdgeInsets.only(top: 100),
                          child: AppLoader(),
                        )
                      : Column(
                          children: [
                            _buildProfileCard(context, state),
                            const SizedBox(height: 20),
                            // _buildStatsSection(context, state),
                            // const SizedBox(height: 20),
                            _buildInfoSection(context, state),
                            const SizedBox(height: 20),
                            _buildSettingsSection(context),
                            const SizedBox(height: 20),
                            _buildLogoutButton(context),
                            const SizedBox(height: 100),
                          ],
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, RecruiterProfileState state) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : const Color(0xFF0F172A));
    final secondaryTextColor = Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: state.image.isNotEmpty
                  ? MemoryImage(base64Decode(state.image))
                  : null,
              child: state.image.isEmpty
                  ? const Icon(Icons.person, size: 50, color: Colors.grey)
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            state.name.isEmpty ? l10n.unknown : state.name,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              color: primaryTextColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            state.role.isEmpty ? 'N/A' : state.role,
            style: const TextStyle(
              color: Color(0xFF3B82F6),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          _buildContactTile(context, Icons.email_outlined, state.email, Colors.orange),
          const SizedBox(height: 12),
          _buildContactTile(context, Icons.phone_outlined, state.phone, Colors.blue),
          const SizedBox(height: 12),
          _buildContactTile(context, Icons.location_on_outlined, state.location, Colors.green),
        ],
      ),
    );
  }

  Widget _buildContactTile(BuildContext context, IconData icon, String text, Color color) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : const Color(0xFF0F172A));

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text.isEmpty ? l10n.not_specified : text,
            style: TextStyle(
              fontSize: 15,
              color: primaryTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context, RecruiterProfileState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  Icons.work_outline,
                  state.jobsPosted.toString(),
                  "Jobs Posted",
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  context,
                  Icons.people_outline,
                  state.totalApplicants.toString(),
                  "Applicants",
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  Icons.person_add_alt_1_outlined,
                  state.hired.toString(),
                  "Hired",
                  const Color(0xFF3B82F6),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  context,
                  Icons.remove_red_eye_outlined,
                  state.profileViews,
                  "Views",
                  Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, IconData icon, String count, String label, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : const Color(0xFF0F172A));
    final secondaryTextColor = Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, RecruiterProfileState state) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : const Color(0xFF0F172A));
    final dividerColor = Theme.of(context).dividerColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.information,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
              color: primaryTextColor,
            ),
          ),
          const SizedBox(height: 24),
          _infoRow(context, l10n.member_since, state.memberSince),
          Divider(height: 24, color: dividerColor),
          _infoRow(context, l10n.company, state.company),
          Divider(height: 24, color: dividerColor),
          _infoRow(context, l10n.designation, state.designation),
          Divider(height: 24, color: dividerColor),
          _infoRow(context, l10n.website, state.website),
        ],
      ),
    );
  }

  Widget _infoRow(BuildContext context, String title, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : const Color(0xFF0F172A));
    final secondaryTextColor = Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            color: secondaryTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value.isEmpty ? 'N/A' : value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: primaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final primaryTextColor = Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : const Color(0xFF0F172A));
    final secondaryTextColor = Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B));
    final dividerColor = Theme.of(context).dividerColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.settings,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
              color: primaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          Material(
            type: MaterialType.transparency,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.language_outlined, color: Colors.blue, size: 20),
              ),
              title: Text(
                l10n.language,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: primaryTextColor,
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded, color: secondaryTextColor, size: 16),
              onTap: () => Navigator.pushNamed(context, Routes.language),
            ),
          ),
          Divider(color: dividerColor, height: 24),
          Material(
            type: MaterialType.transparency,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.notifications_outlined, color: Colors.purple, size: 20),
              ),
              title: Text(
                l10n.notifications,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: primaryTextColor,
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded, color: secondaryTextColor, size: 16),
              onTap: () => Navigator.pushNamed(context, Routes.notifications),
            ),
          ),
          Divider(color: dividerColor, height: 24),
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              final activeIsDark = Theme.of(context).brightness == Brightness.dark;
              return Material(
                type: MaterialType.transparency,
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      activeIsDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                      color: Colors.orange,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    l10n.dark_mode,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: primaryTextColor,
                    ),
                  ),
                  value: activeIsDark,
                  activeColor: const Color(0xFF3B82F6),
                  onChanged: (value) => context.read<ThemeCubit>().toggleTheme(value),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
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
          icon: const Icon(Icons.logout, size: 22),
          label: Text(
            l10n.logout,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade400,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}
