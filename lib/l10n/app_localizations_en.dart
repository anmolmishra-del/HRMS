// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcome_title => 'Welcome to\nOpzento HR';

  @override
  String get welcome_subtitle =>
      'Experience a seamless way to manage all your HR tasks in one place.';

  @override
  String get login => 'Login';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get remember_me => 'Remember me';

  @override
  String get forgot_password => 'Forgot?';

  @override
  String get sign_in => 'SIGN IN';

  @override
  String get skip => 'Skip';

  @override
  String get next_step => 'Next Step';

  @override
  String get get_started => 'Get Started';

  @override
  String get attendance_payroll => 'Attendance &\nPayroll Made Easy';

  @override
  String get attendance_payroll_subtitle =>
      'Monitor your attendance and manage payroll with precision and ease.';

  @override
  String get sign_in_continue => 'Sign in to continue';

  @override
  String get powered_by => 'POWERED BY';

  @override
  String get language => 'Language';

  @override
  String get error_empty_fields => 'Please enter username and password';

  @override
  String get error_enter_username => 'Please enter username';

  @override
  String get error_enter_password => 'Please enter password';

  @override
  String get personal_details => 'Personal Details';

  @override
  String get personal_information => 'Personal Information';

  @override
  String get employee_code => 'Employee Code';

  @override
  String get full_name => 'Full Name';

  @override
  String get gender => 'Gender';

  @override
  String get date_of_birth => 'Date of Birth';

  @override
  String get marital_status => 'Marital Status';

  @override
  String get blood_group => 'Blood Group';

  @override
  String get identification_id => 'Identification ID';

  @override
  String get passport_no => 'Passport No';

  @override
  String get aadhar_no => 'Aadhar No';

  @override
  String get pan_no => 'PAN No';

  @override
  String get work_information => 'Work Information';

  @override
  String get job_title => 'Job Title';

  @override
  String get department => 'Department';

  @override
  String get work_location => 'Work Location';

  @override
  String get manager => 'Manager';

  @override
  String get date_of_joining => 'Date of Joining';

  @override
  String get work_email => 'Work Email';

  @override
  String get work_phone => 'Work Phone';

  @override
  String get employment_type => 'Employment Type';

  @override
  String get emergency_contact => 'Emergency Contact';

  @override
  String get contact_name => 'Contact Name';

  @override
  String get contact_phone => 'Contact Phone';

  @override
  String get bank_details => 'Bank Details';

  @override
  String get bank_name => 'Bank Name';

  @override
  String get ifsc_code => 'IFSC Code';

  @override
  String get account_id => 'Account ID';

  @override
  String get address => 'Address';

  @override
  String get residential_address => 'Residential Address';

  @override
  String get permanent_address => 'Permanent Address';

  @override
  String get employee => 'Employee';

  @override
  String get time => 'Time';

  @override
  String get date => 'Date';

  @override
  String get working_hours => 'Working Hours';

  @override
  String get check_in => 'Check In';

  @override
  String get check_out => 'Check Out';

  @override
  String get checking_in => 'Checking In...';

  @override
  String get checking_out => 'Checking Out...';

  @override
  String get checked_in_success => 'Checked in successfully';

  @override
  String get checked_out_success => 'Checked out successfully';

  @override
  String get session_expired => 'Session expired';

  @override
  String get session_expired_relogin =>
      'Your password has been changed successfully. Please log in again with your new password.';

  @override
  String get okay => 'Okay';

  @override
  String get session_info_missing => 'Session info missing';

  @override
  String get attendance_report => 'Attendance Report';

  @override
  String get inout_report => 'In/Out Report';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get completed => 'Completed';

  @override
  String get still_working => 'Still Working';

  @override
  String get in_label => 'In';

  @override
  String get out => 'Out';

  @override
  String get break_time => 'Break';

  @override
  String get overtime => 'Overtime';

  @override
  String get validated_overtime => 'Validated OT';

  @override
  String get session_label => 'Session';

  @override
  String get session_timeline => 'Session Timeline';

  @override
  String get no_gps_location => 'No GPS Location';

  @override
  String get session_active => 'Session Active';

  @override
  String get sessions_label => 'Sessions';

  @override
  String get location => 'Location';

  @override
  String get no_records_found => 'No records found for this period';

  @override
  String get company => 'Company';

  @override
  String get coach => 'Coach';

  @override
  String get no_employee_data_found => 'No employee data found';

  @override
  String get employee_id => 'Employee ID';

  @override
  String get top_skills => 'Top Skills';

  @override
  String get quick_actions => 'Quick Actions';

  @override
  String get job_details => 'Job Details';

  @override
  String get leave_balance => 'Leave Balance';

  @override
  String get holidays_calendar => 'Holidays Calendar';

  @override
  String get reimbursements => 'Reimbursements';

  @override
  String get training_learning => 'Training & Learning';

  @override
  String get assets_assigned => 'Assets Assigned';

  @override
  String get resume_experience => 'Resume & Experience';

  @override
  String get preferences => 'Preferences';

  @override
  String get notifications => 'Notifications';

  @override
  String get dark_mode => 'Dark Mode';

  @override
  String get security => 'Security';

  @override
  String get change_password => 'Change Password';

  @override
  String get logout => 'Logout';

  @override
  String get security_settings => 'Security Settings';

  @override
  String get enter_new_password_info =>
      'Please enter your new password below. Make sure it\'s strong and secure.';

  @override
  String get new_password => 'New Password';

  @override
  String get confirm_password => 'Confirm Password';

  @override
  String get passwords_do_not_match => 'Passwords do not match';

  @override
  String get update_password => 'Update Password';

  @override
  String get cancel => 'Cancel';

  @override
  String please_enter(Object field) {
    return 'Please enter $field';
  }

  @override
  String get password_min_length => 'Password must be at least 4 characters';

  @override
  String get password_updated_success => 'Password Updated Successfully';

  @override
  String get failed_to_update_password => 'Failed to update password';

  @override
  String selected_year(Object year) {
    return 'Selected Year: $year';
  }

  @override
  String get search_holidays => 'Search holidays...';

  @override
  String no_holidays_found(Object year) {
    return 'No holidays found for $year.';
  }

  @override
  String get employee_details => 'Employee Details';

  @override
  String get personal => 'Personal';

  @override
  String get work_bank => 'Work & Bank';

  @override
  String get contact_information => 'Contact Information';

  @override
  String get mobile => 'Mobile';

  @override
  String get birthday => 'Birthday';

  @override
  String get documentation => 'Documentation';

  @override
  String get passport_id => 'Passport ID';

  @override
  String get addresses => 'Addresses';

  @override
  String get current_address => 'Current Address';

  @override
  String get employment_details => 'Employment Details';

  @override
  String get reporting_manager => 'Reporting Manager';

  @override
  String get bank_information => 'Bank Information';

  @override
  String get account_number => 'Account Number';

  @override
  String get select_your_language => 'Select Your Language';

  @override
  String get choose_language_info =>
      'Choose the language you prefer for the app interface.';

  @override
  String get total_leave => 'Total Leave';

  @override
  String get taken => 'Taken';

  @override
  String get remaining => 'Remaining';

  @override
  String get sick_leave => 'Sick Leave';

  @override
  String get book_leave => 'Book Leave';

  @override
  String get report_sick => 'Report Sick';

  @override
  String get contact_hr => 'Contact HR';

  @override
  String get recent_activity => 'Recent Activity';

  @override
  String get view_all => 'View all';

  @override
  String get annual_leave => 'Annual Leave';

  @override
  String get reimbursement => 'Reimbursement';

  @override
  String get total_expenses => 'Total Expenses';

  @override
  String get pending => 'Pending';

  @override
  String get rejected => 'Rejected';

  @override
  String get verified => 'Verified';

  @override
  String get my_expenses => 'My Expenses';

  @override
  String get no_reimbursement_found => 'No reimbursement records found.';

  @override
  String get submit_label => 'SUBMIT';

  @override
  String get paid => 'PAID';

  @override
  String get submitted => 'SUBMITTED';

  @override
  String get approved => 'APPROVED';

  @override
  String get refused => 'REFUSED';

  @override
  String get draft => 'DRAFT';

  @override
  String get new_expense => 'New Expense';

  @override
  String get general_information => 'General Information';

  @override
  String get expense_title => 'Description (Expense Title)';

  @override
  String get category => 'Category';

  @override
  String get amount_taxes => 'Amount & Taxes';

  @override
  String get total_amount => 'Total Amount';

  @override
  String get currency => 'Currency';

  @override
  String get included_taxes => 'Included Taxes';

  @override
  String get tax_amount => 'Tax Amount';

  @override
  String get payment_date => 'Payment & Date';

  @override
  String get paid_by => 'Paid By';

  @override
  String get vendor => 'Vendor';

  @override
  String get expense_date => 'Expense Date';

  @override
  String get internal_notes => 'Internal Notes';

  @override
  String get supporting_documents => 'Supporting Documents';

  @override
  String get attach_receipt => 'Attach Receipt / Bill';

  @override
  String get no_file_selected => 'No file selected';

  @override
  String get create_expense => 'CREATE EXPENSE';

  @override
  String get required_field => 'Required';

  @override
  String get please_select_category => 'Please select a category';

  @override
  String get expense_created_success => 'Expense created successfully';

  @override
  String get fill_required_fields =>
      'Please fill in all required fields correctly';

  @override
  String get performance_review_title => 'Employee Performance Review';

  @override
  String get performance_ratings => 'Performance Ratings';

  @override
  String get managers_comments => 'Manager\'s Comments';

  @override
  String get review_summary => 'Review Summary';

  @override
  String get overall_rating_label => 'Overall Rating';

  @override
  String get goals_achieved => 'Goals Achieved';

  @override
  String get previous_reviews => 'Previous Reviews';

  @override
  String get download_pdf => 'Download PDF';

  @override
  String get submit_review => 'Submit Review';

  @override
  String get search_courses => 'Search courses...';

  @override
  String get categories => 'Categories';

  @override
  String get ongoing_training => 'Ongoing Training';

  @override
  String get trainer => 'Trainer';

  @override
  String get learning_timeline => 'Learning Timeline';

  @override
  String get lesson => 'Lesson';

  @override
  String get locked => 'Locked';

  @override
  String get development => 'Development';

  @override
  String get design => 'Design';

  @override
  String get management => 'Management';

  @override
  String get soft_skills => 'Soft Skills';

  @override
  String get leave_list => 'Leave List';

  @override
  String get leaves => 'Leaves';

  @override
  String get my_pay => 'My Pay';

  @override
  String get apply_leave => 'Apply Leave';

  @override
  String get leave_type => 'Leave Type';

  @override
  String get start_date => 'Start Date';

  @override
  String get end_date => 'End Date';

  @override
  String get reason => 'Reason';

  @override
  String get ai_chat_bot => 'AI Chat Bot';

  @override
  String get ask_me_anything => 'Ask me anything...';

  @override
  String get company_calendar => 'Company Calendar';

  @override
  String get doc_box => 'Doc Box';

  @override
  String get search_documents => 'Search documents...';

  @override
  String get new_equipment => 'New Equipment';

  @override
  String get equipment_name => 'Equipment Name';

  @override
  String get serial_number => 'Serial Number';

  @override
  String get events_list => 'Events';

  @override
  String get event_details => 'Event Details';

  @override
  String get search_events => 'Search events...';

  @override
  String get chat_list => 'Chats';

  @override
  String get search_chats => 'Search chats...';

  @override
  String get type_a_message => 'Type a message...';

  @override
  String get all => 'All';

  @override
  String get unread => 'Unread';

  @override
  String get read => 'Read';

  @override
  String new_notifications_count(Object count) {
    return '$count New Notifications';
  }

  @override
  String get all_caught_up => 'All caught up!';

  @override
  String get no_notifications => 'You have no new notifications.';

  @override
  String delivery_failed(Object reason) {
    return 'Delivery Failed: $reason';
  }

  @override
  String get failure_details => 'Failure Details';

  @override
  String get my_time_off => 'My Time Off';

  @override
  String get request_leave => 'Request Leave';

  @override
  String get no_leave_records => 'No Leave Records';

  @override
  String get leave_history_info =>
      'Your leave history will appear here\nonce you submit your first request.';

  @override
  String get days_available => 'Days Available';

  @override
  String get delete_draft => 'Delete Draft';

  @override
  String get cancel_leave => 'Cancel Leave';

  @override
  String get cancel_request_q => 'Cancel Request?';

  @override
  String get cancel_request_confirm =>
      'Are you sure you want to cancel this leave request?';

  @override
  String get no => 'No';

  @override
  String get yes_cancel => 'Yes, Cancel';

  @override
  String get delete_draft_q => 'Delete Draft?';

  @override
  String get delete_draft_confirm => 'This draft will be permanently removed.';

  @override
  String get delete => 'Delete';

  @override
  String get request_time_off => 'Request Time Off';

  @override
  String get date_duration => 'Date & Duration';

  @override
  String get additional_details => 'Additional Details';

  @override
  String get select_leave_type => 'Select leave type';

  @override
  String get half_day => 'Half Day';

  @override
  String get morning_am => 'Morning (AM)';

  @override
  String get afternoon_pm => 'Afternoon (PM)';

  @override
  String get reason_time_off_hint => 'Reason for time off...';

  @override
  String get submit_request => 'Submit Request';

  @override
  String get end_date_error => 'End date cannot be before start date';

  @override
  String insufficient_balance(Object available, Object requested) {
    return 'Insufficient balance. You requested $requested days but only have $available days available.';
  }

  @override
  String get please_select_leave_type => 'Please select a leave type';

  @override
  String get bot_welcome =>
      'Hello 👋 I\'m your HR Assistant. How can I help you today?';

  @override
  String get ai_hr_assistant => 'AI HR Assistant';

  @override
  String get type_message => 'Type your message...';

  @override
  String get add_event => 'Add Event';

  @override
  String get event_title => 'Event Title';

  @override
  String get event => 'Event';

  @override
  String get holiday => 'Holiday';

  @override
  String get type => 'Type';

  @override
  String get save => 'Save';

  @override
  String events_on(Object date) {
    return 'Events on $date';
  }

  @override
  String get no_events => 'No Events';

  @override
  String get company_docs => 'Company Docs';

  @override
  String get personal_docs => 'Personal Docs';

  @override
  String get upload => 'Upload';

  @override
  String get no_documents => 'No Documents Available';

  @override
  String uploaded_on(Object date) {
    return 'Uploaded on $date';
  }

  @override
  String get leave_management => 'Leave Management';

  @override
  String get view => 'View';

  @override
  String get download => 'Download';

  @override
  String get total_days => 'Total Days';

  @override
  String get days => 'Days';

  @override
  String get submit => 'Submit';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get general => 'General';

  @override
  String get description => 'Description';

  @override
  String get product_info => 'Product Info';

  @override
  String get maintenance => 'Maintenance';

  @override
  String get equipment_created_success => 'Equipment created successfully';

  @override
  String get assigned_department => 'Assigned Department';

  @override
  String get assigned_employee => 'Assigned Employee';

  @override
  String get team => 'Team';

  @override
  String get technician => 'Technician';

  @override
  String get scrap_date => 'Scrap Date';

  @override
  String get note => 'Note';

  @override
  String get vendor_reference => 'Vendor Reference';

  @override
  String get model => 'Model';

  @override
  String get mfg_serial_number => 'Mfg. Serial Number';

  @override
  String get inventory_serial_number => 'Inventory Serial Number';

  @override
  String get effective_date => 'Effective Date';

  @override
  String get cost => 'Cost';

  @override
  String get warranty_expiration_date => 'Warranty Expiration Date';

  @override
  String get expected_mtbf => 'Expected MTBF';

  @override
  String get mean_time_between_failure => 'Mean Time Between Failure';

  @override
  String get estimated_next_failure => 'Estimated Next Failure';

  @override
  String get latest_failure => 'Latest Failure';

  @override
  String get mean_time_to_repair => 'Mean Time To Repair';

  @override
  String get used_by => 'Used By';

  @override
  String get other => 'Other';

  @override
  String get select_date => 'Select Date';

  @override
  String get save_equipment => 'Save Equipment';

  @override
  String error_message(Object error) {
    return 'Error: $error';
  }

  @override
  String get company_events => 'Company Events';

  @override
  String get no_upcoming_events => 'No Upcoming Events';

  @override
  String get check_back_later_events =>
      'Check back later for new company events!';

  @override
  String get something_went_wrong => 'Oops! Something went wrong';

  @override
  String get unexpected_error => 'An unexpected error occurred';

  @override
  String get company_venue => 'Company Venue';

  @override
  String seats_left(Object count) {
    return '$count Seats Left';
  }

  @override
  String get open_registration => 'Open Registration';

  @override
  String get registered => 'Registered';

  @override
  String get view_details => 'View Details';

  @override
  String get about_event => 'About Event';

  @override
  String get important_instructions => 'Important Instructions';

  @override
  String get select_ticket => 'Select Ticket';

  @override
  String get tap_view_map => 'Tap to view on map';

  @override
  String get host_contact_person => 'Host / Contact Person';

  @override
  String get left => 'Left';

  @override
  String get cancelling_registration => 'Cancelling registration...';

  @override
  String get registration_cancelled_success =>
      'Registration cancelled successfully.';

  @override
  String get failed_cancel_registration => 'Failed to cancel registration.';

  @override
  String get please_select_ticket_first => 'Please select a ticket first.';

  @override
  String get registering_event => 'Registering for event...';

  @override
  String get successfully_registered => 'Successfully registered!';

  @override
  String get registration_failed => 'Registration failed.';

  @override
  String get cancel_registration => 'Cancel Registration';

  @override
  String get register_now => 'Register Now';

  @override
  String get welcome_prefix => 'Welcome,';

  @override
  String get go_to_profile => 'Go to Profile';

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get chat => 'Chat';

  @override
  String get messages => 'Messages';

  @override
  String get channels => 'Channels';

  @override
  String get direct_messages => 'Direct Messages';

  @override
  String get start_new_chat => 'Start New Chat';

  @override
  String get search_people => 'Search people...';

  @override
  String get no_contacts_found => 'No contacts found';

  @override
  String no_matches_for(Object query) {
    return 'No matches for $query';
  }

  @override
  String get no_messages_yet => 'No messages yet';

  @override
  String get no_channels_found => 'No Channels Found';

  @override
  String get no_direct_messages => 'No Direct Messages';

  @override
  String get offline => 'Offline';

  @override
  String get online => 'Online';

  @override
  String feature_coming_soon(Object feature) {
    return '$feature feature is coming soon!';
  }

  @override
  String get say_hello => 'No messages yet. Say hello!';

  @override
  String downloading(Object filename) {
    return 'Downloading $filename...';
  }

  @override
  String get my_assets => 'My Assets';

  @override
  String hello(Object name) {
    return 'Hello, $name';
  }

  @override
  String active_assets_assigned(Object count) {
    return '$count Active Assets Assigned';
  }

  @override
  String get no_assets_found => 'No Assets Found';

  @override
  String get assets_assigned_desc => 'Assets assigned to you will appear here.';

  @override
  String get scrapped => 'Scrapped';

  @override
  String get in_use => 'In Use';

  @override
  String get general_asset => 'General Asset';

  @override
  String get asset_specifications => 'Asset Specifications';

  @override
  String get maintenance_history => 'Maintenance History';

  @override
  String get additional_notes => 'Additional Notes';

  @override
  String get logout_confirm_q => 'Are you sure you want to logout?';

  @override
  String get download_payslip => 'Download Payslip';

  @override
  String payslip_downloaded(Object month) {
    return '$month payslip downloaded';
  }

  @override
  String get tax_regime => 'Tax Regime';

  @override
  String get old_regime => 'Old Regime';

  @override
  String get new_regime => 'New Regime';

  @override
  String get salary_details => 'Salary Details';

  @override
  String get annual_ctc => 'Annual CTC';

  @override
  String get hra_received => 'HRA Received';

  @override
  String get rent_paid_yearly => 'Rent Paid (Yearly)';

  @override
  String get deductions => 'Deductions';

  @override
  String get section_80c => 'Section 80C';

  @override
  String get section_80d => 'Section 80D';

  @override
  String get calculate_tax => 'Calculate Tax';

  @override
  String get yearly_tax => 'Yearly Tax';

  @override
  String get monthly_tds => 'Monthly TDS';

  @override
  String get no_deadline => 'No deadline';

  @override
  String get no_client => 'No client';

  @override
  String get unknown_manager => 'Unknown Manager';

  @override
  String get no_manager => 'No manager';

  @override
  String tasks_count(Object count) {
    return '$count tasks';
  }

  @override
  String sessions_count(Object count) {
    return '$count sessions';
  }

  @override
  String get file_too_large => 'File size exceeds the limit of 10 MB.';

  @override
  String get search_projects => 'Search projects...';

  @override
  String get no_projects_available => 'No projects available';

  @override
  String get no_users_assigned => 'No users assigned';

  @override
  String get low_priority => 'Low Priority';

  @override
  String get high_priority => 'High Priority';

  @override
  String get normal_priority => 'Normal';

  @override
  String get status_label => 'Status';

  @override
  String get hours_label => 'Hours';

  @override
  String get deadline_label => 'Deadline';

  @override
  String get description_label => 'Description';

  @override
  String get search_tasks => 'Search tasks...';

  @override
  String get no_tasks_in_project => 'No tasks in this project';

  @override
  String get paid_by_employee => 'Employee (to reimburse)';

  @override
  String get paid_by_company => 'Company';

  @override
  String get please_select_currency => 'Please select a currency';

  @override
  String get creating_expense => 'Creating expense...';

  @override
  String get tax_planner => 'Tax Planner';

  @override
  String get projects => 'Projects';

  @override
  String get current_password => 'Current Password';

  @override
  String get please_enter_current_password => 'Please enter current password';

  @override
  String get folders => 'Folders';

  @override
  String get all_folders => 'All Folders';

  @override
  String get search_placeholder_doc => 'Search name, owner, contact...';

  @override
  String total_count_label(Object count) {
    return '$count Total';
  }

  @override
  String get no_documents_found => 'No Documents Found';

  @override
  String get no_documents_matching =>
      'There are no files or folders matching this query.';

  @override
  String get archived => 'Archived';

  @override
  String get type_label => 'Type';

  @override
  String get file_name => 'File Name';

  @override
  String get url_label => 'URL';

  @override
  String get owner => 'Owner';

  @override
  String get folder => 'Folder';

  @override
  String get contact => 'Contact';

  @override
  String get created_on => 'Created On';

  @override
  String get modified_on => 'Modified On';

  @override
  String get open_label => 'Open';

  @override
  String get edit_details => 'Edit Details';

  @override
  String get add_document => 'Add Document';

  @override
  String get upload_file => 'Upload File';

  @override
  String get url_link => 'URL Link';

  @override
  String get choose_file => 'Choose File';

  @override
  String get file_chosen => 'File Chosen';

  @override
  String get manage_payslips_declarations =>
      'Manage your payslips & tax declarations';

  @override
  String get payslip_month => 'Payslip Month';

  @override
  String get no_active_contract_or_payslip =>
      'No active contract or confirmed payslip found';

  @override
  String get payroll_services => 'PAYROLL SERVICES';

  @override
  String get income_tax_declarations => 'Income Tax Declarations';

  @override
  String get income_tax_declarations_desc =>
      'Submit investment proof and tax saving details';

  @override
  String get payslip_download_desc =>
      'Retrieve ZIP batches or monthly payslip PDFs';

  @override
  String get new_it_declaration => 'New IT Declaration';

  @override
  String get select_period_regime_info =>
      'Select a period and tax regime to create your declaration.';

  @override
  String get payroll_period => 'Payroll Period';

  @override
  String get create_label => 'Create';

  @override
  String get download_option => 'Download Option';

  @override
  String get single_month_pdf => 'Single Month (PDF)';

  @override
  String get full_period_zip => 'Full Period (ZIP)';

  @override
  String get estimated_pay => 'ESTIMATED PAY';

  @override
  String get net_salary => 'Net Salary';

  @override
  String get basic_pay => 'Basic Pay';

  @override
  String get allowance => 'Allowance';

  @override
  String get salary_structure_breakdown => 'Salary Structure Breakdown';

  @override
  String get earnings => 'EARNINGS';

  @override
  String get take_home_salary => 'Take Home Salary';

  @override
  String get house_rent_allowance => 'House Rent Allowance (HRA)';

  @override
  String get conveyance_allowance => 'Conveyance Allowance';

  @override
  String get professional_tax => 'Professional Tax';

  @override
  String get income_tax => 'Income Tax';

  @override
  String get investment_overview => 'Investment Overview';

  @override
  String get declarations_label => 'Declarations';

  @override
  String get submitted_label => 'Submitted';

  @override
  String get active_submissions => 'Active Submissions';

  @override
  String get no_it_declarations_found => 'No IT Declarations found';

  @override
  String get tap_plus_to_create => 'Tap the + button to create one.';

  @override
  String get investment_amount_inr => 'Investment Amount (₹)';

  @override
  String get returned_label => 'Returned';

  @override
  String get total => 'Total';

  @override
  String get total_worked => 'Total Worked';

  @override
  String get good_morning => 'Good morning';

  @override
  String get good_afternoon => 'Good afternoon';

  @override
  String get good_evening => 'Good evening';

  @override
  String get ats_home => 'Home';

  @override
  String get ats_jobs => 'Jobs';

  @override
  String get ats_applications => 'Applications';

  @override
  String get ats_candidates => 'Candidates';

  @override
  String get ats_profile => 'Profile';

  @override
  String get ats_open_roles => 'Open roles';

  @override
  String get ats_this_week => 'This week';

  @override
  String ats_new_applications_came_in(num count) {
    return '$count new applications came in';
  }

  @override
  String get ats_recent_applications => 'Recent Applications';

  @override
  String get ats_view_all => 'View all';

  @override
  String get ats_no_recent_applications => 'No recent applications';

  @override
  String get ats_job_positions => 'Job Positions';

  @override
  String get ats_search_hint => 'Search ...';

  @override
  String get ats_no_jobs_found => 'No job requisitions found';

  @override
  String get ats_tweak_filters => 'Try tweaking your search or filters';

  @override
  String get ats_recruitment => 'Recruitment';

  @override
  String get ats_candidates_folder => 'Candidates Folder';

  @override
  String get ats_search_candidate_hint =>
      'Search name, degree, email, or skill...';

  @override
  String get tab_all => 'All';

  @override
  String get tab_new => 'New';

  @override
  String get tab_screening => 'Screening';

  @override
  String get tab_first_interview => 'First Interview';

  @override
  String get tab_second_interview => 'Second Interview';

  @override
  String get tab_offered => 'Offered';

  @override
  String get tab_hired => 'Hired';

  @override
  String get tab_refused => 'Refused';

  @override
  String get tab_ij => 'IJ';

  @override
  String get tab_hr_stage => 'HR Stage';

  @override
  String get tab_contract_proposal => 'Contract Proposal';

  @override
  String get tab_contract_signed => 'Contract Signed';

  @override
  String get tab_published => 'Published';

  @override
  String get tab_unpublished => 'Unpublished';

  @override
  String get tab_ongoing => 'Ongoing';

  @override
  String get ats_no_candidates => 'No candidates in this stage';

  @override
  String get ats_search_apps_hint =>
      'Search subject, job, email, or candidate...';

  @override
  String get ats_candidate_prefix => 'Candidate';

  @override
  String get ats_stage_prefix => 'Stage';

  @override
  String get ats_avail_prefix => 'Avail';

  @override
  String get ats_no_job_linked => 'No job linked';

  @override
  String get ats_unassigned => 'Unassigned';

  @override
  String ats_no_applications_in_stage(String stage) {
    return 'No applications in \'$stage\' stage';
  }

  @override
  String get this_week => 'This week';

  @override
  String get working_hours_logged => 'Working hours logged';

  @override
  String duration_mins(int minutes) {
    return '$minutes mins';
  }

  @override
  String get duration_mins_one => '1 min';

  @override
  String duration_hours(int hours) {
    return '$hours hrs';
  }

  @override
  String get duration_hours_one => '1 hr';

  @override
  String duration_hours_mins(int hours, int minutes) {
    return '$hours hrs $minutes mins';
  }

  @override
  String get my_profile => 'My Profile';

  @override
  String get unknown => 'Unknown';

  @override
  String get not_specified => 'Not specified';

  @override
  String get information => 'Information';

  @override
  String get member_since => 'Member Since';

  @override
  String get designation => 'Designation';

  @override
  String get website => 'Website';

  @override
  String get settings => 'Settings';

  @override
  String get applicationProfile => 'Application Profile';

  @override
  String get ats_no_linked_position => 'No Linked Position';

  @override
  String get ats_stage => 'Stage';

  @override
  String get ats_availability => 'Availability';

  @override
  String get ats_not_specified => 'Not specified';

  @override
  String get ats_info => 'Info';

  @override
  String get ats_details => 'Details';

  @override
  String get ats_additional_info => 'Additional Info';

  @override
  String get ats_notes_comments => 'Notes & Comments';

  @override
  String get ats_candidate_identity => 'Candidate Identity';

  @override
  String get ats_candidate_name => 'Candidate Name';

  @override
  String get ats_email_address => 'Email Address';

  @override
  String get ats_phone_number => 'Phone Number';

  @override
  String get ats_linkedin_profile => 'LinkedIn Profile';

  @override
  String get ats_not_linked => 'Not linked';

  @override
  String get ats_salary_details => 'Salary details';

  @override
  String get ats_current_ctc => 'Current CTC';

  @override
  String get ats_expected_salary => 'Expected Salary';

  @override
  String get ats_proposed_salary => 'Proposed Salary';

  @override
  String get ats_salary_negotiable => 'Salary Negotiable';

  @override
  String get ats_yes => 'Yes';

  @override
  String get ats_no => 'No';

  @override
  String get ats_experience_details => 'Experience details';

  @override
  String get ats_total_experience => 'Total Experience';

  @override
  String get ats_relevant_experience => 'Relevant Experience';

  @override
  String get ats_notice_period => 'Notice Period';

  @override
  String get ats_np_negotiable => 'NP Negotiable';

  @override
  String get ats_holding_offer => 'Holding Offer';

  @override
  String get ats_recruitment_assignments => 'Recruitment Assignments';

  @override
  String get ats_recruiter_handler => 'Recruiter / Handler';

  @override
  String get ats_job_position => 'Job Position';

  @override
  String get ats_experience_type => 'Experience Type';

  @override
  String get ats_company => 'Company';

  @override
  String get ats_bio_details => 'Bio details';

  @override
  String get ats_gender => 'Gender';

  @override
  String get ats_birthday => 'Birthday';

  @override
  String get ats_blood_group => 'Blood Group';

  @override
  String get ats_marital_status => 'Marital Status';

  @override
  String get ats_contact_addresses => 'Contact Addresses';

  @override
  String get ats_current_address => 'Current Address';

  @override
  String get ats_permanent_address => 'Permanent Address';

  @override
  String get ats_applicant_comments => 'Applicant Comments';

  @override
  String get ats_recruiter_comments => 'Recruiter Comments';

  @override
  String get ats_general_notes => 'General Notes';

  @override
  String get ats_no_records_provided => 'No records provided.';

  @override
  String get ats_applied_on => 'Applied On';

  @override
  String get ats_job_documents => 'Job Documents';

  @override
  String get ats_no_documents_found =>
      'No documents found for this job position.';

  @override
  String get ats_primary_skills_required => 'Primary Skills Required';

  @override
  String get ats_secondary_skills_required => 'Secondary Skills Required';

  @override
  String get ats_job_description => 'Job Description';

  @override
  String get ats_key_responsibilities => 'Key Responsibilities';

  @override
  String get ats_minimum_requirements => 'Minimum Requirements';

  @override
  String get ats_job_directory_summary => 'Job Directory Summary';

  @override
  String get ats_experience_required => 'Experience Required';

  @override
  String get ats_budget_salary => 'Budget / Salary';

  @override
  String get ats_employment_type => 'Employment Type';

  @override
  String get ats_full_time => 'Full-time';

  @override
  String get ats_status => 'Status';

  @override
  String get ats_published => 'Published';

  @override
  String get ats_draft => 'Draft';

  @override
  String get ats_priority => 'Priority';

  @override
  String get ats_not_spec => 'Not Spec';

  @override
  String get ats_candidate_profile => 'Candidate Profile';

  @override
  String get ats_contact_bio => 'Contact & Bio';

  @override
  String get ats_skills_meta => 'Skills & Meta';

  @override
  String get ats_primary_contact => 'Primary Contact';

  @override
  String get ats_mobile_phone => 'Mobile Phone';

  @override
  String get ats_alternate_phone => 'Alternate Phone';

  @override
  String get ats_not_provided => 'Not provided';

  @override
  String get ats_recruitment_information => 'Recruitment Information';

  @override
  String get ats_contact_partner_name => 'Contact Partner Name';

  @override
  String get ats_candidate_manager => 'Candidate Manager';

  @override
  String get ats_odoo_company => 'Odoo Company';

  @override
  String get ats_candidate_status_info => 'Candidate Status Info';

  @override
  String get ats_availability_date => 'Availability Date';

  @override
  String get ats_recruitment_stage => 'Recruitment Stage';

  @override
  String get ats_odoo_skills_list => 'Odoo Skills List';

  @override
  String get ats_no_skills_mapped => 'No skills mapped for this candidate yet.';

  @override
  String get ats_download_resume => 'Download Resume';

  @override
  String get ats_type => 'Type';

  @override
  String get help_desk => 'Help Desk';
}
