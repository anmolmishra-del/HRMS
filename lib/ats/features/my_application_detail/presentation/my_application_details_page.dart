// application_details_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/features/my_application_detail/cubit/my_application_detail_cubit.dart';
import 'package:flutter_app/ats/features/my_application_detail/state/detail_state.dart';

import '../../my_applications/state/my_application_state.dart';


class ApplicationDetailsPage
    extends StatelessWidget {

  final ApplicationData application;

  const ApplicationDetailsPage({
    super.key,
    required this.application,
  });

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (_) =>
          ApplicationDetailsCubit(),

      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,

          title: const Text(
            "Application Details",

            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        body: BlocBuilder<
            ApplicationDetailsCubit,
            ApplicationDetailsState>(
          builder: (context, state) {

            final cubit =
                context.read<
                    ApplicationDetailsCubit>();

            return SingleChildScrollView(
              padding:
                  const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  // TOP CARD

                  Container(
                    padding:
                        const EdgeInsets.all(16),

                    decoration:
                        BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(
                              20),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey
                              .shade200,

                          blurRadius: 10,
                        ),
                      ],
                    ),

                    child: Column(
                      children: [

                        Row(
                          children: [

                            Container(
                              height: 70,
                              width: 70,

                              decoration:
                                  BoxDecoration(
                                color: Colors
                                    .deepPurple,

                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            18),
                              ),

                              child: const Icon(
                                Icons.work,
                                color:
                                    Colors.white,

                                size: 34,
                              ),
                            ),

                            const SizedBox(
                                width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                children: [

                                  Text(
                                    application
                                        .title,

                                    style:
                                        const TextStyle(
                                      fontSize: 24,

                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),

                                  const SizedBox(
                                      height: 6),

                                  Text(
                                    application
                                        .company,

                                    style:
                                        TextStyle(
                                      color: Colors
                                          .grey
                                          .shade700,

                                      fontSize: 16,
                                    ),
                                  ),

                                  const SizedBox(
                                      height: 14),

                                  Row(
                                    children: [

                                      const Icon(
                                        Icons
                                            .location_on,

                                        size: 18,
                                        color:
                                            Colors
                                                .grey,
                                      ),

                                      const SizedBox(
                                          width:
                                              4),

                                      Text(
                                    application
                                        .location
                                      ),

                                      const SizedBox(
                                          width:
                                              16),

                                      const Icon(
                                        Icons
                                            .work_outline,

                                        size: 18,
                                        color:
                                            Colors
                                                .grey,
                                      ),

                                      const SizedBox(
                                          width:
                                              4),

                                       Text(
                                        application.experience
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                            height: 20),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,

                          children: [

                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                 Text(
                                  application.status
                                ),

                                const SizedBox(
                                    height:
                                        6),

                                Container(
                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                    horizontal:
                                        12,

                                    vertical: 6,
                                  ),

                                  decoration:
                                      BoxDecoration(
                                    color: Colors
                                        .deepPurple
                                        .shade50,

                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                                30),
                                  ),

                                  child: Text(
                                    application
                                        .status,

                                    style:
                                        const TextStyle(
                                      color: Colors
                                          .deepPurple,

                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .end,

                              children: [

                                const Text(
                                  "Applied On",
                                ),

                                const SizedBox(
                                    height:
                                        6),

                                const Text(
                                  "20 Apr 2025",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // TABS

                  Row(
                    children: [

                      _buildTab(
                        title: "Timeline",
                        index: 0,
                        selected:
                            state.selectedTab,

                        onTap: () {
                          cubit.changeTab(0);
                        },
                      ),

                      const SizedBox(width: 12),

                      _buildTab(
                        title: "Interviews",
                        index: 1,
                        selected:
                            state.selectedTab,

                        onTap: () {
                          cubit.changeTab(1);
                        },
                      ),

                      const SizedBox(width: 12),

                      _buildTab(
                        title: "Notes",
                        index: 2,
                        selected:
                            state.selectedTab,

                        onTap: () {
                          cubit.changeTab(2);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // TAB BODY

                  if (state.selectedTab == 0)
                    _timelineSection(),

                  if (state.selectedTab == 1)
                    _interviewSection(
                        application),

                  if (state.selectedTab == 2)
                    _notesSection(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTab({
    required String title,
    required int index,
    required int selected,
    required VoidCallback onTap,
  }) {

    final isSelected =
        selected == index;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,

        child: Container(
          height: 45,

          decoration: BoxDecoration(
            color: isSelected
                ? Colors.deepPurple
                : Colors.grey.shade100,

            borderRadius:
                BorderRadius.circular(30),
          ),

          child: Center(
            child: Text(
              title,

              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Colors.black,

                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

 Widget _timelineSection() {

  return Container(
    padding: const EdgeInsets.all(20),

    decoration: BoxDecoration(
      color: Colors.white,

      borderRadius:
          BorderRadius.circular(24),

      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          blurRadius: 10,
        ),
      ],
    ),

    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        const Text(
          "Application Status",

          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 30),

        _timelineTile(
          title:
              "Application Submitted",

          subtitle:
              "20 Apr 2025, 10:30 AM",

          status: "Completed",

          completed: true,
          isActive: false,
        ),

        _timelineTile(
          title:
              "Application Under Review",

          subtitle:
              "21 Apr 2025, 02:15 PM",

          status: "Completed",

          completed: true,
          isActive: false,
        ),

        _timelineTile(
          title: "HR Screening",

          subtitle: "In Progress",

          status: "In Progress",

          completed: false,
          isActive: true,
        ),

        _timelineTile(
          title:
              "Technical Interview",

          subtitle: "Pending",

          status: "Pending",

          completed: false,
          isActive: false,
        ),

        _timelineTile(
          title: "Final Interview",

          subtitle: "Pending",

          status: "Pending",

          completed: false,
          isActive: false,
        ),

        _timelineTile(
          title: "Offer",

          subtitle: "Pending",

          status: "Pending",

          completed: false,
          isActive: false,

          isLast: true,
        ),
      ],
    ),
  );
}

Widget _timelineTile({
  required String title,
  required String subtitle,
  required String status,

  required bool completed,
  required bool isActive,

  bool isLast = false,
}) {

  return IntrinsicHeight(
    child: Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Column(
          children: [

            Container(
              height: 28,
              width: 28,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                border: Border.all(
                  color: isActive
                      ? Colors.deepPurple
                      : completed
                          ? Colors.green
                          : Colors.grey.shade400,

                  width: 3,
                ),

                color: isActive
                    ? Colors.deepPurple
                        .shade50
                    : completed
                        ? Colors.green
                        : Colors.white,
              ),

              child: Center(
                child: completed
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      )
                    : isActive
                        ? Container(
                            height: 10,
                            width: 10,

                            decoration:
                                const BoxDecoration(
                              shape:
                                  BoxShape.circle,

                              color: Colors
                                  .deepPurple,
                            ),
                          )
                        : null,
              ),
            ),

            if (!isLast)
              Expanded(
                child: Container(
                  width: 2,
                  margin:
                      const EdgeInsets.symmetric(
                    vertical: 4,
                  ),

                  color:
                      Colors.grey.shade300,
                ),
              ),
          ],
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(
              bottom: 28,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  subtitle,

                  style: TextStyle(
                    color:
                        Colors.grey.shade700,

                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),

        Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),

          decoration: BoxDecoration(

            color: status == "Completed"
                ? Colors.green.shade50
                : status == "In Progress"
                    ? Colors.deepPurple
                        .shade50
                    : Colors.grey.shade100,

            borderRadius:
                BorderRadius.circular(
                    30),
          ),

          child: Text(
            status,

            style: TextStyle(
              color: status == "Completed"
                  ? Colors.green
                  : status == "In Progress"
                      ? Colors.deepPurple
                      : Colors.grey,

              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
 

  Widget _interviewSection(
      ApplicationData application) {

    if (application.status !=
        "Interview Scheduled") {

      return Container(
        padding:
            const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(20),

          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
            ),
          ],
        ),

        child: const Center(
          child: Text(
            "No Interview Scheduled",
          ),
        ),
      );
    }

    return Container(
      padding:
          const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          const Text(
            "Interview Details",

            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          const ListTile(
            leading:
                Icon(Icons.calendar_month),

            title:
                Text("25 Apr 2025"),

            subtitle:
                Text("10:00 AM"),
          ),

          const ListTile(
            leading:
                Icon(Icons.video_call),

            title:
                Text("Google Meet"),

            subtitle:
                Text("Online Interview"),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,

            child: ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.deepPurple,

                padding:
                    const EdgeInsets
                        .symmetric(
                  vertical: 14,
                ),
              ),

              onPressed: () {},

              child: const Text(
                "Join Interview",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _notesSection() {

    return Container(
      padding:
          const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          const Text(
            "Recruiter Notes",

            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Container(
            padding:
                const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color:
                  Colors.deepPurple.shade50,

              borderRadius:
                  BorderRadius.circular(
                      16),
            ),

            child: const Text(
              "Your profile is shortlisted for the next round.",
            ),
          ),
        ],
      ),
    );
  }
}
