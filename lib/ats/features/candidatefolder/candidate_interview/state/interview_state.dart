import '../../../my_applications/state/my_application_state.dart';

class CandidateInterviewState {

  final String selectedTab;

  final List<ApplicationData> interviews;

  const CandidateInterviewState({

    required this.selectedTab,

    required this.interviews,
  });

  factory CandidateInterviewState.initial() {

    return const CandidateInterviewState(

      selectedTab: "Upcoming",

      interviews: [],
    );
  }

  CandidateInterviewState copyWith({

    String? selectedTab,

    List<ApplicationData>? interviews,

  }) {

    return CandidateInterviewState(

      selectedTab:
          selectedTab ??
              this.selectedTab,

      interviews:
          interviews ??
              this.interviews,
    );
  }
}
