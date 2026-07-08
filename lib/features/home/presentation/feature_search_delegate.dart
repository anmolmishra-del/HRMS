import 'package:flutter/material.dart';
import 'package:flutter_app/routes.dart';

class FeatureSearchDelegate extends SearchDelegate<String?> {
  final List<Map<String, dynamic>> features = [
    {'title': 'Leave List / Time Off', 'route': Routes.leaveList, 'icon': Icons.calendar_month},
    {'title': 'Request Time Off / Apply Leave', 'route': Routes.applyLeave, 'icon': Icons.add_moderator},
    {'title': 'My Pay / Payslip', 'route': Routes.myPay, 'icon': Icons.payment},
    {'title': 'Profile / Personal Info', 'route': Routes.personalinf, 'icon': Icons.person},
    {'title': 'Attendance Report', 'route': Routes.inOutReport, 'icon': Icons.access_time},
    {'title': 'Company Calendar', 'route': Routes.holidayCalendar, 'icon': Icons.event},
    {'title': 'Chat Bot', 'route': Routes.aichatbot, 'icon': Icons.chat},
    {'title': 'Documents', 'route': Routes.docbox, 'icon': Icons.folder},
    {'title': 'Job Details', 'route': Routes.jobdetails, 'icon': Icons.work},
    {'title': 'Notifications', 'route': Routes.notifications, 'icon': Icons.notifications},
    {'title': 'Events', 'route': Routes.events, 'icon': Icons.event_available},
    {'title': 'Projects', 'route': Routes.projects, 'icon': Icons.assignment},
    {'title': 'Assigned Assets', 'route': Routes.assignedAssets, 'icon': Icons.devices},
    {'title': 'Request New Equipment', 'route': Routes.newEquipment, 'icon': Icons.construction_rounded},
    {'title': 'IT Declarations', 'route': Routes.itDeclarations, 'icon': Icons.description},
    {'title': 'Tax Regime Comparison', 'route': Routes.taxComparison, 'icon': Icons.compare},
    {'title': 'Leave Balance', 'route': Routes.leavebalance, 'icon': Icons.account_balance_wallet},
    {'title': 'Performance Review', 'route': Routes.performRev, 'icon': Icons.rate_review},
    {'title': 'Reimbursements', 'route': Routes.reimbursements, 'icon': Icons.monetization_on},
    {'title': 'Training & Learning', 'route': Routes.learnTraing, 'icon': Icons.school},
    {'title': 'Change Password', 'route': Routes.changepassword, 'icon': Icons.lock},
    {'title': 'Language Settings', 'route': Routes.language, 'icon': Icons.language},
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    final suggestions = query.isEmpty
        ? features
        : features.where((feature) {
            return feature['title']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase());
          }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final feature = suggestions[index];
        return ListTile(
          leading: Icon(feature['icon'] as IconData, color: Theme.of(context).primaryColor),
          title: Text(feature['title'] as String),
          onTap: () {
            close(context, feature['title'] as String);
            Navigator.pushNamed(context, feature['route'] as String);
          },
        );
      },
    );
  }
}
