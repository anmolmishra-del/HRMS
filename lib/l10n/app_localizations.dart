import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_te.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('te'),
    Locale('ur'),
  ];

  /// No description provided for @welcome_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome to\nOpzento HR'**
  String get welcome_title;

  /// No description provided for @welcome_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Experience a seamless way to manage all your HR tasks in one place.'**
  String get welcome_subtitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @remember_me.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get remember_me;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot?'**
  String get forgot_password;

  /// No description provided for @sign_in.
  ///
  /// In en, this message translates to:
  /// **'SIGN IN'**
  String get sign_in;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next_step.
  ///
  /// In en, this message translates to:
  /// **'Next Step'**
  String get next_step;

  /// No description provided for @get_started.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get get_started;

  /// No description provided for @attendance_payroll.
  ///
  /// In en, this message translates to:
  /// **'Attendance &\nPayroll Made Easy'**
  String get attendance_payroll;

  /// No description provided for @attendance_payroll_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Monitor your attendance and manage payroll with precision and ease.'**
  String get attendance_payroll_subtitle;

  /// No description provided for @sign_in_continue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get sign_in_continue;

  /// No description provided for @powered_by.
  ///
  /// In en, this message translates to:
  /// **'POWERED BY'**
  String get powered_by;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @error_empty_fields.
  ///
  /// In en, this message translates to:
  /// **'Please enter username and password'**
  String get error_empty_fields;

  /// No description provided for @error_enter_username.
  ///
  /// In en, this message translates to:
  /// **'Please enter username'**
  String get error_enter_username;

  /// No description provided for @error_enter_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get error_enter_password;

  /// No description provided for @personal_details.
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get personal_details;

  /// No description provided for @personal_information.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personal_information;

  /// No description provided for @employee_code.
  ///
  /// In en, this message translates to:
  /// **'Employee Code'**
  String get employee_code;

  /// No description provided for @full_name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get full_name;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @date_of_birth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get date_of_birth;

  /// No description provided for @marital_status.
  ///
  /// In en, this message translates to:
  /// **'Marital Status'**
  String get marital_status;

  /// No description provided for @blood_group.
  ///
  /// In en, this message translates to:
  /// **'Blood Group'**
  String get blood_group;

  /// No description provided for @identification_id.
  ///
  /// In en, this message translates to:
  /// **'Identification ID'**
  String get identification_id;

  /// No description provided for @passport_no.
  ///
  /// In en, this message translates to:
  /// **'Passport No'**
  String get passport_no;

  /// No description provided for @aadhar_no.
  ///
  /// In en, this message translates to:
  /// **'Aadhar No'**
  String get aadhar_no;

  /// No description provided for @pan_no.
  ///
  /// In en, this message translates to:
  /// **'PAN No'**
  String get pan_no;

  /// No description provided for @work_information.
  ///
  /// In en, this message translates to:
  /// **'Work Information'**
  String get work_information;

  /// No description provided for @job_title.
  ///
  /// In en, this message translates to:
  /// **'Job Title'**
  String get job_title;

  /// No description provided for @department.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get department;

  /// No description provided for @work_location.
  ///
  /// In en, this message translates to:
  /// **'Work Location'**
  String get work_location;

  /// No description provided for @manager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get manager;

  /// No description provided for @date_of_joining.
  ///
  /// In en, this message translates to:
  /// **'Date of Joining'**
  String get date_of_joining;

  /// No description provided for @work_email.
  ///
  /// In en, this message translates to:
  /// **'Work Email'**
  String get work_email;

  /// No description provided for @work_phone.
  ///
  /// In en, this message translates to:
  /// **'Work Phone'**
  String get work_phone;

  /// No description provided for @employment_type.
  ///
  /// In en, this message translates to:
  /// **'Employment Type'**
  String get employment_type;

  /// No description provided for @emergency_contact.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get emergency_contact;

  /// No description provided for @contact_name.
  ///
  /// In en, this message translates to:
  /// **'Contact Name'**
  String get contact_name;

  /// No description provided for @contact_phone.
  ///
  /// In en, this message translates to:
  /// **'Contact Phone'**
  String get contact_phone;

  /// No description provided for @bank_details.
  ///
  /// In en, this message translates to:
  /// **'Bank Details'**
  String get bank_details;

  /// No description provided for @bank_name.
  ///
  /// In en, this message translates to:
  /// **'Bank Name'**
  String get bank_name;

  /// No description provided for @ifsc_code.
  ///
  /// In en, this message translates to:
  /// **'IFSC Code'**
  String get ifsc_code;

  /// No description provided for @account_id.
  ///
  /// In en, this message translates to:
  /// **'Account ID'**
  String get account_id;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @residential_address.
  ///
  /// In en, this message translates to:
  /// **'Residential Address'**
  String get residential_address;

  /// No description provided for @permanent_address.
  ///
  /// In en, this message translates to:
  /// **'Permanent Address'**
  String get permanent_address;

  /// No description provided for @employee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get employee;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @working_hours.
  ///
  /// In en, this message translates to:
  /// **'Working Hours'**
  String get working_hours;

  /// No description provided for @check_in.
  ///
  /// In en, this message translates to:
  /// **'Check In'**
  String get check_in;

  /// No description provided for @check_out.
  ///
  /// In en, this message translates to:
  /// **'Check Out'**
  String get check_out;

  /// No description provided for @checking_in.
  ///
  /// In en, this message translates to:
  /// **'Checking In...'**
  String get checking_in;

  /// No description provided for @checking_out.
  ///
  /// In en, this message translates to:
  /// **'Checking Out...'**
  String get checking_out;

  /// No description provided for @checked_in_success.
  ///
  /// In en, this message translates to:
  /// **'Checked in successfully'**
  String get checked_in_success;

  /// No description provided for @checked_out_success.
  ///
  /// In en, this message translates to:
  /// **'Checked out successfully'**
  String get checked_out_success;

  /// No description provided for @session_expired.
  ///
  /// In en, this message translates to:
  /// **'Session expired'**
  String get session_expired;

  /// No description provided for @session_expired_relogin.
  ///
  /// In en, this message translates to:
  /// **'Your password has been changed successfully. Please log in again with your new password.'**
  String get session_expired_relogin;

  /// No description provided for @okay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get okay;

  /// No description provided for @session_info_missing.
  ///
  /// In en, this message translates to:
  /// **'Session info missing'**
  String get session_info_missing;

  /// No description provided for @attendance_report.
  ///
  /// In en, this message translates to:
  /// **'Attendance Report'**
  String get attendance_report;

  /// No description provided for @inout_report.
  ///
  /// In en, this message translates to:
  /// **'In/Out Report'**
  String get inout_report;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @still_working.
  ///
  /// In en, this message translates to:
  /// **'Still Working'**
  String get still_working;

  /// No description provided for @in_label.
  ///
  /// In en, this message translates to:
  /// **'In'**
  String get in_label;

  /// No description provided for @out.
  ///
  /// In en, this message translates to:
  /// **'Out'**
  String get out;

  /// No description provided for @break_time.
  ///
  /// In en, this message translates to:
  /// **'Break'**
  String get break_time;

  /// No description provided for @overtime.
  ///
  /// In en, this message translates to:
  /// **'Overtime'**
  String get overtime;

  /// No description provided for @validated_overtime.
  ///
  /// In en, this message translates to:
  /// **'Validated OT'**
  String get validated_overtime;

  /// No description provided for @session_label.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get session_label;

  /// No description provided for @session_timeline.
  ///
  /// In en, this message translates to:
  /// **'Session Timeline'**
  String get session_timeline;

  /// No description provided for @no_gps_location.
  ///
  /// In en, this message translates to:
  /// **'No GPS Location'**
  String get no_gps_location;

  /// No description provided for @session_active.
  ///
  /// In en, this message translates to:
  /// **'Session Active'**
  String get session_active;

  /// No description provided for @sessions_label.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions_label;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @no_records_found.
  ///
  /// In en, this message translates to:
  /// **'No records found for this period'**
  String get no_records_found;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @coach.
  ///
  /// In en, this message translates to:
  /// **'Coach'**
  String get coach;

  /// No description provided for @no_employee_data_found.
  ///
  /// In en, this message translates to:
  /// **'No employee data found'**
  String get no_employee_data_found;

  /// No description provided for @employee_id.
  ///
  /// In en, this message translates to:
  /// **'Employee ID'**
  String get employee_id;

  /// No description provided for @top_skills.
  ///
  /// In en, this message translates to:
  /// **'Top Skills'**
  String get top_skills;

  /// No description provided for @quick_actions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quick_actions;

  /// No description provided for @job_details.
  ///
  /// In en, this message translates to:
  /// **'Job Details'**
  String get job_details;

  /// No description provided for @leave_balance.
  ///
  /// In en, this message translates to:
  /// **'Leave Balance'**
  String get leave_balance;

  /// No description provided for @holidays_calendar.
  ///
  /// In en, this message translates to:
  /// **'Holidays Calendar'**
  String get holidays_calendar;

  /// No description provided for @reimbursements.
  ///
  /// In en, this message translates to:
  /// **'Reimbursements'**
  String get reimbursements;

  /// No description provided for @training_learning.
  ///
  /// In en, this message translates to:
  /// **'Training & Learning'**
  String get training_learning;

  /// No description provided for @assets_assigned.
  ///
  /// In en, this message translates to:
  /// **'Assets Assigned'**
  String get assets_assigned;

  /// No description provided for @resume_experience.
  ///
  /// In en, this message translates to:
  /// **'Resume & Experience'**
  String get resume_experience;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get dark_mode;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @security_settings.
  ///
  /// In en, this message translates to:
  /// **'Security Settings'**
  String get security_settings;

  /// No description provided for @enter_new_password_info.
  ///
  /// In en, this message translates to:
  /// **'Please enter your new password below. Make sure it\'s strong and secure.'**
  String get enter_new_password_info;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get new_password;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm_password;

  /// No description provided for @passwords_do_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwords_do_not_match;

  /// No description provided for @update_password.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get update_password;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @please_enter.
  ///
  /// In en, this message translates to:
  /// **'Please enter {field}'**
  String please_enter(Object field);

  /// No description provided for @password_min_length.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 4 characters'**
  String get password_min_length;

  /// No description provided for @password_updated_success.
  ///
  /// In en, this message translates to:
  /// **'Password Updated Successfully'**
  String get password_updated_success;

  /// No description provided for @failed_to_update_password.
  ///
  /// In en, this message translates to:
  /// **'Failed to update password'**
  String get failed_to_update_password;

  /// No description provided for @selected_year.
  ///
  /// In en, this message translates to:
  /// **'Selected Year: {year}'**
  String selected_year(Object year);

  /// No description provided for @search_holidays.
  ///
  /// In en, this message translates to:
  /// **'Search holidays...'**
  String get search_holidays;

  /// No description provided for @no_holidays_found.
  ///
  /// In en, this message translates to:
  /// **'No holidays found for {year}.'**
  String no_holidays_found(Object year);

  /// No description provided for @employee_details.
  ///
  /// In en, this message translates to:
  /// **'Employee Details'**
  String get employee_details;

  /// No description provided for @personal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get personal;

  /// No description provided for @work_bank.
  ///
  /// In en, this message translates to:
  /// **'Work & Bank'**
  String get work_bank;

  /// No description provided for @contact_information.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contact_information;

  /// No description provided for @mobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get mobile;

  /// No description provided for @birthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get birthday;

  /// No description provided for @documentation.
  ///
  /// In en, this message translates to:
  /// **'Documentation'**
  String get documentation;

  /// No description provided for @passport_id.
  ///
  /// In en, this message translates to:
  /// **'Passport ID'**
  String get passport_id;

  /// No description provided for @addresses.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get addresses;

  /// No description provided for @current_address.
  ///
  /// In en, this message translates to:
  /// **'Current Address'**
  String get current_address;

  /// No description provided for @employment_details.
  ///
  /// In en, this message translates to:
  /// **'Employment Details'**
  String get employment_details;

  /// No description provided for @reporting_manager.
  ///
  /// In en, this message translates to:
  /// **'Reporting Manager'**
  String get reporting_manager;

  /// No description provided for @bank_information.
  ///
  /// In en, this message translates to:
  /// **'Bank Information'**
  String get bank_information;

  /// No description provided for @account_number.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get account_number;

  /// No description provided for @select_your_language.
  ///
  /// In en, this message translates to:
  /// **'Select Your Language'**
  String get select_your_language;

  /// No description provided for @choose_language_info.
  ///
  /// In en, this message translates to:
  /// **'Choose the language you prefer for the app interface.'**
  String get choose_language_info;

  /// No description provided for @total_leave.
  ///
  /// In en, this message translates to:
  /// **'Total Leave'**
  String get total_leave;

  /// No description provided for @taken.
  ///
  /// In en, this message translates to:
  /// **'Taken'**
  String get taken;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @sick_leave.
  ///
  /// In en, this message translates to:
  /// **'Sick Leave'**
  String get sick_leave;

  /// No description provided for @book_leave.
  ///
  /// In en, this message translates to:
  /// **'Book Leave'**
  String get book_leave;

  /// No description provided for @report_sick.
  ///
  /// In en, this message translates to:
  /// **'Report Sick'**
  String get report_sick;

  /// No description provided for @contact_hr.
  ///
  /// In en, this message translates to:
  /// **'Contact HR'**
  String get contact_hr;

  /// No description provided for @recent_activity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recent_activity;

  /// No description provided for @view_all.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get view_all;

  /// No description provided for @annual_leave.
  ///
  /// In en, this message translates to:
  /// **'Annual Leave'**
  String get annual_leave;

  /// No description provided for @reimbursement.
  ///
  /// In en, this message translates to:
  /// **'Reimbursement'**
  String get reimbursement;

  /// No description provided for @total_expenses.
  ///
  /// In en, this message translates to:
  /// **'Total Expenses'**
  String get total_expenses;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @my_expenses.
  ///
  /// In en, this message translates to:
  /// **'My Expenses'**
  String get my_expenses;

  /// No description provided for @no_reimbursement_found.
  ///
  /// In en, this message translates to:
  /// **'No reimbursement records found.'**
  String get no_reimbursement_found;

  /// No description provided for @submit_label.
  ///
  /// In en, this message translates to:
  /// **'SUBMIT'**
  String get submit_label;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'PAID'**
  String get paid;

  /// No description provided for @submitted.
  ///
  /// In en, this message translates to:
  /// **'SUBMITTED'**
  String get submitted;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'APPROVED'**
  String get approved;

  /// No description provided for @refused.
  ///
  /// In en, this message translates to:
  /// **'REFUSED'**
  String get refused;

  /// No description provided for @draft.
  ///
  /// In en, this message translates to:
  /// **'DRAFT'**
  String get draft;

  /// No description provided for @new_expense.
  ///
  /// In en, this message translates to:
  /// **'New Expense'**
  String get new_expense;

  /// No description provided for @general_information.
  ///
  /// In en, this message translates to:
  /// **'General Information'**
  String get general_information;

  /// No description provided for @expense_title.
  ///
  /// In en, this message translates to:
  /// **'Description (Expense Title)'**
  String get expense_title;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @amount_taxes.
  ///
  /// In en, this message translates to:
  /// **'Amount & Taxes'**
  String get amount_taxes;

  /// No description provided for @total_amount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get total_amount;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @included_taxes.
  ///
  /// In en, this message translates to:
  /// **'Included Taxes'**
  String get included_taxes;

  /// No description provided for @tax_amount.
  ///
  /// In en, this message translates to:
  /// **'Tax Amount'**
  String get tax_amount;

  /// No description provided for @payment_date.
  ///
  /// In en, this message translates to:
  /// **'Payment & Date'**
  String get payment_date;

  /// No description provided for @paid_by.
  ///
  /// In en, this message translates to:
  /// **'Paid By'**
  String get paid_by;

  /// No description provided for @vendor.
  ///
  /// In en, this message translates to:
  /// **'Vendor'**
  String get vendor;

  /// No description provided for @expense_date.
  ///
  /// In en, this message translates to:
  /// **'Expense Date'**
  String get expense_date;

  /// No description provided for @internal_notes.
  ///
  /// In en, this message translates to:
  /// **'Internal Notes'**
  String get internal_notes;

  /// No description provided for @supporting_documents.
  ///
  /// In en, this message translates to:
  /// **'Supporting Documents'**
  String get supporting_documents;

  /// No description provided for @attach_receipt.
  ///
  /// In en, this message translates to:
  /// **'Attach Receipt / Bill'**
  String get attach_receipt;

  /// No description provided for @no_file_selected.
  ///
  /// In en, this message translates to:
  /// **'No file selected'**
  String get no_file_selected;

  /// No description provided for @create_expense.
  ///
  /// In en, this message translates to:
  /// **'CREATE EXPENSE'**
  String get create_expense;

  /// No description provided for @required_field.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required_field;

  /// No description provided for @please_select_category.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get please_select_category;

  /// No description provided for @expense_created_success.
  ///
  /// In en, this message translates to:
  /// **'Expense created successfully'**
  String get expense_created_success;

  /// No description provided for @fill_required_fields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields correctly'**
  String get fill_required_fields;

  /// No description provided for @performance_review_title.
  ///
  /// In en, this message translates to:
  /// **'Employee Performance Review'**
  String get performance_review_title;

  /// No description provided for @performance_ratings.
  ///
  /// In en, this message translates to:
  /// **'Performance Ratings'**
  String get performance_ratings;

  /// No description provided for @managers_comments.
  ///
  /// In en, this message translates to:
  /// **'Manager\'s Comments'**
  String get managers_comments;

  /// No description provided for @review_summary.
  ///
  /// In en, this message translates to:
  /// **'Review Summary'**
  String get review_summary;

  /// No description provided for @overall_rating_label.
  ///
  /// In en, this message translates to:
  /// **'Overall Rating'**
  String get overall_rating_label;

  /// No description provided for @goals_achieved.
  ///
  /// In en, this message translates to:
  /// **'Goals Achieved'**
  String get goals_achieved;

  /// No description provided for @previous_reviews.
  ///
  /// In en, this message translates to:
  /// **'Previous Reviews'**
  String get previous_reviews;

  /// No description provided for @download_pdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get download_pdf;

  /// No description provided for @submit_review.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submit_review;

  /// No description provided for @search_courses.
  ///
  /// In en, this message translates to:
  /// **'Search courses...'**
  String get search_courses;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @ongoing_training.
  ///
  /// In en, this message translates to:
  /// **'Ongoing Training'**
  String get ongoing_training;

  /// No description provided for @trainer.
  ///
  /// In en, this message translates to:
  /// **'Trainer'**
  String get trainer;

  /// No description provided for @learning_timeline.
  ///
  /// In en, this message translates to:
  /// **'Learning Timeline'**
  String get learning_timeline;

  /// No description provided for @lesson.
  ///
  /// In en, this message translates to:
  /// **'Lesson'**
  String get lesson;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// No description provided for @development.
  ///
  /// In en, this message translates to:
  /// **'Development'**
  String get development;

  /// No description provided for @design.
  ///
  /// In en, this message translates to:
  /// **'Design'**
  String get design;

  /// No description provided for @management.
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get management;

  /// No description provided for @soft_skills.
  ///
  /// In en, this message translates to:
  /// **'Soft Skills'**
  String get soft_skills;

  /// No description provided for @leave_list.
  ///
  /// In en, this message translates to:
  /// **'Leave List'**
  String get leave_list;

  /// No description provided for @leaves.
  ///
  /// In en, this message translates to:
  /// **'Leaves'**
  String get leaves;

  /// No description provided for @my_pay.
  ///
  /// In en, this message translates to:
  /// **'My Pay'**
  String get my_pay;

  /// No description provided for @apply_leave.
  ///
  /// In en, this message translates to:
  /// **'Apply Leave'**
  String get apply_leave;

  /// No description provided for @leave_type.
  ///
  /// In en, this message translates to:
  /// **'Leave Type'**
  String get leave_type;

  /// No description provided for @start_date.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get start_date;

  /// No description provided for @end_date.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get end_date;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @ai_chat_bot.
  ///
  /// In en, this message translates to:
  /// **'AI Chat Bot'**
  String get ai_chat_bot;

  /// No description provided for @ask_me_anything.
  ///
  /// In en, this message translates to:
  /// **'Ask me anything...'**
  String get ask_me_anything;

  /// No description provided for @company_calendar.
  ///
  /// In en, this message translates to:
  /// **'Company Calendar'**
  String get company_calendar;

  /// No description provided for @doc_box.
  ///
  /// In en, this message translates to:
  /// **'Doc Box'**
  String get doc_box;

  /// No description provided for @search_documents.
  ///
  /// In en, this message translates to:
  /// **'Search documents...'**
  String get search_documents;

  /// No description provided for @new_equipment.
  ///
  /// In en, this message translates to:
  /// **'New Equipment'**
  String get new_equipment;

  /// No description provided for @equipment_name.
  ///
  /// In en, this message translates to:
  /// **'Equipment Name'**
  String get equipment_name;

  /// No description provided for @serial_number.
  ///
  /// In en, this message translates to:
  /// **'Serial Number'**
  String get serial_number;

  /// No description provided for @events_list.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events_list;

  /// No description provided for @event_details.
  ///
  /// In en, this message translates to:
  /// **'Event Details'**
  String get event_details;

  /// No description provided for @search_events.
  ///
  /// In en, this message translates to:
  /// **'Search events...'**
  String get search_events;

  /// No description provided for @chat_list.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chat_list;

  /// No description provided for @search_chats.
  ///
  /// In en, this message translates to:
  /// **'Search chats...'**
  String get search_chats;

  /// No description provided for @type_a_message.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get type_a_message;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @unread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get unread;

  /// No description provided for @read.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get read;

  /// No description provided for @new_notifications_count.
  ///
  /// In en, this message translates to:
  /// **'{count} New Notifications'**
  String new_notifications_count(Object count);

  /// No description provided for @all_caught_up.
  ///
  /// In en, this message translates to:
  /// **'All caught up!'**
  String get all_caught_up;

  /// No description provided for @no_notifications.
  ///
  /// In en, this message translates to:
  /// **'You have no new notifications.'**
  String get no_notifications;

  /// No description provided for @delivery_failed.
  ///
  /// In en, this message translates to:
  /// **'Delivery Failed: {reason}'**
  String delivery_failed(Object reason);

  /// No description provided for @failure_details.
  ///
  /// In en, this message translates to:
  /// **'Failure Details'**
  String get failure_details;

  /// No description provided for @my_time_off.
  ///
  /// In en, this message translates to:
  /// **'My Time Off'**
  String get my_time_off;

  /// No description provided for @request_leave.
  ///
  /// In en, this message translates to:
  /// **'Request Leave'**
  String get request_leave;

  /// No description provided for @no_leave_records.
  ///
  /// In en, this message translates to:
  /// **'No Leave Records'**
  String get no_leave_records;

  /// No description provided for @leave_history_info.
  ///
  /// In en, this message translates to:
  /// **'Your leave history will appear here\nonce you submit your first request.'**
  String get leave_history_info;

  /// No description provided for @days_available.
  ///
  /// In en, this message translates to:
  /// **'Days Available'**
  String get days_available;

  /// No description provided for @delete_draft.
  ///
  /// In en, this message translates to:
  /// **'Delete Draft'**
  String get delete_draft;

  /// No description provided for @cancel_leave.
  ///
  /// In en, this message translates to:
  /// **'Cancel Leave'**
  String get cancel_leave;

  /// No description provided for @cancel_request_q.
  ///
  /// In en, this message translates to:
  /// **'Cancel Request?'**
  String get cancel_request_q;

  /// No description provided for @cancel_request_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this leave request?'**
  String get cancel_request_confirm;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes_cancel.
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get yes_cancel;

  /// No description provided for @delete_draft_q.
  ///
  /// In en, this message translates to:
  /// **'Delete Draft?'**
  String get delete_draft_q;

  /// No description provided for @delete_draft_confirm.
  ///
  /// In en, this message translates to:
  /// **'This draft will be permanently removed.'**
  String get delete_draft_confirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @request_time_off.
  ///
  /// In en, this message translates to:
  /// **'Request Time Off'**
  String get request_time_off;

  /// No description provided for @date_duration.
  ///
  /// In en, this message translates to:
  /// **'Date & Duration'**
  String get date_duration;

  /// No description provided for @additional_details.
  ///
  /// In en, this message translates to:
  /// **'Additional Details'**
  String get additional_details;

  /// No description provided for @select_leave_type.
  ///
  /// In en, this message translates to:
  /// **'Select leave type'**
  String get select_leave_type;

  /// No description provided for @half_day.
  ///
  /// In en, this message translates to:
  /// **'Half Day'**
  String get half_day;

  /// No description provided for @morning_am.
  ///
  /// In en, this message translates to:
  /// **'Morning (AM)'**
  String get morning_am;

  /// No description provided for @afternoon_pm.
  ///
  /// In en, this message translates to:
  /// **'Afternoon (PM)'**
  String get afternoon_pm;

  /// No description provided for @reason_time_off_hint.
  ///
  /// In en, this message translates to:
  /// **'Reason for time off...'**
  String get reason_time_off_hint;

  /// No description provided for @submit_request.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get submit_request;

  /// No description provided for @end_date_error.
  ///
  /// In en, this message translates to:
  /// **'End date cannot be before start date'**
  String get end_date_error;

  /// No description provided for @insufficient_balance.
  ///
  /// In en, this message translates to:
  /// **'Insufficient balance. You requested {requested} days but only have {available} days available.'**
  String insufficient_balance(Object available, Object requested);

  /// No description provided for @please_select_leave_type.
  ///
  /// In en, this message translates to:
  /// **'Please select a leave type'**
  String get please_select_leave_type;

  /// No description provided for @bot_welcome.
  ///
  /// In en, this message translates to:
  /// **'Hello 👋 I\'m your HR Assistant. How can I help you today?'**
  String get bot_welcome;

  /// No description provided for @ai_hr_assistant.
  ///
  /// In en, this message translates to:
  /// **'AI HR Assistant'**
  String get ai_hr_assistant;

  /// No description provided for @type_message.
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get type_message;

  /// No description provided for @add_event.
  ///
  /// In en, this message translates to:
  /// **'Add Event'**
  String get add_event;

  /// No description provided for @event_title.
  ///
  /// In en, this message translates to:
  /// **'Event Title'**
  String get event_title;

  /// No description provided for @event.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get event;

  /// No description provided for @holiday.
  ///
  /// In en, this message translates to:
  /// **'Holiday'**
  String get holiday;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @events_on.
  ///
  /// In en, this message translates to:
  /// **'Events on {date}'**
  String events_on(Object date);

  /// No description provided for @no_events.
  ///
  /// In en, this message translates to:
  /// **'No Events'**
  String get no_events;

  /// No description provided for @company_docs.
  ///
  /// In en, this message translates to:
  /// **'Company Docs'**
  String get company_docs;

  /// No description provided for @personal_docs.
  ///
  /// In en, this message translates to:
  /// **'Personal Docs'**
  String get personal_docs;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @no_documents.
  ///
  /// In en, this message translates to:
  /// **'No Documents Available'**
  String get no_documents;

  /// No description provided for @uploaded_on.
  ///
  /// In en, this message translates to:
  /// **'Uploaded on {date}'**
  String uploaded_on(Object date);

  /// No description provided for @leave_management.
  ///
  /// In en, this message translates to:
  /// **'Leave Management'**
  String get leave_management;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @total_days.
  ///
  /// In en, this message translates to:
  /// **'Total Days'**
  String get total_days;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @product_info.
  ///
  /// In en, this message translates to:
  /// **'Product Info'**
  String get product_info;

  /// No description provided for @maintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenance;

  /// No description provided for @equipment_created_success.
  ///
  /// In en, this message translates to:
  /// **'Equipment created successfully'**
  String get equipment_created_success;

  /// No description provided for @assigned_department.
  ///
  /// In en, this message translates to:
  /// **'Assigned Department'**
  String get assigned_department;

  /// No description provided for @assigned_employee.
  ///
  /// In en, this message translates to:
  /// **'Assigned Employee'**
  String get assigned_employee;

  /// No description provided for @team.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get team;

  /// No description provided for @technician.
  ///
  /// In en, this message translates to:
  /// **'Technician'**
  String get technician;

  /// No description provided for @scrap_date.
  ///
  /// In en, this message translates to:
  /// **'Scrap Date'**
  String get scrap_date;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @vendor_reference.
  ///
  /// In en, this message translates to:
  /// **'Vendor Reference'**
  String get vendor_reference;

  /// No description provided for @model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// No description provided for @mfg_serial_number.
  ///
  /// In en, this message translates to:
  /// **'Mfg. Serial Number'**
  String get mfg_serial_number;

  /// No description provided for @inventory_serial_number.
  ///
  /// In en, this message translates to:
  /// **'Inventory Serial Number'**
  String get inventory_serial_number;

  /// No description provided for @effective_date.
  ///
  /// In en, this message translates to:
  /// **'Effective Date'**
  String get effective_date;

  /// No description provided for @cost.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get cost;

  /// No description provided for @warranty_expiration_date.
  ///
  /// In en, this message translates to:
  /// **'Warranty Expiration Date'**
  String get warranty_expiration_date;

  /// No description provided for @expected_mtbf.
  ///
  /// In en, this message translates to:
  /// **'Expected MTBF'**
  String get expected_mtbf;

  /// No description provided for @mean_time_between_failure.
  ///
  /// In en, this message translates to:
  /// **'Mean Time Between Failure'**
  String get mean_time_between_failure;

  /// No description provided for @estimated_next_failure.
  ///
  /// In en, this message translates to:
  /// **'Estimated Next Failure'**
  String get estimated_next_failure;

  /// No description provided for @latest_failure.
  ///
  /// In en, this message translates to:
  /// **'Latest Failure'**
  String get latest_failure;

  /// No description provided for @mean_time_to_repair.
  ///
  /// In en, this message translates to:
  /// **'Mean Time To Repair'**
  String get mean_time_to_repair;

  /// No description provided for @used_by.
  ///
  /// In en, this message translates to:
  /// **'Used By'**
  String get used_by;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @select_date.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get select_date;

  /// No description provided for @save_equipment.
  ///
  /// In en, this message translates to:
  /// **'Save Equipment'**
  String get save_equipment;

  /// No description provided for @error_message.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String error_message(Object error);

  /// No description provided for @company_events.
  ///
  /// In en, this message translates to:
  /// **'Company Events'**
  String get company_events;

  /// No description provided for @no_upcoming_events.
  ///
  /// In en, this message translates to:
  /// **'No Upcoming Events'**
  String get no_upcoming_events;

  /// No description provided for @check_back_later_events.
  ///
  /// In en, this message translates to:
  /// **'Check back later for new company events!'**
  String get check_back_later_events;

  /// No description provided for @something_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'Oops! Something went wrong'**
  String get something_went_wrong;

  /// No description provided for @unexpected_error.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpected_error;

  /// No description provided for @company_venue.
  ///
  /// In en, this message translates to:
  /// **'Company Venue'**
  String get company_venue;

  /// No description provided for @seats_left.
  ///
  /// In en, this message translates to:
  /// **'{count} Seats Left'**
  String seats_left(Object count);

  /// No description provided for @open_registration.
  ///
  /// In en, this message translates to:
  /// **'Open Registration'**
  String get open_registration;

  /// No description provided for @registered.
  ///
  /// In en, this message translates to:
  /// **'Registered'**
  String get registered;

  /// No description provided for @view_details.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get view_details;

  /// No description provided for @about_event.
  ///
  /// In en, this message translates to:
  /// **'About Event'**
  String get about_event;

  /// No description provided for @important_instructions.
  ///
  /// In en, this message translates to:
  /// **'Important Instructions'**
  String get important_instructions;

  /// No description provided for @select_ticket.
  ///
  /// In en, this message translates to:
  /// **'Select Ticket'**
  String get select_ticket;

  /// No description provided for @tap_view_map.
  ///
  /// In en, this message translates to:
  /// **'Tap to view on map'**
  String get tap_view_map;

  /// No description provided for @host_contact_person.
  ///
  /// In en, this message translates to:
  /// **'Host / Contact Person'**
  String get host_contact_person;

  /// No description provided for @left.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get left;

  /// No description provided for @cancelling_registration.
  ///
  /// In en, this message translates to:
  /// **'Cancelling registration...'**
  String get cancelling_registration;

  /// No description provided for @registration_cancelled_success.
  ///
  /// In en, this message translates to:
  /// **'Registration cancelled successfully.'**
  String get registration_cancelled_success;

  /// No description provided for @failed_cancel_registration.
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel registration.'**
  String get failed_cancel_registration;

  /// No description provided for @please_select_ticket_first.
  ///
  /// In en, this message translates to:
  /// **'Please select a ticket first.'**
  String get please_select_ticket_first;

  /// No description provided for @registering_event.
  ///
  /// In en, this message translates to:
  /// **'Registering for event...'**
  String get registering_event;

  /// No description provided for @successfully_registered.
  ///
  /// In en, this message translates to:
  /// **'Successfully registered!'**
  String get successfully_registered;

  /// No description provided for @registration_failed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed.'**
  String get registration_failed;

  /// No description provided for @cancel_registration.
  ///
  /// In en, this message translates to:
  /// **'Cancel Registration'**
  String get cancel_registration;

  /// No description provided for @register_now.
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get register_now;

  /// No description provided for @welcome_prefix.
  ///
  /// In en, this message translates to:
  /// **'Welcome,'**
  String get welcome_prefix;

  /// No description provided for @go_to_profile.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile'**
  String get go_to_profile;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @channels.
  ///
  /// In en, this message translates to:
  /// **'Channels'**
  String get channels;

  /// No description provided for @direct_messages.
  ///
  /// In en, this message translates to:
  /// **'Direct Messages'**
  String get direct_messages;

  /// No description provided for @start_new_chat.
  ///
  /// In en, this message translates to:
  /// **'Start New Chat'**
  String get start_new_chat;

  /// No description provided for @search_people.
  ///
  /// In en, this message translates to:
  /// **'Search people...'**
  String get search_people;

  /// No description provided for @no_contacts_found.
  ///
  /// In en, this message translates to:
  /// **'No contacts found'**
  String get no_contacts_found;

  /// No description provided for @no_matches_for.
  ///
  /// In en, this message translates to:
  /// **'No matches for {query}'**
  String no_matches_for(Object query);

  /// No description provided for @no_messages_yet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get no_messages_yet;

  /// No description provided for @no_channels_found.
  ///
  /// In en, this message translates to:
  /// **'No Channels Found'**
  String get no_channels_found;

  /// No description provided for @no_direct_messages.
  ///
  /// In en, this message translates to:
  /// **'No Direct Messages'**
  String get no_direct_messages;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @feature_coming_soon.
  ///
  /// In en, this message translates to:
  /// **'{feature} feature is coming soon!'**
  String feature_coming_soon(Object feature);

  /// No description provided for @say_hello.
  ///
  /// In en, this message translates to:
  /// **'No messages yet. Say hello!'**
  String get say_hello;

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading {filename}...'**
  String downloading(Object filename);

  /// No description provided for @my_assets.
  ///
  /// In en, this message translates to:
  /// **'My Assets'**
  String get my_assets;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String hello(Object name);

  /// No description provided for @active_assets_assigned.
  ///
  /// In en, this message translates to:
  /// **'{count} Active Assets Assigned'**
  String active_assets_assigned(Object count);

  /// No description provided for @no_assets_found.
  ///
  /// In en, this message translates to:
  /// **'No Assets Found'**
  String get no_assets_found;

  /// No description provided for @assets_assigned_desc.
  ///
  /// In en, this message translates to:
  /// **'Assets assigned to you will appear here.'**
  String get assets_assigned_desc;

  /// No description provided for @scrapped.
  ///
  /// In en, this message translates to:
  /// **'Scrapped'**
  String get scrapped;

  /// No description provided for @in_use.
  ///
  /// In en, this message translates to:
  /// **'In Use'**
  String get in_use;

  /// No description provided for @general_asset.
  ///
  /// In en, this message translates to:
  /// **'General Asset'**
  String get general_asset;

  /// No description provided for @asset_specifications.
  ///
  /// In en, this message translates to:
  /// **'Asset Specifications'**
  String get asset_specifications;

  /// No description provided for @maintenance_history.
  ///
  /// In en, this message translates to:
  /// **'Maintenance History'**
  String get maintenance_history;

  /// No description provided for @additional_notes.
  ///
  /// In en, this message translates to:
  /// **'Additional Notes'**
  String get additional_notes;

  /// No description provided for @logout_confirm_q.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logout_confirm_q;

  /// No description provided for @download_payslip.
  ///
  /// In en, this message translates to:
  /// **'Download Payslip'**
  String get download_payslip;

  /// No description provided for @payslip_downloaded.
  ///
  /// In en, this message translates to:
  /// **'{month} payslip downloaded'**
  String payslip_downloaded(Object month);

  /// No description provided for @tax_regime.
  ///
  /// In en, this message translates to:
  /// **'Tax Regime'**
  String get tax_regime;

  /// No description provided for @old_regime.
  ///
  /// In en, this message translates to:
  /// **'Old Regime'**
  String get old_regime;

  /// No description provided for @new_regime.
  ///
  /// In en, this message translates to:
  /// **'New Regime'**
  String get new_regime;

  /// No description provided for @salary_details.
  ///
  /// In en, this message translates to:
  /// **'Salary Details'**
  String get salary_details;

  /// No description provided for @annual_ctc.
  ///
  /// In en, this message translates to:
  /// **'Annual CTC'**
  String get annual_ctc;

  /// No description provided for @hra_received.
  ///
  /// In en, this message translates to:
  /// **'HRA Received'**
  String get hra_received;

  /// No description provided for @rent_paid_yearly.
  ///
  /// In en, this message translates to:
  /// **'Rent Paid (Yearly)'**
  String get rent_paid_yearly;

  /// No description provided for @deductions.
  ///
  /// In en, this message translates to:
  /// **'Deductions'**
  String get deductions;

  /// No description provided for @section_80c.
  ///
  /// In en, this message translates to:
  /// **'Section 80C'**
  String get section_80c;

  /// No description provided for @section_80d.
  ///
  /// In en, this message translates to:
  /// **'Section 80D'**
  String get section_80d;

  /// No description provided for @calculate_tax.
  ///
  /// In en, this message translates to:
  /// **'Calculate Tax'**
  String get calculate_tax;

  /// No description provided for @yearly_tax.
  ///
  /// In en, this message translates to:
  /// **'Yearly Tax'**
  String get yearly_tax;

  /// No description provided for @monthly_tds.
  ///
  /// In en, this message translates to:
  /// **'Monthly TDS'**
  String get monthly_tds;

  /// No description provided for @no_deadline.
  ///
  /// In en, this message translates to:
  /// **'No deadline'**
  String get no_deadline;

  /// No description provided for @no_client.
  ///
  /// In en, this message translates to:
  /// **'No client'**
  String get no_client;

  /// No description provided for @unknown_manager.
  ///
  /// In en, this message translates to:
  /// **'Unknown Manager'**
  String get unknown_manager;

  /// No description provided for @no_manager.
  ///
  /// In en, this message translates to:
  /// **'No manager'**
  String get no_manager;

  /// No description provided for @tasks_count.
  ///
  /// In en, this message translates to:
  /// **'{count} tasks'**
  String tasks_count(Object count);

  /// No description provided for @sessions_count.
  ///
  /// In en, this message translates to:
  /// **'{count} sessions'**
  String sessions_count(Object count);

  /// No description provided for @file_too_large.
  ///
  /// In en, this message translates to:
  /// **'File size exceeds the limit of 10 MB.'**
  String get file_too_large;

  /// No description provided for @search_projects.
  ///
  /// In en, this message translates to:
  /// **'Search projects...'**
  String get search_projects;

  /// No description provided for @no_projects_available.
  ///
  /// In en, this message translates to:
  /// **'No projects available'**
  String get no_projects_available;

  /// No description provided for @no_users_assigned.
  ///
  /// In en, this message translates to:
  /// **'No users assigned'**
  String get no_users_assigned;

  /// No description provided for @low_priority.
  ///
  /// In en, this message translates to:
  /// **'Low Priority'**
  String get low_priority;

  /// No description provided for @high_priority.
  ///
  /// In en, this message translates to:
  /// **'High Priority'**
  String get high_priority;

  /// No description provided for @normal_priority.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal_priority;

  /// No description provided for @status_label.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status_label;

  /// No description provided for @hours_label.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours_label;

  /// No description provided for @deadline_label.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get deadline_label;

  /// No description provided for @description_label.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description_label;

  /// No description provided for @search_tasks.
  ///
  /// In en, this message translates to:
  /// **'Search tasks...'**
  String get search_tasks;

  /// No description provided for @no_tasks_in_project.
  ///
  /// In en, this message translates to:
  /// **'No tasks in this project'**
  String get no_tasks_in_project;

  /// No description provided for @paid_by_employee.
  ///
  /// In en, this message translates to:
  /// **'Employee (to reimburse)'**
  String get paid_by_employee;

  /// No description provided for @paid_by_company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get paid_by_company;

  /// No description provided for @please_select_currency.
  ///
  /// In en, this message translates to:
  /// **'Please select a currency'**
  String get please_select_currency;

  /// No description provided for @creating_expense.
  ///
  /// In en, this message translates to:
  /// **'Creating expense...'**
  String get creating_expense;

  /// No description provided for @tax_planner.
  ///
  /// In en, this message translates to:
  /// **'Tax Planner'**
  String get tax_planner;

  /// No description provided for @projects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projects;

  /// No description provided for @current_password.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get current_password;

  /// No description provided for @please_enter_current_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter current password'**
  String get please_enter_current_password;

  /// No description provided for @folders.
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get folders;

  /// No description provided for @all_folders.
  ///
  /// In en, this message translates to:
  /// **'All Folders'**
  String get all_folders;

  /// No description provided for @search_placeholder_doc.
  ///
  /// In en, this message translates to:
  /// **'Search name, owner, contact...'**
  String get search_placeholder_doc;

  /// No description provided for @total_count_label.
  ///
  /// In en, this message translates to:
  /// **'{count} Total'**
  String total_count_label(Object count);

  /// No description provided for @no_documents_found.
  ///
  /// In en, this message translates to:
  /// **'No Documents Found'**
  String get no_documents_found;

  /// No description provided for @no_documents_matching.
  ///
  /// In en, this message translates to:
  /// **'There are no files or folders matching this query.'**
  String get no_documents_matching;

  /// No description provided for @archived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archived;

  /// No description provided for @type_label.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type_label;

  /// No description provided for @file_name.
  ///
  /// In en, this message translates to:
  /// **'File Name'**
  String get file_name;

  /// No description provided for @url_label.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get url_label;

  /// No description provided for @owner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get owner;

  /// No description provided for @folder.
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get folder;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @created_on.
  ///
  /// In en, this message translates to:
  /// **'Created On'**
  String get created_on;

  /// No description provided for @modified_on.
  ///
  /// In en, this message translates to:
  /// **'Modified On'**
  String get modified_on;

  /// No description provided for @open_label.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open_label;

  /// No description provided for @edit_details.
  ///
  /// In en, this message translates to:
  /// **'Edit Details'**
  String get edit_details;

  /// No description provided for @add_document.
  ///
  /// In en, this message translates to:
  /// **'Add Document'**
  String get add_document;

  /// No description provided for @upload_file.
  ///
  /// In en, this message translates to:
  /// **'Upload File'**
  String get upload_file;

  /// No description provided for @url_link.
  ///
  /// In en, this message translates to:
  /// **'URL Link'**
  String get url_link;

  /// No description provided for @choose_file.
  ///
  /// In en, this message translates to:
  /// **'Choose File'**
  String get choose_file;

  /// No description provided for @file_chosen.
  ///
  /// In en, this message translates to:
  /// **'File Chosen'**
  String get file_chosen;

  /// No description provided for @manage_payslips_declarations.
  ///
  /// In en, this message translates to:
  /// **'Manage your payslips & tax declarations'**
  String get manage_payslips_declarations;

  /// No description provided for @payslip_month.
  ///
  /// In en, this message translates to:
  /// **'Payslip Month'**
  String get payslip_month;

  /// No description provided for @no_active_contract_or_payslip.
  ///
  /// In en, this message translates to:
  /// **'No active contract or confirmed payslip found'**
  String get no_active_contract_or_payslip;

  /// No description provided for @payroll_services.
  ///
  /// In en, this message translates to:
  /// **'PAYROLL SERVICES'**
  String get payroll_services;

  /// No description provided for @income_tax_declarations.
  ///
  /// In en, this message translates to:
  /// **'Income Tax Declarations'**
  String get income_tax_declarations;

  /// No description provided for @income_tax_declarations_desc.
  ///
  /// In en, this message translates to:
  /// **'Submit investment proof and tax saving details'**
  String get income_tax_declarations_desc;

  /// No description provided for @payslip_download_desc.
  ///
  /// In en, this message translates to:
  /// **'Retrieve ZIP batches or monthly payslip PDFs'**
  String get payslip_download_desc;

  /// No description provided for @new_it_declaration.
  ///
  /// In en, this message translates to:
  /// **'New IT Declaration'**
  String get new_it_declaration;

  /// No description provided for @select_period_regime_info.
  ///
  /// In en, this message translates to:
  /// **'Select a period and tax regime to create your declaration.'**
  String get select_period_regime_info;

  /// No description provided for @payroll_period.
  ///
  /// In en, this message translates to:
  /// **'Payroll Period'**
  String get payroll_period;

  /// No description provided for @create_label.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create_label;

  /// No description provided for @download_option.
  ///
  /// In en, this message translates to:
  /// **'Download Option'**
  String get download_option;

  /// No description provided for @single_month_pdf.
  ///
  /// In en, this message translates to:
  /// **'Single Month (PDF)'**
  String get single_month_pdf;

  /// No description provided for @full_period_zip.
  ///
  /// In en, this message translates to:
  /// **'Full Period (ZIP)'**
  String get full_period_zip;

  /// No description provided for @estimated_pay.
  ///
  /// In en, this message translates to:
  /// **'ESTIMATED PAY'**
  String get estimated_pay;

  /// No description provided for @net_salary.
  ///
  /// In en, this message translates to:
  /// **'Net Salary'**
  String get net_salary;

  /// No description provided for @basic_pay.
  ///
  /// In en, this message translates to:
  /// **'Basic Pay'**
  String get basic_pay;

  /// No description provided for @allowance.
  ///
  /// In en, this message translates to:
  /// **'Allowance'**
  String get allowance;

  /// No description provided for @salary_structure_breakdown.
  ///
  /// In en, this message translates to:
  /// **'Salary Structure Breakdown'**
  String get salary_structure_breakdown;

  /// No description provided for @earnings.
  ///
  /// In en, this message translates to:
  /// **'EARNINGS'**
  String get earnings;

  /// No description provided for @take_home_salary.
  ///
  /// In en, this message translates to:
  /// **'Take Home Salary'**
  String get take_home_salary;

  /// No description provided for @house_rent_allowance.
  ///
  /// In en, this message translates to:
  /// **'House Rent Allowance (HRA)'**
  String get house_rent_allowance;

  /// No description provided for @conveyance_allowance.
  ///
  /// In en, this message translates to:
  /// **'Conveyance Allowance'**
  String get conveyance_allowance;

  /// No description provided for @professional_tax.
  ///
  /// In en, this message translates to:
  /// **'Professional Tax'**
  String get professional_tax;

  /// No description provided for @income_tax.
  ///
  /// In en, this message translates to:
  /// **'Income Tax'**
  String get income_tax;

  /// No description provided for @investment_overview.
  ///
  /// In en, this message translates to:
  /// **'Investment Overview'**
  String get investment_overview;

  /// No description provided for @declarations_label.
  ///
  /// In en, this message translates to:
  /// **'Declarations'**
  String get declarations_label;

  /// No description provided for @submitted_label.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get submitted_label;

  /// No description provided for @active_submissions.
  ///
  /// In en, this message translates to:
  /// **'Active Submissions'**
  String get active_submissions;

  /// No description provided for @no_it_declarations_found.
  ///
  /// In en, this message translates to:
  /// **'No IT Declarations found'**
  String get no_it_declarations_found;

  /// No description provided for @tap_plus_to_create.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to create one.'**
  String get tap_plus_to_create;

  /// No description provided for @investment_amount_inr.
  ///
  /// In en, this message translates to:
  /// **'Investment Amount (₹)'**
  String get investment_amount_inr;

  /// No description provided for @returned_label.
  ///
  /// In en, this message translates to:
  /// **'Returned'**
  String get returned_label;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @total_worked.
  ///
  /// In en, this message translates to:
  /// **'Total Worked'**
  String get total_worked;

  /// No description provided for @good_morning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get good_morning;

  /// No description provided for @good_afternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get good_afternoon;

  /// No description provided for @good_evening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get good_evening;

  /// No description provided for @ats_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get ats_home;

  /// No description provided for @ats_jobs.
  ///
  /// In en, this message translates to:
  /// **'Jobs'**
  String get ats_jobs;

  /// No description provided for @ats_applications.
  ///
  /// In en, this message translates to:
  /// **'Applications'**
  String get ats_applications;

  /// No description provided for @ats_candidates.
  ///
  /// In en, this message translates to:
  /// **'Candidates'**
  String get ats_candidates;

  /// No description provided for @ats_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get ats_profile;

  /// No description provided for @ats_open_roles.
  ///
  /// In en, this message translates to:
  /// **'Open roles'**
  String get ats_open_roles;

  /// No description provided for @ats_this_week.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get ats_this_week;

  /// No description provided for @ats_new_applications_came_in.
  ///
  /// In en, this message translates to:
  /// **'{count} new applications came in'**
  String ats_new_applications_came_in(num count);

  /// No description provided for @ats_recent_applications.
  ///
  /// In en, this message translates to:
  /// **'Recent Applications'**
  String get ats_recent_applications;

  /// No description provided for @ats_view_all.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get ats_view_all;

  /// No description provided for @ats_no_recent_applications.
  ///
  /// In en, this message translates to:
  /// **'No recent applications'**
  String get ats_no_recent_applications;

  /// No description provided for @ats_job_positions.
  ///
  /// In en, this message translates to:
  /// **'Job Positions'**
  String get ats_job_positions;

  /// No description provided for @ats_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search ...'**
  String get ats_search_hint;

  /// No description provided for @ats_no_jobs_found.
  ///
  /// In en, this message translates to:
  /// **'No job requisitions found'**
  String get ats_no_jobs_found;

  /// No description provided for @ats_tweak_filters.
  ///
  /// In en, this message translates to:
  /// **'Try tweaking your search or filters'**
  String get ats_tweak_filters;

  /// No description provided for @ats_recruitment.
  ///
  /// In en, this message translates to:
  /// **'Recruitment'**
  String get ats_recruitment;

  /// No description provided for @ats_candidates_folder.
  ///
  /// In en, this message translates to:
  /// **'Candidates Folder'**
  String get ats_candidates_folder;

  /// No description provided for @ats_search_candidate_hint.
  ///
  /// In en, this message translates to:
  /// **'Search name, degree, email, or skill...'**
  String get ats_search_candidate_hint;

  /// No description provided for @tab_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get tab_all;

  /// No description provided for @tab_new.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get tab_new;

  /// No description provided for @tab_screening.
  ///
  /// In en, this message translates to:
  /// **'Screening'**
  String get tab_screening;

  /// No description provided for @tab_first_interview.
  ///
  /// In en, this message translates to:
  /// **'First Interview'**
  String get tab_first_interview;

  /// No description provided for @tab_second_interview.
  ///
  /// In en, this message translates to:
  /// **'Second Interview'**
  String get tab_second_interview;

  /// No description provided for @tab_offered.
  ///
  /// In en, this message translates to:
  /// **'Offered'**
  String get tab_offered;

  /// No description provided for @tab_hired.
  ///
  /// In en, this message translates to:
  /// **'Hired'**
  String get tab_hired;

  /// No description provided for @tab_refused.
  ///
  /// In en, this message translates to:
  /// **'Refused'**
  String get tab_refused;

  /// No description provided for @tab_ij.
  ///
  /// In en, this message translates to:
  /// **'IJ'**
  String get tab_ij;

  /// No description provided for @tab_hr_stage.
  ///
  /// In en, this message translates to:
  /// **'HR Stage'**
  String get tab_hr_stage;

  /// No description provided for @tab_contract_proposal.
  ///
  /// In en, this message translates to:
  /// **'Contract Proposal'**
  String get tab_contract_proposal;

  /// No description provided for @tab_contract_signed.
  ///
  /// In en, this message translates to:
  /// **'Contract Signed'**
  String get tab_contract_signed;

  /// No description provided for @tab_published.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get tab_published;

  /// No description provided for @tab_unpublished.
  ///
  /// In en, this message translates to:
  /// **'Unpublished'**
  String get tab_unpublished;

  /// No description provided for @tab_ongoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get tab_ongoing;

  /// No description provided for @ats_no_candidates.
  ///
  /// In en, this message translates to:
  /// **'No candidates in this stage'**
  String get ats_no_candidates;

  /// No description provided for @ats_search_apps_hint.
  ///
  /// In en, this message translates to:
  /// **'Search subject, job, email, or candidate...'**
  String get ats_search_apps_hint;

  /// No description provided for @ats_candidate_prefix.
  ///
  /// In en, this message translates to:
  /// **'Candidate'**
  String get ats_candidate_prefix;

  /// No description provided for @ats_stage_prefix.
  ///
  /// In en, this message translates to:
  /// **'Stage'**
  String get ats_stage_prefix;

  /// No description provided for @ats_avail_prefix.
  ///
  /// In en, this message translates to:
  /// **'Avail'**
  String get ats_avail_prefix;

  /// No description provided for @ats_no_job_linked.
  ///
  /// In en, this message translates to:
  /// **'No job linked'**
  String get ats_no_job_linked;

  /// No description provided for @ats_unassigned.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get ats_unassigned;

  /// No description provided for @ats_no_applications_in_stage.
  ///
  /// In en, this message translates to:
  /// **'No applications in \'{stage}\' stage'**
  String ats_no_applications_in_stage(String stage);

  /// No description provided for @this_week.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get this_week;

  /// No description provided for @working_hours_logged.
  ///
  /// In en, this message translates to:
  /// **'Working hours logged'**
  String get working_hours_logged;

  /// No description provided for @duration_mins.
  ///
  /// In en, this message translates to:
  /// **'{minutes} mins'**
  String duration_mins(int minutes);

  /// No description provided for @duration_mins_one.
  ///
  /// In en, this message translates to:
  /// **'1 min'**
  String get duration_mins_one;

  /// No description provided for @duration_hours.
  ///
  /// In en, this message translates to:
  /// **'{hours} hrs'**
  String duration_hours(int hours);

  /// No description provided for @duration_hours_one.
  ///
  /// In en, this message translates to:
  /// **'1 hr'**
  String get duration_hours_one;

  /// No description provided for @duration_hours_mins.
  ///
  /// In en, this message translates to:
  /// **'{hours} hrs {minutes} mins'**
  String duration_hours_mins(int hours, int minutes);

  /// No description provided for @my_profile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get my_profile;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @not_specified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get not_specified;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @member_since.
  ///
  /// In en, this message translates to:
  /// **'Member Since'**
  String get member_since;

  /// No description provided for @designation.
  ///
  /// In en, this message translates to:
  /// **'Designation'**
  String get designation;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @applicationProfile.
  ///
  /// In en, this message translates to:
  /// **'Application Profile'**
  String get applicationProfile;

  /// No description provided for @ats_no_linked_position.
  ///
  /// In en, this message translates to:
  /// **'No Linked Position'**
  String get ats_no_linked_position;

  /// No description provided for @ats_stage.
  ///
  /// In en, this message translates to:
  /// **'Stage'**
  String get ats_stage;

  /// No description provided for @ats_availability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get ats_availability;

  /// No description provided for @ats_not_specified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get ats_not_specified;

  /// No description provided for @ats_info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get ats_info;

  /// No description provided for @ats_details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get ats_details;

  /// No description provided for @ats_additional_info.
  ///
  /// In en, this message translates to:
  /// **'Additional Info'**
  String get ats_additional_info;

  /// No description provided for @ats_notes_comments.
  ///
  /// In en, this message translates to:
  /// **'Notes & Comments'**
  String get ats_notes_comments;

  /// No description provided for @ats_candidate_identity.
  ///
  /// In en, this message translates to:
  /// **'Candidate Identity'**
  String get ats_candidate_identity;

  /// No description provided for @ats_candidate_name.
  ///
  /// In en, this message translates to:
  /// **'Candidate Name'**
  String get ats_candidate_name;

  /// No description provided for @ats_email_address.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get ats_email_address;

  /// No description provided for @ats_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get ats_phone_number;

  /// No description provided for @ats_linkedin_profile.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn Profile'**
  String get ats_linkedin_profile;

  /// No description provided for @ats_not_linked.
  ///
  /// In en, this message translates to:
  /// **'Not linked'**
  String get ats_not_linked;

  /// No description provided for @ats_salary_details.
  ///
  /// In en, this message translates to:
  /// **'Salary details'**
  String get ats_salary_details;

  /// No description provided for @ats_current_ctc.
  ///
  /// In en, this message translates to:
  /// **'Current CTC'**
  String get ats_current_ctc;

  /// No description provided for @ats_expected_salary.
  ///
  /// In en, this message translates to:
  /// **'Expected Salary'**
  String get ats_expected_salary;

  /// No description provided for @ats_proposed_salary.
  ///
  /// In en, this message translates to:
  /// **'Proposed Salary'**
  String get ats_proposed_salary;

  /// No description provided for @ats_salary_negotiable.
  ///
  /// In en, this message translates to:
  /// **'Salary Negotiable'**
  String get ats_salary_negotiable;

  /// No description provided for @ats_yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get ats_yes;

  /// No description provided for @ats_no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get ats_no;

  /// No description provided for @ats_experience_details.
  ///
  /// In en, this message translates to:
  /// **'Experience details'**
  String get ats_experience_details;

  /// No description provided for @ats_total_experience.
  ///
  /// In en, this message translates to:
  /// **'Total Experience'**
  String get ats_total_experience;

  /// No description provided for @ats_relevant_experience.
  ///
  /// In en, this message translates to:
  /// **'Relevant Experience'**
  String get ats_relevant_experience;

  /// No description provided for @ats_notice_period.
  ///
  /// In en, this message translates to:
  /// **'Notice Period'**
  String get ats_notice_period;

  /// No description provided for @ats_np_negotiable.
  ///
  /// In en, this message translates to:
  /// **'NP Negotiable'**
  String get ats_np_negotiable;

  /// No description provided for @ats_holding_offer.
  ///
  /// In en, this message translates to:
  /// **'Holding Offer'**
  String get ats_holding_offer;

  /// No description provided for @ats_recruitment_assignments.
  ///
  /// In en, this message translates to:
  /// **'Recruitment Assignments'**
  String get ats_recruitment_assignments;

  /// No description provided for @ats_recruiter_handler.
  ///
  /// In en, this message translates to:
  /// **'Recruiter / Handler'**
  String get ats_recruiter_handler;

  /// No description provided for @ats_job_position.
  ///
  /// In en, this message translates to:
  /// **'Job Position'**
  String get ats_job_position;

  /// No description provided for @ats_experience_type.
  ///
  /// In en, this message translates to:
  /// **'Experience Type'**
  String get ats_experience_type;

  /// No description provided for @ats_company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get ats_company;

  /// No description provided for @ats_bio_details.
  ///
  /// In en, this message translates to:
  /// **'Bio details'**
  String get ats_bio_details;

  /// No description provided for @ats_gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get ats_gender;

  /// No description provided for @ats_birthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get ats_birthday;

  /// No description provided for @ats_blood_group.
  ///
  /// In en, this message translates to:
  /// **'Blood Group'**
  String get ats_blood_group;

  /// No description provided for @ats_marital_status.
  ///
  /// In en, this message translates to:
  /// **'Marital Status'**
  String get ats_marital_status;

  /// No description provided for @ats_contact_addresses.
  ///
  /// In en, this message translates to:
  /// **'Contact Addresses'**
  String get ats_contact_addresses;

  /// No description provided for @ats_current_address.
  ///
  /// In en, this message translates to:
  /// **'Current Address'**
  String get ats_current_address;

  /// No description provided for @ats_permanent_address.
  ///
  /// In en, this message translates to:
  /// **'Permanent Address'**
  String get ats_permanent_address;

  /// No description provided for @ats_applicant_comments.
  ///
  /// In en, this message translates to:
  /// **'Applicant Comments'**
  String get ats_applicant_comments;

  /// No description provided for @ats_recruiter_comments.
  ///
  /// In en, this message translates to:
  /// **'Recruiter Comments'**
  String get ats_recruiter_comments;

  /// No description provided for @ats_general_notes.
  ///
  /// In en, this message translates to:
  /// **'General Notes'**
  String get ats_general_notes;

  /// No description provided for @ats_no_records_provided.
  ///
  /// In en, this message translates to:
  /// **'No records provided.'**
  String get ats_no_records_provided;

  /// No description provided for @ats_applied_on.
  ///
  /// In en, this message translates to:
  /// **'Applied On'**
  String get ats_applied_on;

  /// No description provided for @ats_job_documents.
  ///
  /// In en, this message translates to:
  /// **'Job Documents'**
  String get ats_job_documents;

  /// No description provided for @ats_no_documents_found.
  ///
  /// In en, this message translates to:
  /// **'No documents found for this job position.'**
  String get ats_no_documents_found;

  /// No description provided for @ats_primary_skills_required.
  ///
  /// In en, this message translates to:
  /// **'Primary Skills Required'**
  String get ats_primary_skills_required;

  /// No description provided for @ats_secondary_skills_required.
  ///
  /// In en, this message translates to:
  /// **'Secondary Skills Required'**
  String get ats_secondary_skills_required;

  /// No description provided for @ats_job_description.
  ///
  /// In en, this message translates to:
  /// **'Job Description'**
  String get ats_job_description;

  /// No description provided for @ats_key_responsibilities.
  ///
  /// In en, this message translates to:
  /// **'Key Responsibilities'**
  String get ats_key_responsibilities;

  /// No description provided for @ats_minimum_requirements.
  ///
  /// In en, this message translates to:
  /// **'Minimum Requirements'**
  String get ats_minimum_requirements;

  /// No description provided for @ats_job_directory_summary.
  ///
  /// In en, this message translates to:
  /// **'Job Directory Summary'**
  String get ats_job_directory_summary;

  /// No description provided for @ats_experience_required.
  ///
  /// In en, this message translates to:
  /// **'Experience Required'**
  String get ats_experience_required;

  /// No description provided for @ats_budget_salary.
  ///
  /// In en, this message translates to:
  /// **'Budget / Salary'**
  String get ats_budget_salary;

  /// No description provided for @ats_employment_type.
  ///
  /// In en, this message translates to:
  /// **'Employment Type'**
  String get ats_employment_type;

  /// No description provided for @ats_full_time.
  ///
  /// In en, this message translates to:
  /// **'Full-time'**
  String get ats_full_time;

  /// No description provided for @ats_status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get ats_status;

  /// No description provided for @ats_published.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get ats_published;

  /// No description provided for @ats_draft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get ats_draft;

  /// No description provided for @ats_priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get ats_priority;

  /// No description provided for @ats_not_spec.
  ///
  /// In en, this message translates to:
  /// **'Not Spec'**
  String get ats_not_spec;

  /// No description provided for @ats_candidate_profile.
  ///
  /// In en, this message translates to:
  /// **'Candidate Profile'**
  String get ats_candidate_profile;

  /// No description provided for @ats_contact_bio.
  ///
  /// In en, this message translates to:
  /// **'Contact & Bio'**
  String get ats_contact_bio;

  /// No description provided for @ats_skills_meta.
  ///
  /// In en, this message translates to:
  /// **'Skills & Meta'**
  String get ats_skills_meta;

  /// No description provided for @ats_primary_contact.
  ///
  /// In en, this message translates to:
  /// **'Primary Contact'**
  String get ats_primary_contact;

  /// No description provided for @ats_mobile_phone.
  ///
  /// In en, this message translates to:
  /// **'Mobile Phone'**
  String get ats_mobile_phone;

  /// No description provided for @ats_alternate_phone.
  ///
  /// In en, this message translates to:
  /// **'Alternate Phone'**
  String get ats_alternate_phone;

  /// No description provided for @ats_not_provided.
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get ats_not_provided;

  /// No description provided for @ats_recruitment_information.
  ///
  /// In en, this message translates to:
  /// **'Recruitment Information'**
  String get ats_recruitment_information;

  /// No description provided for @ats_contact_partner_name.
  ///
  /// In en, this message translates to:
  /// **'Contact Partner Name'**
  String get ats_contact_partner_name;

  /// No description provided for @ats_candidate_manager.
  ///
  /// In en, this message translates to:
  /// **'Candidate Manager'**
  String get ats_candidate_manager;

  /// No description provided for @ats_odoo_company.
  ///
  /// In en, this message translates to:
  /// **'Odoo Company'**
  String get ats_odoo_company;

  /// No description provided for @ats_candidate_status_info.
  ///
  /// In en, this message translates to:
  /// **'Candidate Status Info'**
  String get ats_candidate_status_info;

  /// No description provided for @ats_availability_date.
  ///
  /// In en, this message translates to:
  /// **'Availability Date'**
  String get ats_availability_date;

  /// No description provided for @ats_recruitment_stage.
  ///
  /// In en, this message translates to:
  /// **'Recruitment Stage'**
  String get ats_recruitment_stage;

  /// No description provided for @ats_odoo_skills_list.
  ///
  /// In en, this message translates to:
  /// **'Odoo Skills List'**
  String get ats_odoo_skills_list;

  /// No description provided for @ats_no_skills_mapped.
  ///
  /// In en, this message translates to:
  /// **'No skills mapped for this candidate yet.'**
  String get ats_no_skills_mapped;

  /// No description provided for @ats_download_resume.
  ///
  /// In en, this message translates to:
  /// **'Download Resume'**
  String get ats_download_resume;

  /// No description provided for @ats_type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get ats_type;

  /// No description provided for @help_desk.
  ///
  /// In en, this message translates to:
  /// **'Help Desk'**
  String get help_desk;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'te', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'te':
      return AppLocalizationsTe();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
