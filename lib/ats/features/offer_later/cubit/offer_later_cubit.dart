import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/features/offer_later/state/offer_later_state.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class OfferLetterCubit extends Cubit<OfferLetterState> {
  OfferLetterCubit() : super(OfferLetterState());

  void setPackage(String value) {
    emit(state.copyWith(package: value));
  }

  void setReporting(String value) {
    emit(state.copyWith(reportingTo: value));
  }

  void setLocation(String value) {
    emit(state.copyWith(location: value));
  }

  void setJoiningDate(String value) {
    emit(state.copyWith(joiningDate: value));
  }

  Future<void> generateOffer() async {
    final offer = """
🎉 OFFER LETTER

We are pleased to offer you the position.

Package: ${state.package}
Reporting To: ${state.reportingTo}
Location: ${state.location}
Joining Date: ${state.joiningDate}

We welcome you to our organization.
""";

    final pdfBytes = await _buildOfferPdf(offer);

    emit(state.copyWith(
      isGenerated: true,
      offerText: offer,
      offerPdfBytes: pdfBytes,
    ));
  }

  Future<Uint8List> _buildOfferPdf(String offerText) async {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'OFFER LETTER',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 24),
                pw.Text(offerText, style: const pw.TextStyle(fontSize: 14)),
              ],
            ),
          );
        },
      ),
    );

    return doc.save();
  }
}
