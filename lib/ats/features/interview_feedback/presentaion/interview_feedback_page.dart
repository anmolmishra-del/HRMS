import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/core/constants/app_colors.dart';
import 'package:flutter_app/ats/features/interview_feedback/cubit/interview_feedback_cubit.dart';
import 'package:flutter_app/ats/features/interview_feedback/state/interview_feedback_state.dart';
import 'package:flutter_app/ats/features/offer_approv/presetion/offere_screen.dart';
import 'package:flutter_app/ats/features/offer_later/presentaion/offer_later_page.dart';

class InterviewFeedbackPage extends StatelessWidget {
  const InterviewFeedbackPage({super.key});

  Widget star(int value, Function(int) onTap) {
    return Row(
      children: List.generate(5, (i) {
        return IconButton(
          onPressed: () => onTap(i + 1),
          icon: Icon(
            Icons.star,
            size: 35,
            color: i < value ? Colors.orange : Colors.grey,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InterviewFeedbackCubit(),
      child: BlocConsumer<InterviewFeedbackCubit, InterviewFeedbackState>(
        listener: (context, state) {
          if (state.success) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(content: Text("Feedback Submitted")),
            // );
          }
        },
        builder: (context, state) {
          final cubit = context.read<InterviewFeedbackCubit>();

          final tabs = ["Round 1", "Round 2", "Round 3"];

          return Scaffold(
            appBar: AppBar(title: const Text("Interview Feedback")),

            body: Column(
              children: [
                /// TABS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(3, (i) {
                    return GestureDetector(
                      onTap: () => cubit.changeTab(i),
                      child: Chip(
                        label: Text(tabs[i]),
                        backgroundColor: state.selectedTab == i
                            ? Colors.blue
                            : Colors.grey.shade300,
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: _buildRound(context, state, cubit, state.selectedTab),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRound(
    BuildContext context,
    InterviewFeedbackState state,
    InterviewFeedbackCubit cubit,
    int round,
  ) {
    final isRound1 = round == 0;
    final isRound2 = round == 1;
    final isRound3 = round == 2;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// ================= OVERALL =================
          // const Text("Overall Rating",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: AppColors.secondary),),
          // star(
          //   state.overallRating[round] ?? 0,
          //   (v) => cubit.setRating(round, "overall", v),
          // ),

          // const SizedBox(height: 10),

          // /// ================= GOOD / BAD =================
          // Row(
          //   children: [
          //     ChoiceChip(
          //       label: const Text("Good",style: TextStyle(),),
          //       selected: state.remarks[round] == "Good",
          //       onSelected: (_) => cubit.setRemark(round, "Good"),
          //     ),
          //     const SizedBox(width: 10),
          //     ChoiceChip(
          //       label: const Text("Bad"),
          //       selected: state.remarks[round] == "Bad",
          //       onSelected: (_) => cubit.setRemark(round, "Bad"),
          //     ),
          //   ],
          // ),

          const SizedBox(height: 20),

          /// ================= ROUND 1 =================
          if (isRound1) ...[
            const Text("Basic Technical Skills",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: AppColors.secondary),),
            star(
              state.technical[round] ?? 0,
              (v) => cubit.setRating(round, "tech", v),
            ),

            const SizedBox(height: 10),

            const Text("Communication",style: TextStyle(color: AppColors.secondary,fontWeight: FontWeight.w500,fontSize: 16),),
            star(
              state.communication[round] ?? 0,
              (v) => cubit.setRating(round, "communication", v),
            ),
            SizedBox(height:30,),
             const Text("Overall Rating",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: AppColors.secondary),),
          star(
            state.overallRating[round] ?? 0,
            (v) => cubit.setRating(round, "overall", v),
          ),

          const SizedBox(height: 30),

          /// ================= GOOD / BAD =================
          Row(
            children: [
              ChoiceChip(
                label: const Text("Good",style: TextStyle(),),
                selected: state.remarks[round] == "Good",
                onSelected: (_) => cubit.setRemark(round, "Good"),
              ),
              const SizedBox(width: 10),
              ChoiceChip(
                label: const Text("Bad"),
                selected: state.remarks[round] == "Bad",
                onSelected: (_) => cubit.setRemark(round, "Bad"),
              ),
            ],
          ),
          ],

          /// ================= ROUND 2 =================
          if (isRound2) ...[
            const Text("DSA Knowledge",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: AppColors.secondary),),
            star(
              state.technical[round] ?? 0,
              (v) => cubit.setRating(round, "tech", v),
            ),

            const SizedBox(height: 10),

            const Text("Framework Knowledge",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: AppColors.secondary),),
            star(
              state.communication[round] ?? 0,
              (v) => cubit.setRating(round, "communication", v),
            ),

            const SizedBox(height: 10),

            const Text("Problem Solving",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: AppColors.secondary)),
            star(
              state.problemSolving[round] ?? 0,
              (v) => cubit.setRating(round, "problem", v),
            ),

            const SizedBox(height: 10),

            const Text("System Thinking",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: AppColors.secondary)),
            star(
              state.problemSolving[round] ?? 0,
              (v) => cubit.setRating(round, "problem", v),
            ),
          ],

          /// ================= ROUND 3 =================
          if (isRound3) ...[
            const Text("Personality",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: AppColors.secondary)),
            star(
              state.communication[round] ?? 0,
              (v) => cubit.setRating(round, "communication", v),
            ),

            const SizedBox(height: 10),

            const Text("Culture Fit",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: AppColors.secondary)),
            star(
              state.technical[round] ?? 0,
              (v) => cubit.setRating(round, "tech", v),
            ),

            const SizedBox(height: 10),

            const Text("Leadership",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: AppColors.secondary)),
            star(
              state.problemSolving[round] ?? 0,
              (v) => cubit.setRating(round, "problem", v),
            ),
          ],

          const SizedBox(height: 20),

          /// ================= COMMENTS =================
          TextField(
            onChanged: (v) => cubit.setComment(round, v),
            maxLines: 5,
            minLines: 3,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              labelText: "Comments",
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          /// ================= SUBMIT =================
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: state.isSubmitting || !cubit.canSubmit(round,state)
                  ? null
                  : () async {
                      final success = await cubit.submit(round);
                      if (!success) return;

                      if (round < 2) {
                        cubit.changeTab(round + 1);
                        return;
                      }

                      final remark = cubit.state.remarks[round] ?? '';
                      if (remark == 'Bad') {
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const OfferLetterPage(),
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: state.isSubmitting
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text("Submit Round ${round + 1} Feedback"),
            ),
          )
        ],
      ),
    );
  }
}
