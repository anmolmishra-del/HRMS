class ProfileModel {

  final String name;
  final String role;
  final String email;
  final String mobile;
  final String location;
  final String? image;
  final int jobsPosted;
  final int totalApplicants;
  final int hired;
  final String profileViews;

  final String about;

  final String memberSince;
  final String company;
  final String job_title;
  final String website;

  const ProfileModel({

    required this.name,
    required this.role,
    required this.email,
    required this.mobile,
    required this.location,
    required this.image,
    required this.jobsPosted,
    required this.totalApplicants,
    required this.hired,
    required this.profileViews,

    required this.about,

    required this.memberSince,
    required this.company,
    required this.job_title,
    required this.website,
  });

  static String parseString(dynamic value) {

    if (value == null || value == false) {
      return '';
    }

    return value.toString();
  }

  static int parseInt(dynamic value) {

    if (value == null || value == false) {
      return 0;
    }

    return int.tryParse(value.toString()) ?? 0;
  }

  factory ProfileModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return ProfileModel(

      name:
          parseString(json['name']),

      role:
          parseString(json['job_title']),

      email:
          parseString(
            json['email'] ??
            json['login'],
          ),

      mobile:
          parseString(json['mobile']),

      location:
          parseString(json['location']),

   image:
          parseString(
        json['image_1920'],
      ),
// image:
//     json['image_1920'] == false
//         ? ''
//         : json['image_1920']
//             ?.toString(),

      jobsPosted:
          parseInt(json['jobs_posted']),

      totalApplicants:
          parseInt(json['total_applicants']),

      hired:
          parseInt(json['hired']),

      profileViews:
          parseString(json['profile_views']),

      about:
          parseString(json['about']),

      memberSince:
          parseString(json['create_date']),

      company:
          json['company_id'] is List &&
                  json['company_id'].length > 1
              ? parseString(json['company_id'][1])
              : '',

      job_title:
          parseString(json['job_title']),

      website:
          parseString(json['website']),
    );
  }

  Map<String, dynamic> toJson() {

    return {

      'name': name,

      'role': role,

      'email': email,

      'mobile': mobile,

      'location': location,
  'image_1920': image,
      'jobs_posted': jobsPosted,

      'total_applicants':
          totalApplicants,

      'hired': hired,

      'profile_views':
          profileViews,

      'about': about,

      'create_date':
          memberSince,

      'company': company,

      'job_title':
          job_title,

      'website': website,
    };
  }
}
