import 'package:flutter_app/ats/features/offer_approv/model/model_class.dart';

class ApprovalController {

  /// =========================
  /// APPROVE CURRENT STEP
  /// =========================
  List<ApprovalStepModel> approveCurrentStep(

    List<ApprovalStepModel> steps,

    String approvedBy,

  ) {

    List<ApprovalStepModel> updated = [];

    bool currentApproved = false;

    for (var step in steps) {

      /// APPROVE CURRENT PENDING STEP
      if (
      !currentApproved &&
          step.status == "pending"
      ) {

        updated.add(

          step.copyWith(

            status: "approved",

            approvedBy: approvedBy,

            approvedDate: DateTime.now(),
          ),
        );

        currentApproved = true;
      }

      /// ACTIVATE NEXT WAITING STEP
      else if (

      currentApproved &&
          step.status == "waiting"

      ) {

        updated.add(

          step.copyWith(
            status: "pending",
          ),
        );

        currentApproved = false;
      }

      else {

        updated.add(step);
      }
    }

    return updated;
  }

  /// =========================
  /// REJECT CURRENT STEP
  /// =========================
  List<ApprovalStepModel> rejectCurrentStep(

    List<ApprovalStepModel> steps,

    String rejectedBy,

    String reason,

  ) {

    return steps.map((step) {

      if (step.status == "pending") {

        return step.copyWith(

          status: "rejected",

          approvedBy: rejectedBy,

          approvedDate: DateTime.now(),

          rejectionReason: reason,
        );
      }

      return step;

    }).toList();
  }
}
