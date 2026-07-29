class ApplicationData {

  final String title;
  final String company;
     final String type;
  final String location;
  final String experience;
  final String salary;
final String candidateName;
  final String status;
  final bool isCompleted;
final int? currentStep;
 final String interviewDate;
  final String meetingLink;
  final String interviewTime;

  const ApplicationData({
    required this.title,
    required this.company,
required this.type,
    required this.location,
    required this.experience,
    required this.salary,
required this.candidateName,
    required this.status,
    required this.isCompleted,
    required this.currentStep,
        this.interviewDate = "",

    this.interviewTime = "",

    this.meetingLink = "",
  });
  factory ApplicationData.empty() {

  return const ApplicationData(

    title: "",

    company: "",

    type: "",

    location: "",

    experience: "",

    salary: "",

    status: "",

    isCompleted: false,

    currentStep: 0,

    interviewDate: "",

    interviewTime: "",

    meetingLink: "",
    candidateName: "",
  );
}

  ApplicationData copyWith({
    String? status,
    bool? isCompleted,
    int? currentStage,
String? candidateName,
    String? interviewDate,

    String? interviewTime,

    String? meetingLink,

  }) {

    return ApplicationData(
      title: title,
      company: company,
      type: type,
      location: location,
      experience: experience,
      salary: salary,

      status: status ?? this.status,
 candidateName:
          candidateName ??
              this.candidateName,
      isCompleted:
          isCompleted ?? this.isCompleted,

    currentStep:
        currentStep ?? this.currentStep,
           interviewDate:
          interviewDate ??
              this.interviewDate,

      interviewTime:
          interviewTime ??
              this.interviewTime,

      meetingLink:
          meetingLink ??
              this.meetingLink,
    );
  }
}

class MyApplicationState {

  final List<ApplicationData> applications;

  final bool showCompleted;

  const MyApplicationState({
    required this.applications,
    required this.showCompleted,
  });

  factory MyApplicationState.initial() {

    return const MyApplicationState(
      applications: [],

      showCompleted: false,
    );
  }

  MyApplicationState copyWith({
    List<ApplicationData>? applications,
    bool? showCompleted,
  }) {

    return MyApplicationState(
      applications:
          applications ?? this.applications,

      showCompleted:
          showCompleted ?? this.showCompleted,
    );
  }
}
