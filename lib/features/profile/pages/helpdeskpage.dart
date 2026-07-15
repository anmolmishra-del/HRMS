import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/app_localizations.dart';

import '../../../core/constants/app_colors.dart';

class HelpDeskPage extends StatelessWidget {
  const HelpDeskPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children:[
             _buildHeader(context),
        ]
      ),
    );
  }
}
Widget _buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.indigo, AppColors.brightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          ),
          Expanded(
            child: Text(
              l10n.help_desk,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }