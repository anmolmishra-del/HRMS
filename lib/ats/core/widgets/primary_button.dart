import 'package:flutter/material.dart';
import 'package:flutter_app/ats/core/constants/app_colors.dart';


class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const PrimaryButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
        ),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [
                AppColors.secondary,
                AppColors.primary,
              ],
            ),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
