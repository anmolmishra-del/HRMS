class RecruiterProfileState {

  final String name;
  final String role;
  final String email;
  final String phone;
  final String location;

  final int jobsPosted;
  final int totalApplicants;
  final int hired;
  final String profileViews;

  final String about;

  final String memberSince;
  final String company;
  final String designation;
  final String website;

  const RecruiterProfileState({

    required this.name,
    required this.role,
    required this.email,
    required this.phone,
    required this.location,

    required this.jobsPosted,
    required this.totalApplicants,
    required this.hired,
    required this.profileViews,

    required this.about,

    required this.memberSince,
    required this.company,
    required this.designation,
    required this.website,
  });

  factory RecruiterProfileState.initial() {

    return const RecruiterProfileState(

      name: "Rohit Verma",

      role: "Recruiter",

      email: "rohit.verma@opsento.com",

      phone: "+91 98765 43210",

      location: "Bangalore, India",

      jobsPosted: 68,

      totalApplicants: 232,

      hired: 45,

      profileViews: "12.5K",

      about:
          "Experienced recruiter with a passion for connecting great talent with the right opportunities.",

      memberSince: "May 2023",

      company: "Opsento Solutions",

      designation: "Senior Recruiter",

      website: "www.opsento.com",
    );
  }

  RecruiterProfileState copyWith({

    String? name,
    String? role,
    String? email,
    String? phone,
    String? location,

    int? jobsPosted,
    int? totalApplicants,
    int? hired,
    String? profileViews,

    String? about,

    String? memberSince,
    String? company,
    String? designation,
    String? website,
  }) {

    return RecruiterProfileState(

      name: name ?? this.name,

      role: role ?? this.role,

      email: email ?? this.email,

      phone: phone ?? this.phone,

      location: location ?? this.location,

      jobsPosted:
          jobsPosted ?? this.jobsPosted,

      totalApplicants:
          totalApplicants ??
              this.totalApplicants,

      hired: hired ?? this.hired,

      profileViews:
          profileViews ??
              this.profileViews,

      about: about ?? this.about,

      memberSince:
          memberSince ??
              this.memberSince,

      company:
          company ?? this.company,

      designation:
          designation ??
              this.designation,

      website:
          website ?? this.website,
    );
  }
}
