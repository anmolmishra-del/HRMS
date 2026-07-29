import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/features/home/presentation/birthdaypopup.dart';
import 'package:flutter_app/features/notifications/cubit/notification_cubit.dart';
import 'package:flutter_app/features/projects/cubit/projects_cubit.dart';
import 'package:flutter_app/features/leave/cubit/leave_cubit.dart';
import 'package:flutter_app/features/events/cubit/event_cubit.dart';
import 'package:flutter_app/features/profile/cubit/holiday_cubit.dart';
import 'package:flutter_app/routes.dart';
import 'package:flutter_app/core/utils/shared_pref.dart';
import 'package:flutter_app/core/constants/app_colors.dart';
import 'package:flutter_app/core/widget/portal_header.dart';
import 'package:flutter_app/features/home/widgets/action_card.dart';
import 'package:flutter_app/features/home/widgets/upcoming_events.dart';
import 'package:flutter_app/features/home/widgets/upcoming_holidays.dart';
import 'package:flutter_app/features/attendance/presentation/check_in_out.dart';
import 'package:flutter_app/features/attendance/cubit/attendance_cubit.dart';
import 'package:flutter_app/features/chat/cubit/chat_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:flutter_app/features/profile/cubit/profile_cubit.dart';
import 'package:flutter_app/features/profile/cubit/profile_state.dart';
import 'package:flutter_app/features/home/widgets/ats_launcher_card.dart';
import 'package:flutter_app/ats/features/bottomnavbar/recruiter/presention/recruiteer_main_layout.dart';
import 'package:flutter_app/features/home/widgets/weekly_working_hours_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  static bool _hasShownGreeting = false;
  late AttendanceCubit _attendanceCubit;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  late Future<dynamic> _employeeDataFuture;
  late Future<String?> _profilePicFuture;

  @override
  void initState() {
    super.initState();
    _attendanceCubit = AttendanceCubit()..loadInitialStatus();
    _employeeDataFuture = SharedPref().getObject('employee_data');
    _profilePicFuture = SharedPref().getString('profile_pic');
    WidgetsBinding.instance.addObserver(this);
    
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
    
    // CRITICAL: Initialize background data immediately at app launch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ChatCubit>().initChat();
        context.read<NotificationCubit>().fetchNotifications();
        context.read<ProjectsCubit>().fetchProjects();
        context.read<LeaveCubit>().fetchLeavesAndTypes();
        context.read<EventCubit>().fetchEvents();
        context.read<HolidayCubit>().fetchHolidays();
        _showBirthdayGreeting();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _attendanceCubit.close();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Refresh attendance status when app is resumed from background
    if (state == AppLifecycleState.resumed) {
      debugPrint('HomePage: App resumed, refreshing attendance status...');
      _attendanceCubit.loadInitialStatus();
    }
  }

  void _showBirthdayGreeting() async {
    if (_hasShownGreeting) return;
    _hasShownGreeting = true;
    
    // Wait for the widgets to render and a brief delay
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    
    final employeeData = await _employeeDataFuture;
    String currentUserName = "User";
    DateTime? currentUserBirthdate;
    
    if (employeeData is Map) {
      currentUserName = employeeData['name']?.toString().split(' ').first ?? "User";
      if (employeeData['birthday'] != null) {
        currentUserBirthdate = DateTime.tryParse(employeeData['birthday'].toString());
      }
    }
    
   if (currentUserBirthdate == null) return;
    final today = DateTime.now(); 
    final isUserBirthday = currentUserBirthdate.day == today.day && currentUserBirthdate.month == today.month;

// final isUserBirthday=true;
    // TEMPORARY FOR TESTING: Forced to true so you can verify the birthday popup works immediately.
    
    if (!isUserBirthday) {
      // Not the user's birthday, do not show any popup!
      return;
    }
    
    if (!mounted) return;
    
    // Show Birthday Dialog
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        // Beautiful birthday gradient (Festive gold / coral / purple)
        final gradientColors = [
          const Color(0xFFFF416C),
          const Color(0xFFFF4B2B),
        ];
        
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: gradientColors.first.withOpacity(0.4),
                      blurRadius: 32,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Celebration Icon / Party Popper
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        "🎉",
                        style: TextStyle(fontSize: 48),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    const Text(
                      "Happy Birthday!",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentUserName,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Wishing you a wonderful day filled with joy, laughter, and everything you hope for! Have a fantastic birthday! 🎂✨",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withOpacity(0.95),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: gradientColors.first,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              "Thank You!",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: const ConfettiAnimationWidget(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
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

  Future<void> _handleRefresh() async {
    debugPrint('HomePage: Manual refresh triggered');
    await Future.wait([
      _attendanceCubit.loadInitialStatus(),
      context.read<ProfileCubit>().fetchProfile(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<Map<String, dynamic>> features = [
      
      {'title': l10n.my_pay, 'route': Routes.myPay, 'icon': Icons.payment},
      {'title': l10n.leaves, 'route': Routes.leaveList, 'icon': Icons.event_note},
      {'title': l10n.personal_information, 'route': Routes.personalinf, 'icon': Icons.person},
      {'title': l10n.attendance_report, 'route': Routes.inOutReport, 'icon': Icons.access_time},
      {'title': l10n.company_calendar, 'route': Routes.holidayCalendar, 'icon': Icons.event},
      {'title': l10n.ai_chat_bot, 'route': Routes.aichatbot, 'icon': Icons.chat},
      {'title': l10n.doc_box, 'route': Routes.docbox, 'icon': Icons.folder},
      {'title': l10n.job_details, 'route': Routes.jobdetails, 'icon': Icons.work},
      {'title': l10n.notifications, 'route': Routes.notifications, 'icon': Icons.notifications},
      {'title': l10n.events_list, 'route': Routes.events, 'icon': Icons.event_available},
      {'title': l10n.projects, 'route': Routes.projects, 'icon': Icons.assignment},
    ];
    
    final searchResults = _searchQuery.isEmpty 
        ? [] 
        : features.where((f) => f['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    return BlocProvider.value(
      value: _attendanceCubit,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          top: false,
          bottom: false,
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            color: AppColors.brightBlue, // Matching the header color
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  pinned: true,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  toolbarHeight: MediaQuery.of(context).size.height < 780 ? 145 : 170, // Fixed height for header content
                  flexibleSpace: PortalHeader(
                    activePortal: 'hrms',
                    onPortalChanged: (val) async {
                      if (val == 'ats') {
                        await SharedPref().saveString('selected_portal', 'ats');
                        _openAtsPortal(context);
                      }
                    },
                    searchController: _searchController,
                    onSearchChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                  ),
                ),
                _searchQuery.isEmpty ? SliverPadding(
                  padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height < 780 ? 12 : 10, 20, 20), // Extra bottom padding for floating nav bar
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const CheckInOutCard(),
                       const SizedBox(height: 10),

                      const WeeklyWorkingHoursCard(),
                      // const SizedBox(height: 10),
                      Text(
                        l10n.quick_actions,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      // const SizedBox(height: 12),
                      const AttendanceActions(),
                       const SizedBox(height: 10),
                      // const UpcomingHolidaysSection(),
                      // const SizedBox(height: 24),
                      // const UpcomingEventsSection(),
                    ]),
                  ),
                ) : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final feature = searchResults[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 2,
                          shadowColor: Colors.black12,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.brightBlue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(feature['icon'] as IconData, color: AppColors.brightBlue),
                            ),
                            title: Text(feature['title'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                            onTap: () {
                              _searchController.clear();
                              FocusScope.of(context).unfocus();
                              Navigator.pushNamed(context, feature['route'] as String);
                            },
                          ),
                        );
                      },
                      childCount: searchResults.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openAtsPortal(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 650),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const RecruiterMainLayout();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );

          return FadeTransition(
            opacity: curvedAnimation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.08),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.96, end: 1.0).animate(curvedAnimation),
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPortalDropdown(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: 'hrms',
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
            if (val == 'ats') {
              _openAtsPortal(context);
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
                  color: Colors.white.withValues(alpha: 0.2),
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
              
              // Validate image magic bytes to prevent Android ImageDecoder console spam
              bool isValidImage = false;
              if (bytes.length >= 3) {
                // Check for JPEG (FF D8 FF)
                if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
                  isValidImage = true;
                }
                // Check for PNG (89 50 4E 47)
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
