import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/network/odoo_service.dart';
import 'package:flutter_app/network/payroll_api_service.dart';

class RecordingOdooService extends OdooService {
  final dynamic Function(String model, String method, List<dynamic> args, Map<String, dynamic>? kwargs)? handler;

  RecordingOdooService({this.handler}) : super('http://localhost');

  @override
  Future<dynamic> executeModelMethod(
    String model,
    String method,
    List<dynamic> args, {
    Map<String, dynamic>? kwargs,
    bool silent = false,
  }) async {
    if (handler != null) {
      return handler!(model, method, args, kwargs);
    }
    return true;
  }
}

void main() {
  test('downloadItDeclaration treats a returned URL payload as success', () async {
    final odoo = RecordingOdooService(handler: (model, method, args, kwargs) async {
      expect(model, 'emp.it.declaration');
      expect(method, 'action_download_submission_pdf');
      return {'url': 'https://example.com/it-declaration.pdf'};
    });

    final service = PayrollApiService(odoo);
    final success = await service.downloadItDeclaration(5, {});

    expect(success, isTrue);
  });

  test('downloadSubmissionPdf extracts a URL from the returned action payload', () async {
    final odoo = RecordingOdooService(handler: (model, method, args, kwargs) async {
      expect(model, 'emp.it.declaration');
      expect(method, 'action_download_submission_pdf');
      return {'url': 'https://example.com/it-declaration.pdf'};
    });

    final service = PayrollApiService(odoo);
    final url = await service.downloadSubmissionPdf(5);

    expect(url, 'https://example.com/it-declaration.pdf');
  });
}
