import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/app_localizations.dart';

class AtsLocalizations {
  /// Translates dynamic Odoo recruitment stages to localized names
  static String getStage(BuildContext context, String stageName) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return stageName;
    
    final lower = stageName.toLowerCase().trim();
    switch (lower) {
      case 'all':
        return l10n.tab_all;
      case 'new':
        return l10n.tab_new;
      case 'screening':
        return l10n.tab_screening;
      case 'first interview':
        return l10n.tab_first_interview;
      case 'second interview':
        return l10n.tab_second_interview;
      case 'offered':
        return l10n.tab_offered;
      case 'hired':
        return l10n.tab_hired;
      case 'refused':
        return l10n.tab_refused;
      case 'ij':
        return l10n.tab_ij;
      case 'hr stage':
        return l10n.tab_hr_stage;
      case 'contract proposal':
        return l10n.tab_contract_proposal;
      case 'contract signed':
        return l10n.tab_contract_signed;
      case 'published':
        return l10n.tab_published;
      case 'unpublished':
        return l10n.tab_unpublished;
      case 'ongoing':
        return l10n.tab_ongoing;
      default:
        return stageName;
    }
  }
}
