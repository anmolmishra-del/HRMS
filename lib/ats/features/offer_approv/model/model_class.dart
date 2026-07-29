class ApprovalStepModel {

  final int id;

  final String title;

  final String name;

  final String status;

  final DateTime? approvedDate;

  final String? approvedBy;

  final String? rejectionReason;

  ApprovalStepModel({

    required this.id,

    required this.title,

    required this.name,

    required this.status,

    this.approvedDate,

    this.approvedBy,

    this.rejectionReason,
  });

  ApprovalStepModel copyWith({

    String? status,

    DateTime? approvedDate,

    String? approvedBy,

    String? rejectionReason,

  }) {

    return ApprovalStepModel(

      id: id,

      title: title,

      name: name,

      status: status ?? this.status,

      approvedDate:
      approvedDate ?? this.approvedDate,

      approvedBy:
      approvedBy ?? this.approvedBy,

      rejectionReason:
      rejectionReason ?? this.rejectionReason,
    );
  }
}
