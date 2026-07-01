import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/features/onboard_check/cubit/onboard_checklist_cubit.dart';
import 'package:flutter_app/ats/features/onboard_check/model/model_class.dart';
import 'package:flutter_app/ats/features/onboard_check/state/onboard_checklist_state.dart';



class OnboardingChecklistPage
    extends StatelessWidget {

  const OnboardingChecklistPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (_) => OnboardingCubit(),

      child: Scaffold(
        backgroundColor:
            const Color(0xFFF8F9FD),

        appBar: AppBar(
          automaticallyImplyLeading: false,

          centerTitle: true,

          elevation: 0,

          backgroundColor: Colors.white,

          title: const Text(
            "Onboarding Checklist",

            style: TextStyle(
              color: Colors.black,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.all(24),

          child: BlocBuilder<
              OnboardingCubit,
              OnboardingState>(

            builder: (context, state) {

              if (state
                  is OnboardingLoaded) {

                final cubit =
                    context.read<
                        OnboardingCubit>();

                return Column(
                  children: [

                    const SizedBox(height: 20),

                    AnimatedContainer(
                      duration:
                          const Duration(
                        milliseconds: 600,
                      ),

                      width: 150,
                      height: 150,

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius:
                            BorderRadius.circular(
                          30,
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.05),

                            blurRadius: 20,
                          ),
                        ],
                      ),

                      child: const Icon(
                        Icons.assignment_turned_in,

                        color: Color(
                          0xFF5B3FFF,
                        ),

                        size: 90,
                      ),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      "All Set!",

                      style: TextStyle(
                        fontSize: 34,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "You have completed all\nthe onboarding steps.",

                      textAlign:
                          TextAlign.center,

                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 30),

                    Expanded(
                      child: ListView.builder(
                        itemCount:
                            state.items.length,

                        itemBuilder:
                            (context, index) {

                          return ChecklistTile(
                            model:
                                state.items[index],
                          );
                        },
                      ),
                    ),

                    SizedBox(
                      width: double.infinity,
                      height: 58,

                      child: ElevatedButton(
                        onPressed: () {

                          if (cubit
                              .isAllCompleted()) {

                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(

                              const SnackBar(
                                content: Text(
                                  "Welcome to Dashboard",
                                ),
                              ),
                            );
                          }
                        },

                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(
                            0xFF5B3FFF,
                          ),

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              18,
                            ),
                          ),
                        ),

                        child: const Text(
                          "Go to Dashboard",

                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,

                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}


class ChecklistTile
    extends StatelessWidget {

  final ChecklistModel model;

  const ChecklistTile({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(
        bottom: 14,
      ),

      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(14),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Row(
        children: [

          Icon(
            model.isCompleted
                ? Icons.check_circle
                : Icons.radio_button_unchecked,

            color: model.isCompleted
                ? Colors.green
                : Colors.grey,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              model.title,

              style: TextStyle(
                fontSize: 16,

                fontWeight:
                    FontWeight.w600,

                color: model.isCompleted
                    ? Colors.black
                    : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
