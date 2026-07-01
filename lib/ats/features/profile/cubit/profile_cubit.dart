import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/core/services/odoo_service.dart';
import 'package:flutter_app/ats/core/constants/api_config.dart';
import 'package:flutter_app/ats/features/profile/state/profile_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecruiterProfileCubit
    extends Cubit<RecruiterProfileState> {

  RecruiterProfileCubit()
      : super(
          RecruiterProfileState.initial(),
        ) {

    getProfile();
  }

  final service = OdooService(ApiConfig.baseUrl);
Future<void> getProfile() async {

  try {
 if (isClosed) return;
    /// LOADING START
    emit(
      state.copyWith(
        isLoading: true,
      ),
    );

    /// PROFILE
    final profile =
        await service.getProfile();

    /// DASHBOARD STATS
    final stats =
        await service
            .getDashboardStats();

    print(
      "STATS => $stats",
    );
 if (isClosed) return;
    if (profile.image != null && profile.image!.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('ats_profile_image', profile.image!);
    }

    /// FINAL STATE UPDATE
    emit(
      state.copyWith(

        // PROFILE
        name: profile.name,

        email: profile.email,

        phone: profile.mobile,

        role: profile.role,

        location:
            profile.location,

        memberSince:
            profile.memberSince,

        company:
            profile.company,

        designation:
            profile.job_title,
    image:
        profile.image ?? '',
        website:
            profile.website,

        // STATS
        jobsPosted:
            stats['jobsPosted'] ?? 0,

        totalApplicants:
            stats['applicants'] ?? 0,

        hired:
            stats['hired'] ?? 0,

        profileViews:
            stats['views']
                .toString(),

        // LOADING END
        isLoading: false,
      ),
    );

  } catch (e) {

    print(
      "PROFILE ERROR",
    );

    print(e);

    emit(
      state.copyWith(
        isLoading: false,
      ),
    );
  }
}
  // UPDATE PROFILE
  Future<void> updateProfile({

    required String name,
    required String role,
    required String email,
    required String phone,
    required String location,
 required String company,
  required String designation,
  required String website,
  }) async {

    try {
   emit(
      state.copyWith(
        isLoading: true,
      ),
    );

      // ODOO UPDATE
    
      // LOCAL STATE UPDATE
      emit(
        state.copyWith(

          name: name,

          role: role,

          email: email,

          phone: phone,

          location: location,
             isLoading: false,
        ),
      );

    } catch (e) {

      print(e);
    }
  }
}
