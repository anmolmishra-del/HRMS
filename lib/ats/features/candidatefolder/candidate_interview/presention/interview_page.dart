import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/features/candidatefolder/candidate_interview/cubit/interview_cubit.dart';
import 'package:flutter_app/ats/features/candidatefolder/candidate_interview/state/interview_state.dart';

import '../../../my_applications/cubit/my_application_cubit.dart';
import '../../../my_applications/state/my_application_state.dart';


class CandidateInterviewPage
    extends StatelessWidget {

  const CandidateInterviewPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return BlocProvider(

      create: (_) =>
          CandidateInterviewCubit(),

      child: BlocBuilder<
          CandidateInterviewCubit,
          CandidateInterviewState>(

        builder: (context, appState) {

          final applications =
              context
                  .watch<
                      MyApplicationCubit>()
                  .state
                  .applications;

          final interviews =
              applications.where(
            (e) =>
                e.interviewDate
                    .isNotEmpty,
          ).toList();

          final upcoming =
              interviews.where(
            (e) =>
                e.status !=
                "Completed",
          ).toList();

          final completed =
              interviews.where(
            (e) =>
                e.status ==
                "Completed",
          ).toList();

          final cancelled =
              interviews.where(
            (e) =>
                e.status ==
                "Cancelled",
          ).toList();

          return Scaffold(

            backgroundColor:
                const Color(
                    0xffF7F7FB),

            body: SafeArea(

              child:
                  SingleChildScrollView(

                padding:
                    const EdgeInsets
                        .all(20),

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [

                    /// HEADER
                    Row(

                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [

                        const Icon(
                          Icons.menu,
                          size: 32,
                        ),

                        Row(
                          children: [

                            Stack(
                              children: [

                                const Icon(
                                  Icons.notifications_none,
                                  size: 30,
                                ),

                                Positioned(
                                  right: 0,
                                  child:
                                      Container(

                                    padding:
                                        const EdgeInsets
                                            .all(
                                                5),

                                    decoration:
                                        const BoxDecoration(
                                      color:
                                          Colors
                                              .deepPurple,

                                      shape:
                                          BoxShape
                                              .circle,
                                    ),

                                    child:
                                        const Text(
                                      "3",

                                      style:
                                          TextStyle(
                                        color:
                                            Colors.white,

                                        fontSize:
                                            10,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                                width: 16),

                            const CircleAvatar(
                              radius: 24,
                              backgroundImage:
                                  NetworkImage(
                                "https://i.pravatar.cc/150",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(
                        height: 30),

                    const Text(
                      "Interviews",

                      style: TextStyle(
                        fontSize: 36,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                        height: 10),

                    const Text(
                      "Track your upcoming and past interviews",

                      style: TextStyle(
                        fontSize: 18,
                        color:
                            Colors.grey,
                      ),
                    ),

                    const SizedBox(
                        height: 30),

                    /// TABS
                    Container(

                      padding:
                          const EdgeInsets
                              .all(6),

                      decoration:
                          BoxDecoration(

                        color:
                            Colors.white,

                        borderRadius:
                            BorderRadius.circular(
                                20),
                      ),

                      child: Row(
                        children: [

                          Expanded(
                            child: _tab(
                              context,
                              title:
                                  "Upcoming (${upcoming.length})",

                              selected:
                                  appState.selectedTab ==
                                      "Upcoming",

                              onTap: () {

                                context
                                    .read<
                                        CandidateInterviewCubit>()
                                    .changeTab(
                                        "Upcoming");
                              },
                            ),
                          ),

                          Expanded(
                            child: _tab(
                              context,
                              title:
                                  "Completed (${completed.length})",

                              selected:
                                  appState.selectedTab ==
                                    "Completed",

                              onTap: () {

                                context
                                    .read<
                                        CandidateInterviewCubit>()
                                    .changeTab(
                                        "Completed");
                              },
                            ),
                          ),

                          Expanded(
                            child: _tab(
                              context,
                              title:
                                  "Cancelled (${cancelled.length})",

                              selected:
                                  appState.selectedTab ==
                                      "Cancelled",

                              onTap: () {

                                context
                                    .read<
                                        CandidateInterviewCubit>()
                                    .changeTab(
                                        "Cancelled");
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                        height: 30),

                    /// LIST
                    ..._getList(
                      appState.selectedTab,
                      upcoming,
                      completed,
                      cancelled,
                    ).map(
                      (e) =>
                          _interviewCard(
                        e,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static List<ApplicationData>
      _getList(

    String tab,

    List<ApplicationData>
        upcoming,

    List<ApplicationData>
        completed,

    List<ApplicationData>
        cancelled,

  ) {

    if (tab == "Completed") {
      return completed;
    }

    if (tab == "Cancelled") {
      return cancelled;
    }

    return upcoming;
  }

  static Widget _tab(

    BuildContext context, {

    required String title,

    required bool selected,

    required VoidCallback onTap,
  }) {

    return GestureDetector(

      onTap: onTap,

      child: Container(

        padding:
            const EdgeInsets.symmetric(
          vertical: 14,
        ),

        decoration: BoxDecoration(

          color: selected
              ? const Color(
                  0xffEEE9FF)
              : Colors.transparent,

          borderRadius:
              BorderRadius.circular(
                  16),
        ),

        child: Center(
          child: Text(

            title,

            style: TextStyle(

              color: selected
                  ? Colors.deepPurple
                  : Colors.grey,

              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  static Widget _interviewCard(
    ApplicationData e,
  ) {

    return Container(

      margin:
          const EdgeInsets.only(
        bottom: 20,
      ),

      padding:
          const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
                24),
      ),

      child: Row(
        children: [

          Container(

            height: 80,
            width: 80,

            decoration: BoxDecoration(

              color:
                  Colors.grey.shade100,

              borderRadius:
                  BorderRadius.circular(
                      20),
            ),

            child: const Icon(
              Icons.work,
              color: Colors.deepPurple,
              size: 40,
            ),
          ),

          const SizedBox(width: 20),

          Expanded(
            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [

                Text(
                  e.title,

                  style:
                      const TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  e.company,
                ),

                const SizedBox(height: 10),

                Container(

                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

                  decoration:
                      BoxDecoration(

                    color:
                        const Color(
                            0xffEEE9FF),

                    borderRadius:
                        BorderRadius.circular(
                            20),
                  ),

                  child: Text(
                    e.status,

                    style:
                        const TextStyle(
                      color:
                          Colors.deepPurple,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [

                    const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color:
                          Colors.grey,
                    ),

                    const SizedBox(width: 6),

                    Text(
                      e.interviewDate,
                    ),

                    const SizedBox(width: 16),

                    const Icon(
                      Icons.access_time,
                      size: 18,
                      color:
                          Colors.grey,
                    ),

                    const SizedBox(width: 6),

                    Text(
                      e.interviewTime,
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [

                    const Icon(
                      Icons.video_call,
                      size: 18,
                      color:
                          Colors.grey,
                    ),

                    const SizedBox(width: 6),

                    Expanded(
                      child: Text(
                        e.meetingLink,
                        overflow:
                            TextOverflow
                                .ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Column(
            children: [

              ElevatedButton(

                onPressed: () {},

                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      Colors
                          .deepPurple,
                ),

                child: const Text(
                  "Join Meeting",
                ),
              ),

              const SizedBox(
                  height: 12),

              OutlinedButton(

                onPressed: () {},

                child: const Text(
                  "View Details",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
