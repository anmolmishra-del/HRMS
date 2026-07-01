import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/ats/core/constants/app_colors.dart';
import 'package:flutter_app/ats/core/controllers.dart/offer_controller.dart';
import 'package:flutter_app/ats/core/widgets/primary_button.dart';
import 'package:flutter_app/ats/features/offer_accept/model/model_class.dart';

class SuccessCard extends StatelessWidget {
  final OfferAcceptedModel model;

  const SuccessCard({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Spacer(),
  Container(
            width: 150,
            height: 150,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.secondary,
                  AppColors.primary,
                ],
              ),
            ),
            child: const Icon(
              Icons.check,
              size: 80,
              color: Colors.white,
            ),
          ),
  const SizedBox(height: 40),

          const Text(
            'Congratulations!',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: AppColors. textPrimary,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            model.candidateName,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'has accepted the offer',
            style: TextStyle(
              fontSize: 20,
              color: AppColors.shadow,
            ),
          ),

          const SizedBox(height: 60),

          const Text(
            'Joining Date',
            style: TextStyle(
              fontSize: 20,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            model.joiningDate,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Spacer(),

          PrimaryButton(
            title: 'View Details',
            onTap: () {
              OfferController.openDetails(context);
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
