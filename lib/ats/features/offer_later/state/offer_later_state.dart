import 'dart:typed_data';

class OfferLetterState {
  final String package;
  final String reportingTo;
  final String location;
  final String joiningDate;

  final bool isGenerated;
  final String offerText;
  final Uint8List? offerPdfBytes;

  OfferLetterState({
    this.package = "",
    this.reportingTo = "",
    this.location = "",
    this.joiningDate = "",
    this.isGenerated = false,
    this.offerText = "",
    this.offerPdfBytes,
  });

  OfferLetterState copyWith({
    String? package,
    String? reportingTo,
    String? location,
    String? joiningDate,
    bool? isGenerated,
    String? offerText,
    Uint8List? offerPdfBytes,
  }) {
    return OfferLetterState(
      package: package ?? this.package,
      reportingTo: reportingTo ?? this.reportingTo,
      location: location ?? this.location,
      joiningDate: joiningDate ?? this.joiningDate,
      isGenerated: isGenerated ?? this.isGenerated,
      offerText: offerText ?? this.offerText,
      offerPdfBytes: offerPdfBytes ?? this.offerPdfBytes,
    );
  }
}
