import 'package:flutter/material.dart';

class OfferController {
  static void openDetails(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening Offer Details...'),
      ),
    );
  }
}
