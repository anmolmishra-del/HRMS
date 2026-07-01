import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/features/my_application_detail/presentation/my_application_details_page.dart';
import 'package:flutter_app/ats/features/my_applications/presentaion/my_application_widget.dart';
import 'package:flutter_app/ats/features/my_applications/state/my_application_state.dart';

import '../cubit/my_application_cubit.dart';

class MyApplicationPage
    extends StatelessWidget {

  const MyApplicationPage({super.key});

  @override
  Widget build(BuildContext context) {
return Scaffold(
  backgroundColor: Colors.white,

  body: SafeArea(
    child: Padding(
      padding:
          const EdgeInsets.all(16),

      child: BlocBuilder<
          MyApplicationCubit,
          MyApplicationState>(
        builder: (context, state) {

          final cubit =
              context.read<
                  MyApplicationCubit>();

          final filtered =
              state.applications
                  .where(
            (e) =>
                e.isCompleted ==
                state.showCompleted,
          ).toList();

          return Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              const SizedBox(height: 10),

              const Text(
                "My Applications",

                style: TextStyle(
                  fontSize: 32,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              // TABS
              Row(
                children: [

                  Expanded(
                    child: GestureDetector(
                      onTap:
                          cubit.showActive,

                      child: Container(
                        height: 50,

                        decoration:
                            BoxDecoration(
                          color: !state
                                  .showCompleted
                              ? Colors
                                  .deepPurple
                              : Colors
                                  .grey
                                  .shade100,

                          borderRadius:
                              BorderRadius
                                  .circular(
                                      30),
                        ),

                        child: Center(
                          child: Text(
                            "Active",

                            style:
                                TextStyle(
                              color: !state
                                      .showCompleted
                                  ? Colors
                                      .white
                                  : Colors
                                      .black,

                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: GestureDetector(
                      onTap:
                          cubit.showCompleted,

                      child: Container(
                        height: 50,

                        decoration:
                            BoxDecoration(
                          color: state
                                  .showCompleted
                              ? Colors
                                  .deepPurple
                              : Colors
                                  .grey
                                  .shade100,

                          borderRadius:
                              BorderRadius
                                  .circular(
                                      30),
                        ),

                        child: Center(
                          child: Text(
                            "Completed",

                            style:
                                TextStyle(
                              color: state
                                      .showCompleted
                                  ? Colors
                                      .white
                                  : Colors
                                      .black,

                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Expanded(
                child: ListView.builder(
                  itemCount:
                      filtered.length,

                  itemBuilder:
                      (context, index) {

                    final app =
                        filtered[index];

                    return GestureDetector(
                      onTap: () {
                         Navigator.push(
      context,

      MaterialPageRoute(
        builder: (_) =>
            ApplicationDetailsPage(
          application: app,
        ),
      ),
    );
                      },
                      child: ApplicationCard(
                        application: app,
                      onInterview: null,
          //               onInterview: () {
          //              final originalIndex =
          // state.applications
          //     .indexOf(app);
          //                 cubit
          //                     .scheduleInterview(
          //                         originalIndex);
          //               },
                      
                        onComplete: () {
                         final originalIndex =
          state.applications
              .indexOf(app);
                          cubit
                              .completeApplication(
                                  originalIndex);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    ),
  ),
);
  }
}
