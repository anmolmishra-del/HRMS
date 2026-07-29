enum EditProfileStatus {
  initial,
  loading,
  success,
  error,
}

class EditProfileState {

  final String name;
  final String role;
  final String email;
  final String mobile;
  final String location;
  final String company;
  final String designation;
  final String website;

  final bool hasChanges;

  final EditProfileStatus status;
  final String message;

  const EditProfileState({

    this.name = '',
    this.role = '',
    this.email = '',
    this.mobile = '',
    this.location = '',
    this.company = '',
    this.designation = '',
    this.website = '',

    this.hasChanges = false,

    this.status =
        EditProfileStatus.initial,

    this.message = '',
  });

  EditProfileState copyWith({

    String? name,
    String? role,
    String? email,
    String? mobile,
    String? location,
    String? company,
    String? designation,
    String? website,

    bool? hasChanges,

    EditProfileStatus? status,
    String? message,
  }) {

    return EditProfileState(

      name: name ?? this.name,

      role: role ?? this.role,

      email: email ?? this.email,

      mobile: mobile ?? this.mobile,

      location:
          location ?? this.location,

      company:
          company ?? this.company,

      designation:
          designation ??
              this.designation,

      website:
          website ?? this.website,

      hasChanges:
          hasChanges ??
              this.hasChanges,

      status:
          status ?? this.status,

      message:
          message ?? this.message,
    );
  }
}
