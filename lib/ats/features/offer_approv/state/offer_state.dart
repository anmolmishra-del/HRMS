
import 'package:flutter_app/ats/features/offer_approv/model/model_class.dart';

class ApprovalState {
  final List<ApprovalStepModel> steps;
  final bool loading;

  ApprovalState({
    required this.steps,
    this.loading = false,
  });

  ApprovalState copyWith({
    List<ApprovalStepModel>? steps,
    bool? loading,
  }) {
    return ApprovalState(
      steps: steps ?? this.steps,
      loading: loading ?? this.loading,
    );
  }
}
