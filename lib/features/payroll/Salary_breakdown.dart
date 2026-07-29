import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/app_localizations.dart';

import 'package:flutter_app/features/payroll/models/payslip_model.dart';

class SalaryBreakdownCard extends StatelessWidget {
  final Payslip? payslip;
  final bool showSalary;

  const SalaryBreakdownCard({super.key, this.payslip, this.showSalary = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<PayslipLine> earningsList = [];
    final List<PayslipLine> deductionsList = [];

    double totalEarnings = 0;
    double totalDeductions = 0;
    double netSalary = 0;

    if (payslip != null) {
      for (final line in payslip!.lines) {
        final code = line.code.toUpperCase();
        final name = line.name;
        final total = line.total.abs();

        if (code == 'NET') {
          netSalary = total;
          continue;
        }
        if (code == 'GROSS' || code == 'TAXABLE') {
          // Keep Gross and Taxable excluded from individual items
          continue;
        }

        // Determine category: Earning vs Deduction
        bool isDeduction = false;
        final category = line.categoryId;
        if (category != null) {
          final catName = category.name.toLowerCase();
          if (catName.contains('deduction') || code.contains('DED') || name.toLowerCase().contains('deduction')) {
            isDeduction = true;
          }
        } else if (code.contains('PT') || code.contains('TDS') || code.contains('IT') || name.toLowerCase().contains('tax') || name.toLowerCase().contains('deduction')) {
          isDeduction = true;
        }

        if (isDeduction) {
          if (total > 0) {
            deductionsList.add(line);
            totalDeductions += total;
          }
        } else {
          if (total > 0) {
            earningsList.add(line);
            totalEarnings += total;
          }
        }
      }

      if (netSalary == 0) {
        netSalary = (totalEarnings - totalDeductions).abs();
      }
    }

    String format(double value) => "₹${value.toStringAsFixed(0)}";

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.08) : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.salary_structure_breakdown,
            style: const TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 20),

          // Earnings Section
          if (earningsList.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text("No earnings", style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
            )
          else
            ...earningsList.map((e) => _buildItemRow(e.name, e.total, totalEarnings, const Color(0xFF4e54c8))),

          const SizedBox(height: 24),
          
          // Deductions Section
          if (deductionsList.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text("No deductions", style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
            )
          else
            ...deductionsList.map((d) => _buildItemRow(d.name, d.total, totalDeductions, Colors.redAccent, isDeduction: true)),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Divider(height: 1, thickness: 1),
          ),

          // Total Net Pay
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.take_home_salary,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF4e54c8).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  showSalary ? format(netSalary) : '₹ ••••••',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF4e54c8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String totalValue, Color totalColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: Colors.grey.shade500,
            letterSpacing: 1.0,
          ),
        ),
        Text(
          showSalary ? totalValue : (title.contains('DEDUCTIONS') ? '- ₹ •••••' : '₹ •••••'),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: totalColor,
          ),
        ),
      ],
    );
  }

  Widget _buildItemRow(String label, double value, double total, Color barColor, {bool isDeduction = false}) {
    final ratio = total > 0 ? (value / total) : 0.0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                showSalary 
                    ? "${isDeduction ? '-' : ''}₹${value.toStringAsFixed(0)}"
                    : "${isDeduction ? '-' : ''}₹ ••••",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              height: 4,
              width: double.infinity,
              color: barColor.withOpacity(0.1),
              child: Row(
                children: [
                  Expanded(
                    flex: (ratio * 100).toInt(),
                    child: Container(color: barColor),
                  ),
                  Expanded(
                    flex: ((1.0 - ratio) * 100).toInt(),
                    child: Container(color: Colors.transparent),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
