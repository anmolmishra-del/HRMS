class DocumentModel {

  final String title;

  final String icon;

  final bool isUploaded;

  final bool verified;

  final String? fileName;

  final String? filePath;

  DocumentModel({
    required this.title,
    required this.icon,
    this.isUploaded = false,
    this.verified = false,
    this.fileName,
    this.filePath,
  });

  String get name => title;

  DocumentModel copyWith({
    bool? isUploaded,
    bool? verified,
    String? fileName,
    String? filePath,
  }) {

    return DocumentModel(

      title: title,

      icon: icon,

      isUploaded:
          isUploaded ??
              this.isUploaded,

      verified:
          verified ??
              this.verified,

      fileName:
          fileName ??
              this.fileName,

      filePath:
          filePath ??
              this.filePath,
    );
  }
}
