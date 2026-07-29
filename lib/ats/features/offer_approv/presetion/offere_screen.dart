import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/ats/core/controllers.dart/controller.dart';
import 'package:flutter_app/ats/features/offer_approv/cubit/offer_cubit.dart';
import 'package:flutter_app/ats/features/offer_approv/model/model_class.dart';
import 'package:flutter_app/ats/features/offer_approv/service/service_file.dart';
import 'package:flutter_app/ats/features/offer_approv/state/offer_state.dart';


class OfferApprovalPage extends StatelessWidget {

  const OfferApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocProvider(

      create: (_) => ApprovalCubit(
        service: ApprovalService(),
        controller: ApprovalController(),
      )..loadApprovals(),

      child: Scaffold(

        backgroundColor: Colors.grey.shade100,

        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   elevation: 0,
        //   title: const Text(
        //     "Offer Approval",
        //     style: TextStyle(
        //       color: Colors.black,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),

        body: BlocBuilder<ApprovalCubit, ApprovalState>(

          builder: (context, state) {

            if (state.loading) {

              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Padding(

              padding: const EdgeInsets.all(18),

              child: Column(

                children: [

                  Expanded(

                    child: ListView.builder(
                    
                      itemCount: state.steps.length,
                    
                      itemBuilder: (context, index) {
                    
                        final step = state.steps[index];
                    
                        return ApprovalStepTile(
                          step: step,
                          isLast:
                          index == state.steps.length - 1,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(

                    children: [

                      Expanded(

                        child: ElevatedButton(

                          style: ElevatedButton.styleFrom(

                            backgroundColor: Colors.green,

                            padding:
                            const EdgeInsets.symmetric(
                              vertical: 16,
                            ),

                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(14),
                            ),
                          ),

                          onPressed: () {

                            context
                                .read<ApprovalCubit>()
                                .approve("Finance Manager");
                          },

                          child: const Text(
                            "Approve",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(

                        child: ElevatedButton(

                          style: ElevatedButton.styleFrom(

                            backgroundColor:
                            Colors.red.shade50,

                            padding:
                            const EdgeInsets.symmetric(
                              vertical: 16,
                            ),

                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(14),
                            ),
                          ),

                       onPressed: () {

  context
      .read<ApprovalCubit>()
      .reject(

        rejectedBy: "Finance Manager",

        reason: "Salary budget exceeded",
      );
},
                          child: const Text(
                            "Reject",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ApprovalStepTile extends StatelessWidget {

  final ApprovalStepModel step;
  final bool isLast;

  const ApprovalStepTile({
    super.key,
    required this.step,
    required this.isLast,
  });

  Color getColor() {

    switch (step.status) {

      case "approved":
        return Colors.green;

      case "pending":
        return Colors.orange;

      case "rejected":
        return Colors.red;

      default:
        return Colors.grey.shade400;
    }
  }

  IconData getIcon() {

    switch (step.status) {

      case "approved":
        return Icons.check;

      case "pending":
        return Icons.access_time;

      case "rejected":
        return Icons.close;

      default:
        return Icons.person_outline;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Row(

      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Column(

          children: [

            Container(

              height: 36,
              width: 36,

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: getColor().withOpacity(.15),
                border: Border.all(
                  color: getColor(),
                  width: 2,
                ),
              ),

              child: Icon(
                getIcon(),
                color: getColor(),
                size: 18,
              ),
            ),

            if (!isLast)

              Container(
                width: 2,
                height: 70,
                color: Colors.grey.shade300,
              ),
          ],
        ),

        const SizedBox(width: 16),

        Expanded(

          child: Padding(

            padding: const EdgeInsets.only(top: 4),

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  step.title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  step.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  step.status.toUpperCase(),
                  style: TextStyle(
                    color: getColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),

if(step.approvedDate != null)

Text(
  DateFormat(
    "dd MMM yyyy, hh:mm a",
  ).format(step.approvedDate!),
),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
