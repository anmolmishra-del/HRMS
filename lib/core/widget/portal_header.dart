import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/core/constants/app_colors.dart';
import 'package:flutter_app/core/utils/shared_pref.dart';
import 'package:flutter_app/core/widget/custome_search_bar.dart';
import 'package:flutter_app/features/profile/cubit/profile_cubit.dart';
import 'package:flutter_app/features/profile/cubit/profile_state.dart';
import 'package:flutter_app/features/notifications/cubit/notification_cubit.dart';
import 'package:flutter_app/routes.dart';

class PortalHeader extends StatefulWidget {
  final String activePortal; // 'hrms' or 'ats'
  final Function(String) onPortalChanged;
  final bool showSearchBar;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;

  const PortalHeader({
    super.key,
    required this.activePortal,
    required this.onPortalChanged,
    this.showSearchBar = true,
    this.searchController,
    this.onSearchChanged,
  });

  @override
  State<PortalHeader> createState() => _PortalHeaderState();
}

class _PortalHeaderState extends State<PortalHeader> {
  late Future<dynamic> _employeeDataFuture;

  @override
  void initState() {
    super.initState();
    _loadEmployeeData();
  }

  void _loadEmployeeData() {
    _employeeDataFuture = SharedPref().getObject('employee_data');
  }

  String _getGreeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "${l10n.good_morning} 🌅";
    } else if (hour < 17) {
      return "${l10n.good_afternoon} ☀️";
    } else {
      return "${l10n.good_evening} 🌙";
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.fromLTRB(
        20, 
        MediaQuery.of(context).padding.top + (MediaQuery.of(context).size.height < 780 ? 8 : 16), 
        20, 
        MediaQuery.of(context).size.height < 780 ? 12 : 24
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.indigo,
            AppColors.brightBlue,
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -40,
            right: -40,
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.white.withOpacity(0.05),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white.withOpacity(0.03),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Image.asset(
                          'assets/images/opsen.png',
                          height: 32,
                          width: 32,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 12),
                      FutureBuilder<dynamic>(
                        future: _employeeDataFuture,
                        builder: (context, snapshot) {
                          String name = "User";
                          if (snapshot.hasData && snapshot.data is Map) {
                            name = snapshot.data['name']?.toString().split(' ').first ?? "User";
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getGreeting(l10n),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withOpacity(0.8),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      BlocBuilder<ProfileCubit, ProfileState>(
                        builder: (context, state) {
                          if (!state.isAtsEnabled) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: _buildPortalDropdown(context),
                          );
                        },
                      ),
                      _buildNotificationIcon(context),
                      const SizedBox(width: 12),
                      _buildProfileMenu(context),
                    ],
                  ),
                ],
              ),
              // if (widget.showSearchBar) ...[
                SizedBox(height: MediaQuery.of(context).size.height < 780 ? 12 : 24),
                CustomSearchBar(
                  controller: widget.searchController,
                  onChanged: widget.onSearchChanged,
                  hintText: 'Search..',
                ),
              // ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPortalDropdown(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: widget.activePortal,
          dropdownColor: AppColors.indigo,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 18),
          selectedItemBuilder: (BuildContext context) {
            return [
              const Center(child: Text('HRMS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
              const Center(child: Text('ATS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
            ];
          },
          items: const [
            DropdownMenuItem(
              value: 'hrms',
              child: Text('HRMS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
            DropdownMenuItem(
              value: 'ats',
              child: Text('ATS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ],
          onChanged: (val) {
            if (val != null) {
              widget.onPortalChanged(val);
            }
          },
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, Routes.notifications),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 24),
              ),
            ),
            if (state.unreadCount > 0)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.dangerRed,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryPurple, width: 2),
                  ),
                  child: Text(
                    '${state.unreadCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildProfileMenu(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.personalinf);
      },
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final picData = state.employee?.image1920;
          if (picData != null && picData.length > 50 && picData != 'false') {
            try {
              String cleanedPicData = picData.trim().replaceAll('\n', '').replaceAll('\r', '').replaceAll(' ', '');
              if (cleanedPicData.contains(',')) {
                cleanedPicData = cleanedPicData.split(',').last;
              }
              final bytes = base64Decode(cleanedPicData);
              
              bool isValidImage = false;
              if (bytes.length >= 3) {
                if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
                  isValidImage = true;
                }
                else if (bytes.length >= 4 && bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47) {
                  isValidImage = true;
                }
              }

              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.lightPurple,
                  child: ClipOval(
                    child: isValidImage 
                      ? Image.memory(
                          bytes,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.person, size: 24, color: AppColors.primaryPurple),
                        )
                      : const Icon(Icons.person, size: 24, color: AppColors.primaryPurple),
                  ),
                ),
              );
            } catch (e) {
              return Container(
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                child: const CircleAvatar(radius: 20, backgroundColor: AppColors.lightPurple, child: Icon(Icons.person, color: AppColors.primaryPurple)),
              );
            }
          } else {
            return Container(
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
              child: const CircleAvatar(radius: 20, backgroundColor: AppColors.lightPurple, child: Icon(Icons.person, color: AppColors.primaryPurple)),
            );
          }
        },
      ),
    );
  }
}
