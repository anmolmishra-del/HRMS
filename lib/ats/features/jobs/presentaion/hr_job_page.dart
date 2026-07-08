import 'package:flutter/material.dart';
import 'package:flutter_app/core/widget/loading_overlay.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/job_cubit.dart';
import '../repository/hr_job_service file.dart';

class HrJobCreatePage extends StatefulWidget {
  const HrJobCreatePage({super.key});

  @override
  State<HrJobCreatePage> createState() => _HrJobCreatePageState();
}

class _HrJobCreatePageState extends State<HrJobCreatePage> {
  final _titleCtrl = TextEditingController();
  
  int? _selectedDeptId;
  int? _selectedCategoryId;
  
  List<Map<String, dynamic>> _departments = [];
  List<Map<String, dynamic>> _categories = [];
  final _service = HrJobService();
  
  bool _loading = false;
  bool _loadingDropdowns = false;

  @override
  void initState() {
    super.initState();
    _fetchDropdowns();
  }

  Future<void> _fetchDropdowns() async {
    setState(() => _loadingDropdowns = true);
    print('🔄 _fetchDropdowns: Starting fetch...');

    try {
      print('📦 Fetching departments...');
      final departments = await _service.fetchDepartments();
      print('✅ Departments fetched: ${departments.length} items - $departments');
      
      print('📦 Fetching categories...');
      final categories = await _service.fetchCategories();
      print('✅ Categories fetched: ${categories.length} items - $categories');

      if (mounted) {
        setState(() {
          _departments = departments;
          _categories = categories;
        });
        print('✅ UI state updated with dropdowns');
      }
    } catch (e) {
      print('❌ _fetchDropdowns error: $e');
      debugPrint('hr_job: fetchDropdowns error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch dropdowns: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingDropdowns = false);
      print('✅ _fetchDropdowns: Complete');
    }
  }

  Future<void> _createHrJob() async {
    final title = _titleCtrl.text.trim();
    print('🚀 _createHrJob: Starting with title="$title", deptId=$_selectedDeptId, catId=$_selectedCategoryId');

    if (title.isEmpty) {
      print('⚠️ _createHrJob: Title is empty!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter job position')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      print('📤 Calling _service.createHrJob()...');
      final newJob = await _service.createHrJob(
        title: title,
        departmentId: _selectedDeptId,
        categoryId: _selectedCategoryId,
      );
      print('📥 Service response: $newJob');

      if (newJob == null) {
        print('❌ newJob is NULL - creation failed');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to create job. Check the form and try again.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      print('✅ newJob created: title=${newJob.title}, dept=${newJob.department}, cat=${newJob.category}');
      
      if (mounted) {
        print('📝 Adding job to cubit...');
        context.read<JobCubit>().addJob(newJob);
        print('✅ Job added to cubit');
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job created successfully')),
        );
        print('📤 Navigating back...');
        Navigator.pop(context);
      }
    } catch (e) {
      print('❌ _createHrJob exception: $e');
      debugPrint('hr_job: create error $e');
      
      if (mounted) {
        // Extract error message
        String errorMsg = 'Failed to create job';
        final err = e.toString();
        
        if (err.contains('must be unique')) {
          errorMsg = 'Job position name must be unique in this department.\nTry a different name or department.';
          print('⚠️ Unique constraint violation');
        } else if (err.contains('You are not allowed to create') || err.contains('AccessError') || err.contains('Permission denied')) {
          errorMsg = "Permission denied: assign the user to 'Recruitment/Officer' group or use an account with recruitment rights.";
          print('🔐 Permission error detected');
        } else if (err.contains('Exception:')) {
          // Extract message from Exception('message')
          final match = RegExp(r"Exception: (.+?)(?:\)|$)").firstMatch(err);
          if (match != null) {
            errorMsg = match.group(1) ?? 'Failed to create job';
          }
        } else {
          errorMsg = 'Failed to create job: $e';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
      print('✅ _createHrJob: Complete');
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Create HR Job')),
      body: _loadingDropdowns
          ? const AppLoader()
          : Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Job Position TextField
                  TextField(
  controller: _titleCtrl,
  style: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  ),
  decoration: InputDecoration(
    labelText: 'Job Position',
    hintText: 'Enter job title',
    prefixIcon: const Icon(
      Icons.work_outline,
      color: Colors.grey,
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 18,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: Colors.grey.shade300,
        width: 1.2,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: Colors.grey.shade500,
        width: 1.5,
      ),
    ),
    labelStyle: TextStyle(
      color: Colors.grey.shade700,
    ),
    hintStyle: TextStyle(
      color: Colors.grey.shade400,
    ),
  ),
),

const SizedBox(height: 16),

DropdownButtonFormField<int>(
  value: _selectedDeptId,
  decoration: InputDecoration(
    labelText: 'Department',
    prefixIcon: const Icon(
      Icons.apartment_outlined,
      color: Colors.grey,
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 18,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: Colors.grey.shade300,
        width: 1.2,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: Colors.grey.shade500,
        width: 1.5,
      ),
    ),
    labelStyle: TextStyle(
      color: Colors.grey.shade700,
    ),
  ),
  dropdownColor: Colors.white,
  items: [
    const DropdownMenuItem<int>(
      value: null,
      child: Text('Select Department (Optional)'),
    ),
    ..._departments.map(
      (dept) => DropdownMenuItem<int>(
        value: dept['id'] as int,
        child: Text(dept['name'] as String),
      ),
    ),
  ],
  onChanged: (value) {
    setState(() => _selectedDeptId = value);
  },
),

const SizedBox(height: 16),

DropdownButtonFormField<int>(
  value: _selectedCategoryId,
  decoration: InputDecoration(
    labelText: 'Category',
    prefixIcon: const Icon(
      Icons.category_outlined,
      color: Colors.grey,
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 18,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: Colors.grey.shade300,
        width: 1.2,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: Colors.grey.shade500,
        width: 1.5,
      ),
    ),
    labelStyle: TextStyle(
      color: Colors.grey.shade700,
    ),
  ),
  dropdownColor: Colors.white,
  items: [
    const DropdownMenuItem<int>(
      value: null,
      child: Text('Select Category (Optional)'),
    ),
    ..._categories.map(
      (cat) => DropdownMenuItem<int>(
        value: cat['id'] as int,
        child: Text(cat['name'] as String),
      ),
    ),
  ],
  onChanged: (value) {
    setState(() => _selectedCategoryId = value);
  },
),
                    const SizedBox(height: 18),

                    // Create Button
                    // SizedBox(
                    //   width: double.infinity,
                    //   height: 48,
                    //   child: ElevatedButton(
                    //     onPressed: _loading ? null : _createHrJob,
                    //     child: _loading
                    //         ? const CircularProgressIndicator(color: Colors.white)
                    //         : const Text('Create'),
                    //   ),
                    // ),
                    SizedBox(
  width: double.infinity,
  height: 55,
  child: ElevatedButton(
    onPressed: _loading ? null : _createHrJob,
    style: ElevatedButton.styleFrom(
      elevation: 6,
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      shadowColor: Colors.blueAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),
    child: AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _loading
          ? const SizedBox(
              key: ValueKey('loading'),
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
          : Row(
              key: const ValueKey('text'),
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(width: 8),
                Text(
                  'Create Job',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
    ),
  ),
),
                  ],
                ),
              ),
            ),
    );
  }
}
