import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_app/ats/features/onboard_check/presentaion/onboard_checklist_page.dart';
import 'package:flutter_app/ats/features/upload_document/cubit/upload_document_cubit.dart';
import 'package:flutter_app/ats/features/upload_document/presentaion/document_tile.dart';
import 'package:flutter_app/ats/features/upload_document/state/upload_document_state.dart';


class UploadDocumentPage
    extends StatelessWidget {

  // const UploadDocumentPage({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (_) => UploadDocumentCubit(),

      child: Builder(
        builder: (context) {
          return Scaffold(
            // backgroundColor:
            //     const Color(0xFFF8F9FD),
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            // backgroundColor: Colors.white,
          
            automaticallyImplyLeading: false,
          
            title: const Text(
              "Upload Documents",
          
              style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 22,
              ),
            ),
          ),
            body: Padding(
              
              padding: const EdgeInsets.all(20),
          
              child: Column(
                children: [
          
                  Expanded(
                    child: BlocBuilder<
                        UploadDocumentCubit,
                        UploadDocumentState>(
          
                      builder: (context, state) {
          
                        if (state
                            is UploadDocumentLoaded) {
          
                          return ListView.builder(
                            itemCount:
                                state.documents.length,
          
                            itemBuilder:
                                (context, index) {
          
                              final document =
                                  state.documents[index];
          
                              return DocumentTile(
                                model: document,
          
                           onTap: () async {
          
            if (document.isUploaded &&
          document.filePath != null) {
          
              await OpenFile.open(
          document.filePath!,
              );
          
            } else {
          
              context
            .read<
                UploadDocumentCubit>()
            .uploadFile(
              index,
            );
            }
          },
                              );
                            },
                          );
                        }
          
                        return const SizedBox();
                      },
                    ),
                  ),
          
                  const SizedBox(height: 20),
          
                  SizedBox(
                    width: double.infinity,
                    height: 60,
          
                    child: ElevatedButton(
                   onPressed: () {
          
            final documents =
          context
              .read<UploadDocumentCubit>()
              .documents;
          
            final allUploaded =
          documents.every(
              (doc) => doc.isUploaded,
            );
          
            if (allUploaded) {
          
              Navigator.push(
          context,
          
          MaterialPageRoute(
            builder: (_) =>
                const OnboardingChecklistPage(),
          ),
              );
          
            } else {
          
              ScaffoldMessenger.of(context)
            .showSnackBar(
          
          const SnackBar(
            content: Text(
              "Please upload all documents",
            ),
          ),
              );
            }
          },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF5B3FFF),
          
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(18),
                        ),
                      ),
          
                      child: const Text(
                        "Continue",
          
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
              ),
            ),
          );
        }
      ),
    );
  }
}
