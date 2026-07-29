import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/core/constants/app_colors.dart';
import 'package:flutter_app/ats/features/interview_schedule/cubit/interview_cubit.dart';
import 'package:flutter_app/ats/features/interview_schedule/state/interview_state.dart';

class InterviewSchedulePage extends StatelessWidget {
  const InterviewSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InterviewScheduleCubit, InterviewScheduleState>(
      listener: (context, state) {
        if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Interview Scheduled Successfully")),
          );
        }
    
        if (state.isError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? "Error")),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<InterviewScheduleCubit>();
    
        return Scaffold(
          appBar: AppBar(
            title: const Text("Schedule Interview"),
            leading: const BackButton(),
          ),
    
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
    
                /// Candidate
                const Text("Candidate"),
                const SizedBox(height: 8),
                TextField(
                  controller: cubit.candidateController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
    
                const SizedBox(height: 16),
                const Text("Candidate Email"),

const SizedBox(height: 8),

TextField(

  controller: cubit.emailController,

  keyboardType: TextInputType.emailAddress,

  decoration: const InputDecoration(

    hintText: "arjun.mehta@gmail.com",

    border: OutlineInputBorder(),

    prefixIcon: Icon(Icons.email_outlined),
  ),
),
    
                /// Interview Type (SAFE VALUE)
                const Text("Interview Type"),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: ["Technical Round", "HR Round"]
                          .contains(state.interviewType)
                      ? state.interviewType
                      : "Technical Round",
    
                  items: const [
                    DropdownMenuItem(
                      value: "Technical Round",
                      child: Text("Technical Round"),
                    ),
                    DropdownMenuItem(
                      value: "HR Round",
                      child: Text("HR Round"),
                    ),
                  ],
                  onChanged: (val) {
                    cubit.updateInterviewType(val ?? "Technical Round");
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
    
                const SizedBox(height: 16),
    
                /// Date + Time
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        controller: cubit.dateController,
                        decoration: const InputDecoration(
                          labelText: "Date",
                          border: OutlineInputBorder(),
                        ),
                        onTap: () => cubit.pickDate(context),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        controller: cubit.timeController,
                        decoration: const InputDecoration(
                          labelText: "Time",
                          border: OutlineInputBorder(),
                        ),
                        onTap: () => cubit.pickTime(context),
                      ),
                    ),
                  ],
                ),
    
                const SizedBox(height: 20),
    
                /// Meeting Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Meeting Link"),
                    Switch(
                      value: state.meetingEnabled,
                      onChanged: cubit.toggleMeeting,
                    ),
                  ],
                ),
    
                TextField(
                  controller: cubit.linkController,
                  enabled: state.meetingEnabled,
                  decoration: const InputDecoration(
                    hintText: "https://meet.google.com",
                    border: OutlineInputBorder(),
                  ),
                ),
    const SizedBox(height: 20),
    
    /// INTERVIEWERS TITLE
    const Text(
      "Interviewers",
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
    
    const SizedBox(height: 10),
    
    /// ADD INTERVIEWER INPUT
    Row(
      children: [
        Expanded(
    child: TextField(
      controller: cubit.interviewerController,
      decoration: const InputDecoration(
        hintText: "Enter interviewer name",
        border: OutlineInputBorder(),
      ),
    ),
        ),
        const SizedBox(width: 10),
    
        ElevatedButton(
    onPressed: () {
      final name = cubit.interviewerController.text.trim();
    
      if (name.isNotEmpty) {
        cubit.addInterviewer(name);
        cubit.interviewerController.clear(); // clear after add
      }
    },
    child: const Text("Add"),
        ),
      ],
    ),
    
    const SizedBox(height: 15),
    
    /// REAL-TIME INTERVIEWERS WITH FACES
    BlocBuilder<InterviewScheduleCubit, InterviewScheduleState>(
      builder: (context, state) {
        return Wrap(
    spacing: 10,
    runSpacing: 10,
         children: state.interviewers.map((person) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
    color: Colors.grey.shade200,
    borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      CircleAvatar(
        radius: 14,
        backgroundImage: NetworkImage(person.avatar),
      ),
      const SizedBox(width: 8),
    
      Text(person.name),
    
      const SizedBox(width: 6),
    
      GestureDetector(
        onTap: () {
          context
              .read<InterviewScheduleCubit>()
              .removeInterviewer(person.name);
        },
        child: const Icon(Icons.close, size: 18),
      ),
    ],
        ),
      );
    }).toList(),
        );
      },
    ),
                const SizedBox(height: 40),
    
                /// Submit Button (FIXED LOADING UI)
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: state.isLoading
                        ? null
                        : () => cubit.schedule(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
                        ),
                    child: state.isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text("Schedule",style: TextStyle(color: Colors.white,fontSize: 16),),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
