import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/features/candidatefolder/candidate_screen/cubit/candidate_screen_cubit.dart';
import 'package:flutter_app/ats/features/candidatefolder/candidate_screen/state/candidate_state.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ResumePage extends StatefulWidget {
  final int? candidateId;
  final String? email;
  const ResumePage({super.key, this.candidateId, this.email});

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  @override
  void initState() {
    super.initState();

    /// 🔥 PAGE OPEN FLOW
    context.read<ProfileCubit>().loadResume(widget.candidateId, widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(18),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  /// TOP BAR
                  Row(
                    children: [
                      // InkWell(
                      //   onTap: () => Navigator.pop(context),
                      //   child: const Icon(Icons.arrow_back_ios),
                      // ),

                      const SizedBox(width: 12),

                      const Text(
                        "Resume Preview",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Spacer(),

                      const Icon(Icons.share_outlined),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// 📄 PDF PREVIEW
                  Expanded(
                    child: state.pdfUrl == null
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ClipRRect(
                            // borderRadius: BorderRadius.circular(20),
                            child: SfPdfViewer.network(
                              state.pdfUrl!,
                              headers: state.sessionToken != null && state.sessionToken!.isNotEmpty
                                  ? {'Cookie': 'session_id=${state.sessionToken}'}
                                  : null,
                            ),
                          ),
                  ),

                  const SizedBox(height: 20),

                  /// 📥 DOWNLOAD BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff4B39EF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),

                      onPressed: () {
                        context
                            .read<ProfileCubit>()
                            .downloadResume(
                             context,
    state.pdfUrl!,);
                      },

                      icon: const Icon(Icons.download, color: Colors.white),

                      label: const Text(
                        "Download Resume",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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
