import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/core/services/odoo_service.dart';
import 'package:flutter_app/ats/core/constants/api_config.dart';
import '../state/edit_profile_state.dart';

class EditProfileCubit
    extends Cubit<EditProfileState> {

  EditProfileCubit()
      : super(const EditProfileState());

  final service = OdooService(ApiConfig.baseUrl);

  void setInitialData({

    required String name,
    required String role,
    required String email,
    required String mobile,
    required String location,
    required String company,
    required String designation,
    required String website,

  }) {

    emit(

      state.copyWith(

        name: name,
        role: role,
        email: email,
        mobile: mobile,
        location: location,
        company: company,
        designation: designation,
        website: website,
      ),
    );
  }

  Future<void> saveProfile({

    required String name,
    required String role,
    required String email,
    required String mobile,
    required String location,
    required String company,
    required String designation,
    required String website,

  }) async {

    if (name.isEmpty ||
        email.isEmpty) {

      emit(
        state.copyWith(

          status:
              EditProfileStatus.error,

          message:
              "Please fill required fields",
        ),
      );

      return;
    }

    emit(
      state.copyWith(
        status:
            EditProfileStatus.loading,
      ),
    );

    try {

      /// UPDATE API
      await service.callKw({

        'model': 'res.users',

        'method': 'write',

        'args': [

          [OdooService.currentUserId], // USER ID

        {

  'name': name,

  'email': email,

  'mobile': mobile,

  'job_title':
      designation,

  'website':
      website,
}
        ],

        'kwargs': {},
      });

      emit(
        state.copyWith(

          name: name,
          role: role,
          email: email,
          mobile: mobile,
          location: location,
          company: company,
          designation: designation,
          website: website,

          status:
              EditProfileStatus.success,

          message:
              "Profile Updated Successfully",
        ),
      );

    } catch (e) {

      print(e);

      emit(
        state.copyWith(

          status:
              EditProfileStatus.error,

          message:
              "Profile Update Failed",
        ),
      );
    }
  }
}
