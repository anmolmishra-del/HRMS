class RecruiterProfileState {
  final String name;
  final String role;
  final String email;
  final String phone;
  final String location;
  final String image;
  final int jobsPosted;
  final int totalApplicants;
  final int hired;
  final String profileViews;
  final String about;
  final String memberSince;
  final String company;
  final String designation;
  final String website;
  final bool isLoading;

  const RecruiterProfileState({
    required this.name,
    required this.role,
    required this.email,
    required this.phone,
    required this.location,
    required this.image,
    required this.jobsPosted,
    required this.totalApplicants,
    required this.hired,
    required this.profileViews,
    required this.about,
    required this.memberSince,
    required this.company,
    required this.designation,
    required this.website,
    required this.isLoading,
  });

  factory RecruiterProfileState.initial() {
    return const RecruiterProfileState(
      name: "",
      role: "",
      email: "",
      phone: "",
      location: "",
      jobsPosted: 0,
      totalApplicants: 0,
      hired: 0,
      profileViews: "",
      about: "",
      memberSince: "",
      company: "",
      designation: "",
      website: "",
      image: "",
      isLoading: true,
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
    String? image,
    bool? isLoading,
  }) {
    return RecruiterProfileState(
      name: name ?? this.name,
      role: role ?? this.role,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      image: image ?? this.image,
      jobsPosted: jobsPosted ?? this.jobsPosted,
      totalApplicants: totalApplicants ?? this.totalApplicants,
      hired: hired ?? this.hired,
      profileViews: profileViews ?? this.profileViews,
      about: about ?? this.about,
      memberSince: memberSince ?? this.memberSince,
      company: company ?? this.company,
      designation: designation ?? this.designation,
      website: website ?? this.website,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
