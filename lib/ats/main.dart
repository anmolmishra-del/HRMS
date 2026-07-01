import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_app/ats/features/splash_screen/splash_screen.dart';

import 'package:flutter_app/ats/routes/app_routes.dart';

import 'package:flutter_app/ats/features/jobs/cubit/job_cubit.dart';

import 'package:flutter_app/ats/features/my_applications/cubit/my_application_cubit.dart';

import 'package:flutter_app/ats/features/interview_schedule/cubit/interview_cubit.dart';
import 'package:flutter_app/ats/features/auth/cubit/login_cubit.dart';
import 'package:flutter_app/ats/features/profile/cubit/profile_cubit.dart';

import 'package:flutter_app/ats/features/candidatefolder/candidate/cubit/candidate_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => JobCubit(),
        ),
        BlocProvider(
          create: (_) => MyApplicationCubit(),
        ),
        BlocProvider(
          create: (_) => InterviewScheduleCubit(),
        ),
        BlocProvider(
          create: (_) => RecruiterProfileCubit(),
        ),
        BlocProvider(
          create: (_) => AtsLoginCubit(),
        ),
        BlocProvider(
          create: (_) => CandidateCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashPage(),
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
