
import 'package:equatable/equatable.dart';
import 'package:flutter_app/ats/features/upload_document/model/model_class.dart';

abstract class UploadDocumentState
    extends Equatable {

  @override
  List<Object?> get props => [];
}

class UploadDocumentInitial
    extends UploadDocumentState {}

class UploadDocumentLoaded
    extends UploadDocumentState {

  final List<DocumentModel> documents;

  UploadDocumentLoaded(this.documents);

  @override
  List<Object?> get props => [documents];
}
