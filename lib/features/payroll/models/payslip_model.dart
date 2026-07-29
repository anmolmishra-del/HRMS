import 'package:flutter_app/core/models/odoo_models.dart';

class PayslipLine {
  final int id;
  final String name;
  final String code;
  final double total;
  final bool appearsOnPayslip;
  final ManyToOne? categoryId;

  PayslipLine({
    required this.id,
    required this.name,
    required this.code,
    required this.total,
    this.appearsOnPayslip = true,
    this.categoryId,
  });

  factory PayslipLine.fromJson(Map<String, dynamic> json) {
    return PayslipLine(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      total: json['total'] is num ? (json['total'] as num).toDouble() : double.tryParse(json['total']?.toString() ?? '0.0') ?? 0.0,
      appearsOnPayslip: json['appears_on_payslip'] is bool ? json['appears_on_payslip'] : true,
      categoryId: ManyToOne.tryParse(json['category_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'total': total,
      'appears_on_payslip': appearsOnPayslip,
      'category_id': categoryId?.toJson(),
    };
  }
}

class Payslip {
  final int id;
  final String name;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final List<PayslipLine> lines;

  Payslip({
    required this.id,
    required this.name,
    this.dateFrom,
    this.dateTo,
    this.lines = const [],
  });

  factory Payslip.fromJson(Map<String, dynamic> json) {
    final rawLines = json['lines'];
    List<PayslipLine> parsedLines = [];
    if (rawLines is List) {
      parsedLines = rawLines.map((e) => PayslipLine.fromJson(e as Map<String, dynamic>)).toList();
    }

    return Payslip(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      dateFrom: json['date_from'] != null && json['date_from'] != false
          ? DateTime.tryParse(json['date_from'].toString())
          : null,
      dateTo: json['date_to'] != null && json['date_to'] != false
          ? DateTime.tryParse(json['date_to'].toString())
          : null,
      lines: parsedLines,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date_from': dateFrom?.toIso8601String(),
      'date_to': dateTo?.toIso8601String(),
      'lines': lines.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Payslip(id: $id, name: $name, dateFrom: $dateFrom, dateTo: $dateTo, linesCount: ${lines.length})';
  }
}
