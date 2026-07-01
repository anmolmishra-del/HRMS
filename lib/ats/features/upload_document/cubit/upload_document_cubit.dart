import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/features/upload_document/model/model_class.dart';
import 'package:flutter_app/ats/features/upload_document/state/upload_document_state.dart';

class UploadDocumentCubit
    extends Cubit<UploadDocumentState> {

  UploadDocumentCubit()
      : super(UploadDocumentInitial()) {

    loadDocuments();
  }

  List<DocumentModel> documents = [

    DocumentModel(
      title: "Aadhaar Card",
      icon: "assets/aadhar.png",
      isUploaded: false,
    ),

    DocumentModel(
      title: "PAN Card",
      icon: "assets/pan.png",
      isUploaded: false,
    ),

    DocumentModel(
      title: "Passport Size Photo",
      icon: "assets/photo.png",
      isUploaded: false,
    ),

    DocumentModel(
      title: "Education Certificate",
      icon: "assets/certificate.png",
      isUploaded: false,
    ),

    DocumentModel(
      title: "Experience Letter",
      icon: "assets/document.png",
      isUploaded: false,
    ),
  ];

  void loadDocuments() {

    documents = documents.map((doc) {

      return doc.copyWith(
        isUploaded: false,
        fileName: null,
        filePath: null,
      );

    }).toList();

    emit(
      UploadDocumentLoaded(
        List<DocumentModel>.from(
          documents,
        ),
      ),
    );
  }

  Future<void> uploadFile(int index) async {

    // try {

    //   FilePickerResult? result =
    //       await FilePicker.platform.pickFiles();

    //   if (result != null &&
    //       result.files.isNotEmpty) {

    //     final file =
    //         result.files.first;

    //     documents[index] =
    //         documents[index].copyWith(
    //       isUploaded: true,
    //       fileName: file.name,
    //       filePath: file.path,
    //     );

    //     debugPrint(
    //       documents[index]
    //           .isUploaded
    //           .toString(),
    //     );

    //     emit(
    //       UploadDocumentLoaded(
    //         List<DocumentModel>.from(
    //           documents,
    //         ),
    //       ),
    //     );
    //   }

    // } catch (e) {

    //   debugPrint(
    //     documents[index]
    //         .isUploaded
    //         .toString(),
    //   );
    // }
  }

  /// ADD THIS METHOD
  Future<void> uploadRemainingDocuments() async {

    for (int i = 0; i < documents.length; i++) {

      if (!documents[i].isUploaded) {

        await uploadFile(i);
      }
    }
  }
}
