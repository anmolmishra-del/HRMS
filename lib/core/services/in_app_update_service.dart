import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';


/// Centralized Service to handle Google Play In-App Updates.
class InAppUpdateService {
  /// Checks for available app updates on Google Play Store.
  /// Automatically triggers Flexible update (or Immediate update if required).
  static Future<void> checkForUpdate(BuildContext context, {bool isManualCheck = false}) async {
    try {
      debugPrint('🔍 Checking for Google Play In-App Updates...');
      final info = await InAppUpdate.checkForUpdate();

      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        debugPrint('🚀 App update available! Version code: ${info.availableVersionCode}');

        if (info.flexibleUpdateAllowed) {
          // Perform Flexible Update (download in background)
          final result = await InAppUpdate.startFlexibleUpdate();
          if (result == AppUpdateResult.success && context.mounted) {
            _showUpdateDownloadedSnackBar(context);
          }
        } else if (info.immediateUpdateAllowed) {
          // Perform Immediate Update (mandatory full screen update)
          await InAppUpdate.performImmediateUpdate();
        }
      } else {
        debugPrint('✅ App is up to date (Update availability: ${info.updateAvailability})');
        if (isManualCheck && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your app is up to date!'),
              backgroundColor: Color(0xFF2E7D32),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('⚠️ InAppUpdate notice/error: $e');
      if (isManualCheck && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Check for updates: $e'),
            backgroundColor: Colors.grey.shade800,
          ),
        );
      }
    }
  }

  /// Prompts user to complete the update once the flexible update binary is downloaded.
  static void _showUpdateDownloadedSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.system_update_rounded, color: Colors.white, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'An update has been downloaded. Restart to apply.',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        duration: const Duration(days: 1), // Persistent until tapped
        backgroundColor:Colors.blueAccent,
        action: SnackBarAction(
          label: 'RESTART',
          textColor: Colors.black,
          onPressed: () async {
            try {
              await InAppUpdate.completeFlexibleUpdate();
            } catch (e) {
              debugPrint('Error completing flexible update: $e');
            }
          },
        ),
      ),
    );
  }
}
