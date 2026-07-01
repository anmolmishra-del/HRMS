import 'package:flutter/material.dart';

import 'package:flutter_app/ats/features/auth/presentaion/login_page.dart';
import 'package:flutter_app/ats/features/edit_profile/presention/edit_profile_page.dart';
import 'package:flutter_app/ats/features/profile/state/profile_state.dart';
import 'package:flutter_app/ats/features/signup/presention/signup_page.dart';
import 'package:flutter_app/ats/features/bottomnavbar/recruiter/presention/recruiteer_main_layout.dart';
import 'package:flutter_app/ats/features/candidatefolder/candidate/presentaion/candidate_page.dart';
import 'package:flutter_app/ats/features/candidatefolder/candidate_screen/presentaion/candidate_page.dart';
import 'package:flutter_app/ats/features/candidatefolder/candidate_screen/presentaion/resume_page.dart';
import 'package:flutter_app/ats/features/onboard/onboard_page.dart';
import 'package:flutter_app/ats/features/splash_screen/splash_screen.dart';

class AppRoutes {
  static const String splashPage = '/splashPage';
  static const String onboard = '/onboard';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String mainlayout = '/mainlayout';
  static const String candidate = '/candidate';
  static const String candidatepage = '/candidatepage';
  static const String resume = '/resume';
  static const String recruitermainlayout = '/recruitermainlayout';
  static const String editprofile = '/editprofile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case splashPage:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
        );

      case onboard:
        return MaterialPageRoute(
          builder: (_) => const OnboardPage(),
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );

      case signup:
        return MaterialPageRoute(
          builder: (_) => const SignupPage(),
        );

    case AppRoutes.editprofile:

  final profileState =
      settings.arguments
          as RecruiterProfileState;

  return MaterialPageRoute(

    builder: (_) =>

        EditProfilePage(

          profileState:
              profileState,
        ),
  );

      case candidate:
        return MaterialPageRoute(
          builder: (_) => const CandidatePage(),
        );
        
      case candidatepage:
        return MaterialPageRoute(
          builder: (_) => const CandidateProfilePage(),
        );
        case resume:
        return MaterialPageRoute(
          builder: (_) => const ResumePage(),
        );
          case recruitermainlayout:
        return MaterialPageRoute(
          builder: (_) => const RecruiterMainLayout(),
        );
        

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text("Page Not Found"),
            ),
          ),
        );
    }
  }
}