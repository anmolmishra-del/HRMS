import 'package:flutter/material.dart';
import 'package:flutter_app/ats/features/my_applications/state/my_application_state.dart';

class ApplicationCard
    extends StatelessWidget {

  final ApplicationData application;
  final VoidCallback? onInterview;
  final VoidCallback onComplete;

  const ApplicationCard({
    super.key,
    required this.application,
    required this.onInterview,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
          ),
        ],
      ),

      child: Row(
        children: [

          Container(
            height: 54,
            width: 54,

            decoration: BoxDecoration(
              color:
                  Colors.deepPurple.shade50,

              borderRadius:
                  BorderRadius.circular(14),
            ),

            child: const Icon(
              Icons.description,
              color: Colors.deepPurple,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  application.title,

                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  application.company,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 10),

               

                const SizedBox(height: 12),
Container(
  padding: const EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 6,
  ),

  decoration: BoxDecoration(
    color: _statusColor(
      application.status,
    ),

    borderRadius:
        BorderRadius.circular(8),
  ),

  child: Text(
    application.status,

   style: TextStyle(
  color: _textColor(
    application.status,
  ),

  fontWeight: FontWeight.w600,

  fontSize: 12,
),
  ),
),
              ],
            ),
          ),

          // const Icon(
          //   Icons.arrow_forward_ios,
          //   size: 18,
          // ),
        ],
      ),
    );
  }

 Color _statusColor(String status) {

  switch (status) {

    case "Interview Scheduled":
      return Colors.blue.shade100;

    case "Under Review":
      return Colors.orange.shade100;

    case "Applied":
      return Colors.grey.shade300;

    case "Completed":
      return Colors.green.shade100;

    case "Selected":
      return Colors.green.shade100;

    case "Rejected":
      return Colors.red.shade100;

    default:
      return Colors.deepPurple.shade100;
  }
}

}
Color _textColor(String status) {

  switch (status) {

    case "Interview Scheduled":
      return Colors.blue;

    case "Under Review":
      return Colors.orange;

    case "Applied":
      return Colors.black87;

    case "Completed":
      return Colors.green;

    case "Selected":
      return Colors.green;

    case "Rejected":
      return Colors.red;

    default:
      return Colors.deepPurple;
  }
}
