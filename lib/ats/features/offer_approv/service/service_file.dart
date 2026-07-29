
import 'package:flutter_app/ats/features/offer_approv/model/model_class.dart';

class ApprovalService {

  Future<List<ApprovalStepModel>> fetchApprovals() async {

    await Future.delayed(const Duration(seconds: 1));

    return [

      ApprovalStepModel(
        id: 1,
        title: "Requested By",
        name: "Rekha Sharma (HR)",
        approvedDate: DateTime.now(),
        status: "pending",
      ),

      ApprovalStepModel(
        id: 2,
        title: "Approved By (1)",
        name: "Finance Manager",
        
        status: "waiting",
      ),

      ApprovalStepModel(
        id: 3,
        title: "Approved By (2)",
        name: "HR Manager",
        
        status: "waiting",
      ),

      ApprovalStepModel(
        id: 4,
        title: "Final Approval",
        name: "HR Director",
        
        status: "waiting",
      ),
    ];
  }
}
