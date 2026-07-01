
import 'package:flutter/material.dart';
import 'package:flutter_app/ats/core/constants/api_config.dart';
import 'package:flutter_app/ats/core/services/odoo_service.dart';
import 'package:flutter_app/ats/features/jobs/repository/create_job_servic.dart';

class RecruitmentCreatePage extends StatefulWidget {

  const RecruitmentCreatePage({
    super.key,
  });

  @override
  State<RecruitmentCreatePage> createState() =>
      _RecruitmentCreatePageState();
}

class _RecruitmentCreatePageState
    extends State<RecruitmentCreatePage> {

 final RecruitmentService service =
    RecruitmentService(
      OdooService(
        ApiConfig.baseUrl,
      ),
    );

  final budgetCtrl =
      TextEditingController();

// CONTROLLERS


final descriptionCtrl =
    TextEditingController();

final eligibleCtrl =
    TextEditingController();

final recruitmentCtrl =
    TextEditingController();

// DROPDOWN DATA

List<Map<String, dynamic>> jobs = [];

List<Map<String, dynamic>> companies = [];

List<Map<String, dynamic>> addresses = [];

List<Map<String, dynamic>> contractTypes = [];

List<Map<String, dynamic>> experiences = [];

List<Map<String, dynamic>> categories = [];

List<Map<String, dynamic>> recruiters = [];

List<Map<String, dynamic>> websites = [];

List<Map<String, dynamic>> locations = [];

List<Map<String, dynamic>> stages = [];

List<Map<String, dynamic>> partners = [];

List<Map<String, dynamic>> skills = [];

// SELECTED VALUES

int? selectedJobId;

int? selectedCompanyId;

int? selectedAddressId;

int? selectedContractTypeId;

int? selectedExperienceId;

int? selectedCategoryId;

int? selectedRecruiterId;

int? selectedWebsiteId;

int? selectedRequestedById;

// SELECTION FIELDS

String selectedPriority = 'high';

String selectedStatus = 'open';

String selectedRecruitmentType =
    'internal';

// DATE

DateTime? selectedDate;

// MANY2MANY

List<int> selectedSkillIds = [];

List<int>
    selectedSecondarySkillIds = [];

List<int> selectedLocationIds = [];

List<int> selectedStageIds = [];

List<int>
    selectedInterviewerIds = [];

 

  @override
  void initState() {
    super.initState();
    loadDropdowns();
  }

 
Future<void> loadDropdowns() async {

  jobs =
      await service.fetchJobs();

  companies =
      await service.fetchCompanies();

  // skills =
  //     await service.fetchSkills();

  addresses =
      await service.fetchAddresses();

  contractTypes =
      await service.fetchContractTypes();

  experiences =
      await service.fetchExperiences();

  categories =
      await service.fetchCategories();

  recruiters =
      await service.fetchRecruiters();

  websites =
      await service.fetchWebsites();

  // locations =
  //     await service.fetchLocations();

  // stages =
  //     await service.fetchStages();

  // partners =
  //     await service.fetchPartners();

  print(addresses);

  print(contractTypes);

  print(categories);

  setState(() {});
}



  Future<void> saveRecruitment() async {

    if (selectedJobId == null ||
        selectedCompanyId == null) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please select job and company',
          ),
        ),
      );

      return;
    }

    await service.createRecruitment(
      jobId: selectedJobId!,
      companyId: selectedCompanyId!,
      budget: budgetCtrl.text,
      status: 'open',
      priority: 'high',
      skillIds: [1, 2],
    );

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text('Saved to Odoo'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Create Recruitment',
        ),
      ),

      body: Padding(

        padding: const EdgeInsets.all(16),

        child: SingleChildScrollView(
          child: Column(
           
            children: [
          
              DropdownButtonFormField<int>(
          
                value: selectedJobId,
          
                hint: const Text(
                  'Select Job',
                ),
          
                items: jobs.map((job) {
          
                  return DropdownMenuItem<int>(
          
                    value: job['id'],
          
                    child: Text(
                      job['name'],
                    ),
                  );
          
                }).toList(),
          
                onChanged: (value) {
          
                  setState(() {
          
                    selectedJobId = value;
                  });
                },
              ),
          
              const SizedBox(height: 16),
          
              DropdownButtonFormField<int>(
          
                value: selectedCompanyId,
          
                hint: const Text(
                  'Select Company',
                ),
          
                items: companies.map((company) {
          
                  return DropdownMenuItem<int>(
          
                    value: company['id'],
          
                    child: Text(
                      company['name'],
                    ),
                  );
          
                }).toList(),
          
                onChanged: (value) {
          
                  setState(() {
          
                    selectedCompanyId = value;
                  });
                },
              ),
          
          
          const SizedBox(height: 16),
          
          DropdownButtonFormField<int>(
          
            decoration: const InputDecoration(
              labelText: 'Job Location',
            ),
          
            items: addresses.map((item) {
          
              return DropdownMenuItem<int>(
          
                value: item['id'],
          
                child: Text(item['name']),
              );
          
            }).toList(),
          
            onChanged: (value) {
          setState(() {
            selectedAddressId = value;
          });
            },
          ),
          
          // EMPLOYMENT TYPE
          
          const SizedBox(height: 16),
          
          DropdownButtonFormField<int>(
          
            decoration: const InputDecoration(
              labelText: 'Employment Type',
            ),
          
            items: contractTypes.map((item) {
          
              return DropdownMenuItem<int>(
          
                value: item['id'],
          
                child: Text(item['name']),
              );
          
            }).toList(),
          
            onChanged: (value) {
          
              selectedContractTypeId = value;
            },
          ),
          
          // EXPERIENCE
          
          const SizedBox(height: 16),
          
          DropdownButtonFormField<int>(
          
            decoration: const InputDecoration(
              labelText: 'Experience',
            ),
          
            items: experiences.map((item) {
          
              return DropdownMenuItem<int>(
          
                value: item['id'],
          
                child: Text(item['name']),
              );
          
            }).toList(),
          
            onChanged: (value) {
          
              selectedExperienceId = value;
            },
          ),
          
          // CATEGORY
          
          const SizedBox(height: 16),
          
          DropdownButtonFormField<int>(
          
            decoration: const InputDecoration(
              labelText: 'Category',
            ),
          
            items: categories.map((item) {
          
              return DropdownMenuItem<int>(
          
                value: item['id'],
          
                child: Text(item['name']),
              );
          
            }).toList(),
          
            onChanged: (value) {
          
              selectedCategoryId = value;
            },
          ),
          
          // PRIORITY
          
          const SizedBox(height: 16),
          
          DropdownButtonFormField<String>(
          
            value: selectedPriority,
          
            decoration: const InputDecoration(
              labelText: 'Priority',
            ),
          
            items: const [
          
              DropdownMenuItem(
                value: 'low',
                child: Text('Low'),
              ),
          
              DropdownMenuItem(
                value: 'medium',
                child: Text('Medium'),
              ),
          
              DropdownMenuItem(
                value: 'high',
                child: Text('High'),
              ),
            ],
          
            onChanged: (value) {
          
              setState(() {
          
                selectedPriority = value!;
              });
            },
          ),
          
          // ELIGIBLE SUBMISSIONS
          
          const SizedBox(height: 16),
          
          TextField(
          
            controller: eligibleCtrl,
          
            keyboardType:
                TextInputType.number,
          
            decoration: const InputDecoration(
              labelText:
          'Eligible Submissions',
            ),
          ),
          
          // NUMBER OF POSITIONS
          
          const SizedBox(height: 16),
          
          TextField(
          
            controller: recruitmentCtrl,
          
            keyboardType:
                TextInputType.number,
          
            decoration: const InputDecoration(
              labelText:
          'Number Of Positions',
            ),
          ),
          
          // RECRUITMENT TYPE
          
          const SizedBox(height: 16),
          
          DropdownButtonFormField<String>(
          
            value: selectedRecruitmentType,
          
            decoration: const InputDecoration(
              labelText:
          'Recruitment Type',
            ),
          
            items: const [
          
              DropdownMenuItem(
                value: 'internal',
                child: Text('Internal'),
              ),
          
              DropdownMenuItem(
                value: 'external',
                child: Text('External'),
              ),
            ],
          
            onChanged: (value) {
          
              setState(() {
          
                selectedRecruitmentType =
            value!;
              });
            },
          ),
          
          // REQUESTED BY
          
          const SizedBox(height: 16),
          
          DropdownButtonFormField<int>(
          
            decoration: const InputDecoration(
              labelText: 'Requested By',
            ),
          
            items: partners.map((item) {
          
              return DropdownMenuItem<int>(
          
                value: item['id'],
          
                child: Text(item['name']),
              );
          
            }).toList(),
          
            onChanged: (value) {
          
              selectedRequestedById =
          value;
            },
          ),
          
          // PRIMARY RECRUITER
          
          const SizedBox(height: 16),
          
          DropdownButtonFormField<int>(
          
            decoration: const InputDecoration(
              labelText:
          'Primary Recruiter',
            ),
          
            items: recruiters.map((item) {
          
              return DropdownMenuItem<int>(
          
                value: item['id'],
          
                child: Text(item['name']),
              );
          
            }).toList(),
          
            onChanged: (value) {
          
              selectedRecruiterId =
          value;
            },
          ),
          
          // WEBSITE
          
          const SizedBox(height: 16),
          
          DropdownButtonFormField<int>(
          
            decoration: const InputDecoration(
              labelText: 'Website',
            ),
          
            items: websites.map((item) {
          
              return DropdownMenuItem<int>(
          
                value: item['id'],
          
                child: Text(item['name']),
              );
          
            }).toList(),
          
            onChanged: (value) {
          
              selectedWebsiteId = value;
            },
          ),
          
          // DESCRIPTION
          
          const SizedBox(height: 16),
          
          TextField(
          
            controller: descriptionCtrl,
          
            maxLines: 5,
          
            decoration: const InputDecoration(
              labelText: 'Job Summary',
            ),
          ),
          
          // STATUS
          
          const SizedBox(height: 16),
          
          DropdownButtonFormField<String>(
          
            value: selectedStatus,
          
            decoration: const InputDecoration(
              labelText:
          'Recruitment Status',
            ),
          
            items: const [
          
              DropdownMenuItem(
                value: 'open',
                child: Text('Open'),
              ),
          
              DropdownMenuItem(
                value: 'closed',
                child: Text('Closed'),
              ),
            ],
          
            onChanged: (value) {
          
              setState(() {
          
                selectedStatus = value!;
              });
            },
          ),
          
          // DATE
          
          const SizedBox(height: 16),
          
          ListTile(
          
            title: Text(
          
              selectedDate == null
          
          ? 'Mission Date'
          
          : selectedDate!
              .toString()
              .split(' ')
              .first,
            ),
          
            trailing:
                const Icon(Icons.calendar_month),
          
            onTap: () async {
          
              final picked =
          await showDatePicker(
          
                context: context,
          
                firstDate: DateTime(2024),
          
                lastDate: DateTime(2030),
          
                initialDate: DateTime.now(),
              );
          
              if (picked != null) {
          
                setState(() {
          
          selectedDate = picked;
                });
              }
            },
          ),
          
          
              const SizedBox(height: 16),
          
              TextField(
          
                controller: budgetCtrl,
          
                decoration: const InputDecoration(
                  labelText: 'Budget',
                ),
              ),
          
              const SizedBox(height: 24),
          
              ElevatedButton(
          
                onPressed: saveRecruitment,
          
                child: const Text(
                  'Save Recruitment',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}