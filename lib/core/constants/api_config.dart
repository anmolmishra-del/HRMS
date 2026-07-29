class ApiConfig {
  ApiConfig._();

  // ---------------------------------------------------------
  // BASE URL CONFIGURATION
  // ---------------------------------------------------------

  // 🚀 PRODUCTION
  // static const String baseUrl = 'https://ftprotech.in/';
  // static const String dbName = 'ftprotech';

  // 🧪 TESTING / STAGING(Ftprotech)
  // static const String baseUrl = 'https://test.ftprotech.in/';
  // static const String dbName = 'pmt_test';

  // TESTING / STAGING(Srivyn)
  static const String baseUrl = 'https://test.srivyn.in/';
  static const String dbName = 'srivyn_test';

  // 🛠️ ALTERNATE TESTING (Odoo 18)
  // static const String baseUrl = 'http://192.168.88.18:2025';
  // static const String dbName = 'ftp_live_may_08_2026';
// }
}
