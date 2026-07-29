import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/ats/core/constants/app_colors.dart';
import 'package:flutter_app/ats/features/candidatefolder/candidate/cubit/candidate_cubit.dart';
import 'package:flutter_app/ats/features/candidatefolder/candidate/state/hr_candidate_model.dart';

class AddCandidatePage extends StatefulWidget {
  final CandidateCubit cubit;

  const AddCandidatePage({super.key, required this.cubit});

  @override
  State<AddCandidatePage> createState() => _AddCandidatePageState();
}

class _AddCandidatePageState extends State<AddCandidatePage> {
  final _formKey = GlobalKey<FormState>();

  String firstName = '';
  String middleName = '';
  String lastName = '';
  String email = '';
  String phone = '';
  String altPhone = '';
  String linkedin = '';
  String degree = '';
  String manager = '';
  String priority = '2'; // High default
  DateTime availability = DateTime.now().add(const Duration(days: 14));
  String company = '';
  
  // Skills list (One2Many)
  final List<HrCandidateSkill> candidateSkills = [];

  // Inline Skills Mapper State
  String selectedSkillType = '';
  String skillName = '';
  String skillLevel = 'Intermediate';
  final TextEditingController skillNameController = TextEditingController();

  @override
  void dispose() {
    skillNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Create Candidate Record",
          style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                physics: const BouncingScrollPhysics(),
                children: [
                  // SECTION 1: Personal Profile
                  _buildFormSection(
                    title: "Personal Information",
                    icon: Icons.person_outline_rounded,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: firstName,
                              decoration: const InputDecoration(
                                labelText: "First Name *",
                                hintText: "e.g. Arjun",
                              ),
                              validator: (v) => v!.isEmpty ? "Required" : null,
                              onChanged: (v) => firstName = v,
                              onSaved: (v) => firstName = v ?? '',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              initialValue: middleName,
                              decoration: const InputDecoration(
                                labelText: "Middle Name",
                                hintText: "Optional",
                              ),
                              onChanged: (v) => middleName = v,
                              onSaved: (v) => middleName = v ?? '',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        initialValue: lastName,
                        decoration: const InputDecoration(
                          labelText: "Last Name *",
                          hintText: "e.g. Mehta",
                        ),
                        validator: (v) => v!.isEmpty ? "Required" : null,
                        onChanged: (v) => lastName = v,
                        onSaved: (v) => lastName = v ?? '',
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: priority,
                        decoration: const InputDecoration(labelText: "Evaluation Rating / Priority"),
                        items: const [
                          DropdownMenuItem(value: "0", child: Text("⭐ Low")),
                          DropdownMenuItem(value: "1", child: Text("⭐⭐ Medium")),
                          DropdownMenuItem(value: "2", child: Text("⭐⭐⭐ High")),
                          DropdownMenuItem(value: "3", child: Text("⭐⭐⭐⭐ Excellent")),
                        ],
                        onChanged: (v) => setState(() => priority = v ?? priority),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // SECTION 2: Contact Info
                  _buildFormSection(
                    title: "Contact Details",
                    icon: Icons.contact_mail_outlined,
                    children: [
                      TextFormField(
                        initialValue: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: "Email Address *",
                          hintText: "name@company.com",
                        ),
                        validator: (v) => v!.isEmpty ? "Required" : null,
                        onChanged: (v) => email = v,
                        onSaved: (v) => email = v ?? '',
                      ),
                      const SizedBox(width: 12),
                      TextFormField(
                        initialValue: phone,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: "Phone Number *",
                          hintText: "+91 XXXXX XXXXX",
                        ),
                        validator: (v) => v!.isEmpty ? "Required" : null,
                        onChanged: (v) => phone = v,
                        onSaved: (v) => phone = v ?? '',
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: altPhone,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: "Alternate Contact Number",
                          hintText: "Optional alternate number",
                        ),
                        onChanged: (v) => altPhone = v,
                        onSaved: (v) => altPhone = v ?? '',
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: linkedin,
                        decoration: const InputDecoration(
                          labelText: "LinkedIn Profile URL",
                          hintText: "linkedin.com/in/username",
                        ),
                        onChanged: (v) => linkedin = v,
                        onSaved: (v) => linkedin = v ?? '',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // SECTION 3: Recruitment Settings & Company
                  _buildFormSection(
                    title: "Recruitment & Availability",
                    icon: Icons.business_center_outlined,
                    children: [
                      DropdownButtonFormField<String>(
                        value: widget.cubit.state.degrees.map((e) => e['name']?.toString() ?? '').toSet().contains(degree)
                            ? degree
                            : (widget.cubit.state.degrees.isNotEmpty ? widget.cubit.state.degrees.map((e) => e['name']?.toString() ?? '').toSet().first : null),
                        decoration: const InputDecoration(labelText: "Degree / Qualification"),
                        items: widget.cubit.state.degrees
                            .map((e) => e['name']?.toString() ?? '')
                            .toSet()
                            .map((name) {
                          return DropdownMenuItem<String>(
                            value: name,
                            child: Text(name),
                          );
                        }).toList(),
                        onChanged: (v) => setState(() => degree = v ?? degree),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: widget.cubit.state.managers.map((e) => e['name']?.toString() ?? '').toSet().contains(manager)
                            ? manager
                            : (widget.cubit.state.managers.isNotEmpty ? widget.cubit.state.managers.map((e) => e['name']?.toString() ?? '').toSet().first : null),
                        decoration: const InputDecoration(labelText: "Candidate Manager"),
                        items: widget.cubit.state.managers
                            .map((e) => e['name']?.toString() ?? '')
                            .toSet()
                            .map((name) {
                          return DropdownMenuItem<String>(
                            value: name,
                            child: Text(name),
                          );
                        }).toList(),
                        onChanged: (v) => setState(() => manager = v ?? manager),
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () async {
                          final selected = await showDatePicker(
                            context: context,
                            initialDate: availability,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (selected != null) {
                            setState(() => availability = selected);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(labelText: "Availability Date"),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(DateFormat('dd MMMM yyyy').format(availability)),
                              const Icon(Icons.calendar_today_rounded, size: 18, color: Color(0xFF64748B)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: widget.cubit.state.companies.map((e) => e['name']?.toString() ?? '').toSet().contains(company)
                            ? company
                            : (widget.cubit.state.companies.isNotEmpty ? widget.cubit.state.companies.map((e) => e['name']?.toString() ?? '').toSet().first : null),
                        decoration: const InputDecoration(labelText: "Odoo Company"),
                        items: widget.cubit.state.companies
                            .map((e) => e['name']?.toString() ?? '')
                            .toSet()
                            .map((name) {
                          return DropdownMenuItem<String>(
                            value: name,
                            child: Text(name),
                          );
                        }).toList(),
                        onChanged: (v) => setState(() => company = v ?? company),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // SECTION 4: One2many Skills Mapper
                  _buildFormSection(
                    title: "Skills Mapping (One2many Lines)",
                    icon: Icons.psychology_outlined,
                    children: [
                      if (candidateSkills.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              "No skills mapped yet. Use the selector below to add lines.",
                              style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      else
                        ...candidateSkills.map((skill) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(skill.skillId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF1F5F9),
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(color: const Color(0xFFCBD5E1)),
                                            ),
                                            child: Text(
                                              skill.skillLevel,
                                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text("Type: ${skill.skillTypeId}", style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                                  onPressed: () {
                                    setState(() {
                                      candidateSkills.remove(skill);
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      const SizedBox(height: 16),

                      // INLINE SKILLS SELECTOR
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.add_moderator_rounded, size: 18, color: AppColors.primary),
                                const SizedBox(width: 6),
                                const Text(
                                  "Add Custom Skill Inline",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF475569)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Skill Type Dropdown
                            DropdownButtonFormField<String>(
                              value: widget.cubit.state.skillTypes.map((e) => e['name']?.toString() ?? '').toSet().contains(selectedSkillType) 
                                  ? selectedSkillType 
                                  : (widget.cubit.state.skillTypes.isNotEmpty ? widget.cubit.state.skillTypes.map((e) => e['name']?.toString() ?? '').toSet().first : null),
                              decoration: const InputDecoration(
                                labelText: "Skill Type",
                                fillColor: Colors.white,
                                filled: true,
                              ),
                              items: widget.cubit.state.skillTypes
                                  .map((e) => e['name']?.toString() ?? '')
                                  .toSet()
                                  .map((name) {
                                return DropdownMenuItem<String>(
                                  value: name,
                                  child: Text(name),
                                );
                              }).toList(),
                              onChanged: (v) {
                                if (v != null) {
                                  setState(() => selectedSkillType = v);
                                }
                              },
                            ),
                            const SizedBox(height: 12),
                            // Skill Name Field (Autocomplete with dynamic suggestions based on Skill Type + manual typing)
                            LayoutBuilder(
                              builder: (context, constraints) {
                                return Autocomplete<String>(
                                  optionsBuilder: (TextEditingValue textEditingValue) {
                                    // Filter skills where the skill_type_name matches the selectedSkillType
                                    final typeToMatch = selectedSkillType.isNotEmpty
                                        ? selectedSkillType
                                        : (widget.cubit.state.skillTypes.isNotEmpty
                                            ? widget.cubit.state.skillTypes.first['name']?.toString() ?? ''
                                            : '');
                                    final suggestions = widget.cubit.state.skills
                                        .where((s) => s['skill_type_name']?.toString().toLowerCase() == typeToMatch.toLowerCase())
                                        .map((s) => s['name']?.toString() ?? '')
                                        .where((name) => name.isNotEmpty)
                                        .toSet()
                                        .toList();
                                    
                                    if (textEditingValue.text.isEmpty) {
                                      return suggestions;
                                    }
                                    return suggestions.where((String option) {
                                      return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                                    });
                                  },
                                  displayStringForOption: (String option) => option,
                                  fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                                    // Keep controller content synchronized with current skillName state
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      if (skillName.isEmpty && textEditingController.text.isNotEmpty) {
                                        textEditingController.clear();
                                      } else if (skillName.isNotEmpty && textEditingController.text != skillName) {
                                        textEditingController.text = skillName;
                                      }
                                    });
                                    return TextFormField(
                                      controller: textEditingController,
                                      focusNode: focusNode,
                                      decoration: const InputDecoration(
                                        labelText: "Skill Name",
                                        hintText: "e.g. Flutter, Dart, Python",
                                        fillColor: Colors.white,
                                        filled: true,
                                      ),
                                      onChanged: (v) {
                                        setState(() {
                                          skillName = v;
                                        });
                                      },
                                    );
                                  },
                                  optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: Material(
                                        elevation: 4.0,
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          width: constraints.maxWidth,
                                          constraints: const BoxConstraints(maxHeight: 200),
                                          child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            itemCount: options.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              final String option = options.elementAt(index);
                                              return ListTile(
                                                title: Text(option, style: const TextStyle(fontSize: 14)),
                                                onTap: () {
                                                  onSelected(option);
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  onSelected: (String selection) {
                                    setState(() {
                                      skillName = selection;
                                    });
                                  },
                                );
                              }
                            ),
                            const SizedBox(height: 12),
                            // Skill Level Dropdown
                            DropdownButtonFormField<String>(
                              value: widget.cubit.state.skillLevels.map((e) => e['name']?.toString() ?? '').toSet().contains(skillLevel) 
                                  ? skillLevel 
                                  : (widget.cubit.state.skillLevels.isNotEmpty ? widget.cubit.state.skillLevels.map((e) => e['name']?.toString() ?? '').toSet().first : null),
                              decoration: const InputDecoration(
                                labelText: "Skill Level",
                                fillColor: Colors.white,
                                filled: true,
                              ),
                              items: widget.cubit.state.skillLevels
                                  .map((e) => e['name']?.toString() ?? '')
                                  .toSet()
                                  .map((name) {
                                return DropdownMenuItem<String>(
                                  value: name,
                                  child: Text(name),
                                );
                              }).toList(),
                              onChanged: (v) {
                                if (v != null) {
                                  setState(() => skillLevel = v);
                                }
                              },
                            ),
                            const SizedBox(height: 14),
                            // Add Skill Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: skillName.trim().isEmpty 
                                    ? null 
                                    : () {
                                        final type = selectedSkillType.isNotEmpty 
                                            ? selectedSkillType 
                                            : (widget.cubit.state.skillTypes.isNotEmpty 
                                                ? widget.cubit.state.skillTypes.first['name']?.toString() ?? 'Languages'
                                                : 'Languages');
                                        
                                        final level = widget.cubit.state.skillLevels.any((e) => e['name'] == skillLevel) 
                                            ? skillLevel 
                                            : (widget.cubit.state.skillLevels.isNotEmpty 
                                                ? widget.cubit.state.skillLevels.first['name']?.toString() ?? 'Intermediate'
                                                : 'Intermediate');

                                        setState(() {
                                          candidateSkills.add(
                                            HrCandidateSkill(
                                              skillTypeId: type,
                                              skillId: skillName.trim(),
                                              skillLevel: level,
                                            ),
                                          );
                                          // Clear skill name input
                                          skillName = '';
                                          skillNameController.clear();
                                        });
                                        
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text("Skill added inline!"),
                                            duration: Duration(milliseconds: 800),
                                          ),
                                        );
                                      },
                                icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.white, size: 18),
                                label: const Text(
                                  "Add Skill Line Inline",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // FLOATING SAVE BUTTON
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Color(0x0A000000), blurRadius: 16, offset: Offset(0, -4)),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          // Dynamically resolve values if they are empty or not in the fetched lists to match what the dropdown displays!
                          final finalDegree = widget.cubit.state.degrees.map((e) => e['name']?.toString() ?? '').toSet().contains(degree)
                              ? degree
                              : (widget.cubit.state.degrees.isNotEmpty ? widget.cubit.state.degrees.map((e) => e['name']?.toString() ?? '').first : degree);

                          final finalManager = widget.cubit.state.managers.map((e) => e['name']?.toString() ?? '').toSet().contains(manager)
                              ? manager
                              : (widget.cubit.state.managers.isNotEmpty ? widget.cubit.state.managers.map((e) => e['name']?.toString() ?? '').first : manager);

                          final finalCompany = widget.cubit.state.companies.map((e) => e['name']?.toString() ?? '').toSet().contains(company)
                              ? company
                              : (widget.cubit.state.companies.isNotEmpty ? widget.cubit.state.companies.map((e) => e['name']?.toString() ?? '').first : company);

                          final newCand = HrCandidate(
                            firstName: firstName,
                            middleName: middleName.isNotEmpty ? middleName : null,
                            lastName: lastName,
                            partnerId: "$firstName $lastName (Contact)",
                            emailFrom: email,
                            partnerPhone: phone,
                            alternatePhone: altPhone.isNotEmpty ? altPhone : null,
                            linkedinProfile: linkedin.isNotEmpty ? linkedin : null,
                            typeId: finalDegree,
                            userId: finalManager,
                            priority: priority,
                            availability: availability,
                            categIds: ["Mobile", "Flutter"],
                            companyId: finalCompany,
                            skills: List<HrCandidateSkill>.from(candidateSkills),
                          );

                          widget.cubit.addCandidate(newCand);
                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Candidate ${newCand.fullName} created successfully!"),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Save Candidate Record",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormSection({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 22),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF0F172A)),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...children,
        ],
      ),
    );
  }

}
