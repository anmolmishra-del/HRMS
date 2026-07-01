import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/features/pre_onboarding/cubit/pre_onboard_cubit.dart';
import 'package:flutter_app/ats/features/pre_onboarding/state/pre_onboard_state.dart';

class PreOnboardingPage extends StatelessWidget {
  const PreOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PreOnboardingCubit(),
      child: const _PreOnboardingView(),
    );
  }
}
class _PreOnboardingView extends StatelessWidget {
  const _PreOnboardingView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),

      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      //   leading: IconButton(
      //     onPressed: () {},
      //     icon: const Icon(
      //       Icons.arrow_back,
      //       color: Colors.black,
      //     ),
      //   ),
      //   title: const Text(
      //     'Pre-Onboarding',
      //     style: TextStyle(
      //       color: Colors.black,
      //       fontWeight: FontWeight.w600,
      //     ),
      //   ),
      // ),
            body: BlocBuilder<PreOnboardingCubit, PreOnboardingState>(
        builder: (context, state) {
          if (state?.isLoading == true) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              margin: EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome, Arjun! 👋',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Complete the following steps before your joining date.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    '${state.completedCount} / ${state.tasks.length} Completed',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                   const SizedBox(height: 12),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: state.progress,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation(
                        Color(0xff5B4CF0),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  ListView.builder(
                    itemCount: state.tasks.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final task = state.tasks[index];

                      return OnboardingTaskTile(
                        title: task.title,
                        isCompleted: task.isCompleted,
                        onTap: () {
                          context
                              .read<PreOnboardingCubit>()
                              .toggleTask(index);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class OnboardingTaskTile extends StatelessWidget {
  final String title;
  final bool isCompleted;
  final VoidCallback onTap;

  const OnboardingTaskTile({
    super.key,
    required this.title,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isCompleted
                      ? Colors.green
                      : Colors.grey.shade400,
                  width: 1.5,
                ),
              ),
              child: isCompleted
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.green,
                    )
                  : null,
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? Colors.green
                    : Colors.grey.shade300,
              ),
              child: Icon(
                Icons.done,
                size: 14,
                color: isCompleted
                    ? Colors.white
                    : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
