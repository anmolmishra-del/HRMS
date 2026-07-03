import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:flutter_app/splashscreen/splashscreen.dart';
import 'package:flutter_app/features/auth/login/cubit/login_cubit.dart';
import 'package:flutter_app/core/widget/network_wrapper.dart';
import 'package:flutter_app/core/widget/in_app_notification_wrapper.dart';
import 'package:flutter_app/core/localization/locale_cubit.dart';
import 'package:flutter_app/features/leave/cubit/leave_cubit.dart';
import 'package:flutter_app/features/notifications/cubit/notification_cubit.dart';
import 'package:flutter_app/features/profile/cubit/profile_cubit.dart';
import 'package:flutter_app/core/theme/theme_cubit.dart';
import 'package:flutter_app/core/theme/app_theme.dart';
import 'package:flutter_app/features/events/cubit/event_cubit.dart';
import 'package:flutter_app/features/profile/cubit/holiday_cubit.dart';
import 'package:flutter_app/features/chat/cubit/chat_cubit.dart';
import 'package:flutter_app/features/projects/cubit/projects_cubit.dart';
import 'package:flutter_app/features/projects/cubit/project_tasks_cubit.dart';
import 'package:flutter_app/features/document/cubit/document_cubit.dart';
import 'package:flutter_app/routes.dart';
import 'package:flutter_app/ats/features/jobs/cubit/job_cubit.dart';
import 'package:flutter_app/ats/features/my_applications/cubit/my_application_cubit.dart';
import 'package:flutter_app/ats/features/interview_schedule/cubit/interview_cubit.dart';
import 'package:flutter_app/ats/features/profile/cubit/profile_cubit.dart';
import 'package:flutter_app/ats/features/auth/cubit/login_cubit.dart';
import 'package:flutter_app/ats/features/candidatefolder/candidate/cubit/candidate_cubit.dart';

import 'package:flutter_app/core/services/firebase_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Background message: ${message.notification?.title}");
  await AppFirebaseService().showLocalNotification(message);
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // HttpOverrides.global = MyHttpOverrides();
  await AppFirebaseService().initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => LocaleCubit()),
        BlocProvider(create: (context) => LeaveCubit()),
        BlocProvider(create: (context) => NotificationCubit()..fetchNotifications()),
        BlocProvider(create: (context) => ProfileCubit()..fetchProfile()),
        BlocProvider(create: (context) => ThemeCubit()..loadTheme()),
        BlocProvider(create: (context) => EventCubit()..fetchEvents()),
        BlocProvider(create: (context) => HolidayCubit()..fetchHolidays()),
        BlocProvider(create: (context) => ChatCubit()),
        BlocProvider(create: (context) => ProjectsCubit()),
        BlocProvider(create: (context) => ProjectTasksCubit()),
        BlocProvider(create: (context) => DocumentCubit()..fetchDocuments()),
        BlocProvider(create: (context) => JobCubit()),
        BlocProvider(create: (context) => MyApplicationCubit()),
        BlocProvider(create: (context) => InterviewScheduleCubit()),
        BlocProvider(create: (context) => RecruiterProfileCubit()),
        BlocProvider(create: (context) => AtsLoginCubit()),
        BlocProvider(create: (context) => CandidateCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<LocaleCubit, String>(
            builder: (context, langCode) {
              return MaterialApp(
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                locale: Locale(langCode),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                onGenerateRoute: Routes.generateRoute,
                home: const SplashScreen(),
                builder: (context, child) {
                  return NetworkWrapper(
                    child: InAppNotificationWrapper(
                      child: child!,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
//   }
// }
