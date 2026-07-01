import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/features/candidatefolder/candidate_home/cubit/home_cubit.dart';
import 'package:flutter_app/ats/features/candidatefolder/candidate_home/state/home_state.dart';
import 'package:flutter_app/ats/features/my_applications/cubit/my_application_cubit.dart';
import 'package:flutter_app/ats/features/my_applications/state/my_application_state.dart';

class CandidateHomePage extends StatelessWidget {

  const CandidateHomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocProvider(

      create: (_) =>
          CandidateHomeCubit(),

      child: BlocBuilder<
          CandidateHomeCubit,
          CandidateHomeState>(

        builder: (context, state) {
 final applications =
      context
          .watch<MyApplicationCubit>()
          .state
          .applications;

  final upcomingInterview =
      applications.firstWhere(

    (e) =>
        e.status ==
        "Interview Scheduled",

    orElse: () =>
        ApplicationData.empty(),
  );
          return Scaffold(

            backgroundColor:
                const Color(0xffF7F7FB),

            body: SafeArea(

              child: SingleChildScrollView(

                padding:
                    const EdgeInsets.all(20),

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    /// TOP BAR
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
                                  child: Container(

                                    padding:
                                        const EdgeInsets
                                            .all(5),

                                    decoration:
                                        const BoxDecoration(
                                      color:
                                          Colors.deepPurple,
                                      shape:
                                          BoxShape.circle,
                                    ),

                                    child: const Text(
                                      "3",

                                      style: TextStyle(
                                        color:
                                            Colors.white,

                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(width: 16),

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

                    const SizedBox(height: 30),

                    /// HELLO
                    Text(
                      'Hello Shankar',
                      // "Hello, ${state.userName} 👋",

                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Find your dream job and build your career",

                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),

                    // const SizedBox(height: 30),

                    /// SEARCH
                    Row(
                      children: [

                        // Expanded(
                        //   child: Container(

                        //     padding:
                        //         const EdgeInsets
                        //             .symmetric(
                        //       horizontal: 20,
                        //     ),

                        //     height: 60,

                        //     decoration:
                        //         BoxDecoration(

                        //       color: Colors.white,

                        //       borderRadius:
                        //           BorderRadius.circular(
                        //               20),
                        //     ),

                        //     child: const Row(
                        //       children: [

                        //         Icon(
                        //           Icons.search,
                        //           color: Colors.grey,
                        //         ),

                        //         SizedBox(width: 12),

                        //         Text(
                        //           "Search jobs, skills or companies...",

                        //           style: TextStyle(
                        //             color: Colors.grey,
                        //             fontSize: 16,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),

                        const SizedBox(width: 16),

                        const Icon(
                          Icons.tune,
                          color: Colors.white,
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// UPCOMING INTERVIEW
                    Container(

                      padding:
                          const EdgeInsets.all(20),

                      decoration:
                          BoxDecoration(

                        color:
                            const Color(0xffEEE9FF),

                        borderRadius:
                            BorderRadius.circular(
                                24),
                      ),

                      child: Row(
                        children: [

                          Container(

                            height: 80,
                            width: 80,

                            decoration:
                                const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),

                            child: const Icon(
                              Icons.calendar_month,
                              color:
                                  Colors.deepPurple,

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

                                const Text(
                                  "Upcoming Interview",

                                  style: TextStyle(
                                    color:
                                        Colors.deepPurple,

                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  upcomingInterview.title,

                                  style:
                                      const TextStyle(
                                    fontSize: 24,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Text(
                                upcomingInterview.company,
                                ),

                                const SizedBox(height: 10),

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
                                      upcomingInterview.interviewDate,
                                    ),

                                    const SizedBox(width: 20),

                                    const Icon(
                                      Icons.access_time,
                                      size: 18,
                                      color:
                                          Colors.grey,
                                    ),

                                    const SizedBox(width: 6),

                                    Text(
upcomingInterview.interviewTime                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// QUICK ACTIONS
                    const Row(

                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [

                        Text(
                          "Quick Actions",

                          style: TextStyle(
                            fontSize: 24,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        Text(
                          "View All",

                          style: TextStyle(
                            color:
                                Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [

                        Expanded(
                          child: _actionCard(
                            Icons.work_outline,
                            "Browse Jobs",
                            Colors.deepPurple,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _actionCard(
                            Icons.description,
                            "Applications",
                            Colors.green,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [

                        Expanded(
                          child: _actionCard(
                            Icons.calendar_today,
                            "Interviews",
                            Colors.orange,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _actionCard(
                            Icons.bookmark_border,
                            "Saved Jobs",
                            Colors.blue,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// RECOMMENDED JOBS
                    const Row(

                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [

                        Text(
                          "Recommended Jobs",

                          style: TextStyle(
                            fontSize: 24,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        Text(
                          "View All",

                          style: TextStyle(
                            color:
                                Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                   ...applications.map(
  (e) => _jobCard(e),
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

  static Widget _actionCard(
    IconData icon,
    String title,
    Color color,
  ) {

    return Container(

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(24),
      ),

      child: Column(
        children: [

          Icon(
            icon,
            size: 34,
            color: color,
          ),

          const SizedBox(height: 20),

          Text(
            title,

            textAlign: TextAlign.center,

            style: const TextStyle(
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _jobCard(ApplicationData job) {

    return Container(

      margin:
          const EdgeInsets.only(
        bottom: 16,
      ),

      padding:
          const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(24),
      ),

      child: Row(
        children: [

          Container(

            height: 70,
            width: 70,

            decoration: BoxDecoration(

              color:
                  Colors.grey.shade100,

              borderRadius:
                  BorderRadius.circular(
                      20),
            ),

            child: const Icon(
              Icons.flutter_dash,
              color: Colors.blue,
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
                  job.title,

                  style:
                      const TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  job.company,
                ),

                const SizedBox(height: 10),

                Row(
                  children: [

                    const Icon(
                      Icons.location_on,
                      size: 18,
                      color: Colors.grey,
                    ),

                    const SizedBox(width: 4),

                    Text(
                      job.location,
                    ),

                    const SizedBox(width: 16),

                    const Icon(
                      Icons.work_outline,
                      size: 18,
                      color: Colors.grey,
                    ),

                    const SizedBox(width: 4),

                    Text(
                      job.experience,
                    ),
                  ],
                ),
              ],
            ),
          ),

          Column(
            children: [

              Container(

                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),

                decoration:
                    BoxDecoration(

                  borderRadius:
                      BorderRadius.circular(
                          20),

                  border: Border.all(
                    color:
                        Colors.deepPurple,
                  ),
                ),

                child: Text(
                  job.type,

                  style: const TextStyle(
                    color:
                        Colors.deepPurple,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Icon(
                Icons.bookmark_border,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
