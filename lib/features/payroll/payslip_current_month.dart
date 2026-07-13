import 'package:flutter/material.dart';
import 'package:flutter_app/core/constants/app_colors.dart';
import 'package:flutter_app/features/payroll/models/payslip_model.dart';
import 'package:flutter_app/l10n/app_localizations.dart';

class CurrentMonthCard extends StatelessWidget {
  final Payslip? payslip;
  final bool showSalary;
  final VoidCallback onToggleShowSalary;

  const CurrentMonthCard({
    super.key,
    this.payslip,
    required this.showSalary,
    required this.onToggleShowSalary,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    double basicPay = 0;
    double allowance = 0;
    double deductions = 0;
    double netSalary = 0;

    if (payslip != null) {
      double totalEarnings = 0;
      double totalDeductions = 0;

      for (final line in payslip!.lines) {
        final code = line.code.toUpperCase();
        final name = line.name.toLowerCase();
        final total = line.total.abs();

        if (code == 'NET') {
          netSalary = total;
          continue;
        }
        if (code == 'GROSS' || code == 'TAXABLE') {
          continue;
        }

        // Determine category: Earning vs Deduction
        bool isDeduction = false;
        final category = line.categoryId;
        if (category != null) {
          final catName = category.name.toLowerCase();
          if (catName.contains('deduction') || code.contains('DED') || name.contains('deduction')) {
            isDeduction = true;
          }
        } else if (code.contains('PT') || code.contains('TDS') || code.contains('IT') || name.contains('tax') || name.contains('deduction')) {
          isDeduction = true;
        }

        if (isDeduction) {
          totalDeductions += total;
        } else {
          totalEarnings += total;
          if (code == 'BASIC' || code == 'BASIC_SALARY' || name.contains('basic')) {
            basicPay = total;
          }
        }
      }

      allowance = (totalEarnings - basicPay).abs();
      deductions = totalDeductions;

      if (netSalary == 0) {
        netSalary = (totalEarnings - totalDeductions).abs();
      }
    } else {
      basicPay = 0;
      allowance = 0;
      deductions = 0;
      netSalary = 0;
    }

    String currentMonth = "${DateTime.now().month}-${DateTime.now().year}";
    if (payslip != null) {
      if (payslip!.dateTo != null) {
        currentMonth = "${payslip!.dateTo!.month}-${payslip!.dateTo!.year}";
      } else {
        currentMonth = payslip!.name;
      }
    }
    String format(double value) => "₹${value.toStringAsFixed(0)}";

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: isDark 
              ? [const Color(0xFF1F1C2C), const Color(0xFF928DAB)] 
              :  [AppColors.indigo, AppColors.brightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : const Color(0xFF4e54c8)).withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            Positioned(
              left: -30,
              bottom: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            currentMonth,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      Text(
                        AppLocalizations.of(context)!.estimated_pay,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: onToggleShowSalary,
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.net_salary,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          showSalary ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: Colors.white70,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    showSalary ? format(netSalary) : '₹ ••••••',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  Container(
                    height: 1,
                    color: Colors.white.withOpacity(0.15),
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMiniCol(AppLocalizations.of(context)!.basic_pay, showSalary ? format(basicPay) : '₹ •••••', Colors.white),
                      _buildMiniCol(AppLocalizations.of(context)!.allowance, showSalary ? format(allowance) : '₹ •••••', Colors.white),
                      _buildMiniCol(AppLocalizations.of(context)!.deductions, showSalary ? '- ${format(deductions)}' : '- ₹ •••••', const Color(0xFFFF8A8A)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniCol(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
