import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:flutter_app/ats/core/services/odoo_service.dart';
import 'package:flutter_app/ats/core/constants/api_config.dart';
import '../state/candidate_state.dart';
import '../state/hr_candidate_model.dart';


class CandidateCubit extends Cubit<CandidateState> {
  late OdooService _svc;

  CandidateCubit() : super(CandidateState.initial()) {
    print("[CandidateCubit] Initialized CandidateCubit. Triggering data sync...");
    _svc = OdooService(ApiConfig.baseUrl);
    loadBackendDropdowns();
    loadCandidates();
  }

  /// 🔄 UPDATE SESSION AND REFRESH DATA (Call this after login!)
  Future<void> setSessionAndRefresh(OdooSession session) async {
    print("[CandidateCubit] setSessionAndRefresh() called with new session. User ID: ${session.userId}");
    
    // Close old service
    _svc.close();
    
    // Create new service with the new session
    _svc = OdooService(ApiConfig.baseUrl, session: session);
    
    // Clear old state and reload with new session (explicitly reset selectedCandidate)
    emit(CandidateState.initial().copyWith(
      selectedCandidate: null,
      isLoading: true,
    ));
    
    // Reload all data with the new session
    await loadBackendDropdowns();
    await loadCandidates();
    
    print("[CandidateCubit] setSessionAndRefresh() completed. Data reloaded.");
  }

  bool _isValidRasterImage(String? base64Str) {
    if (base64Str == null || base64Str.isEmpty) return false;
    var cleanStr = base64Str.trim();
    if (cleanStr == 'false' || cleanStr == 'null') return false;
    if (cleanStr.contains(',')) {
      cleanStr = cleanStr.split(',').last;
    }
    cleanStr = cleanStr.replaceAll(RegExp(r'\s+'), '');
    if (cleanStr.isEmpty) return false;

    // Check if it's an SVG (starts with `<svg` or `<?xml`)
    // `<svg` in base64 starts with `PHN2Zy` or `PHN2Z`
    // `<?xml` in base64 starts with `PD94bW`
    if (cleanStr.startsWith('PHN2Z') || cleanStr.startsWith('PD94bW')) {
      print("[CandidateCubit] Image is SVG/XML placeholder, skipping raster load.");
      return false;
    }

    try {
      final bytes = base64Decode(cleanStr);
      if (bytes.isEmpty) return false;

      if (bytes.length > 4) {
        final isPng = bytes[0] == 137 && bytes[1] == 80 && bytes[2] == 78 && bytes[3] == 71;
        final isJpeg = bytes[0] == 255 && bytes[1] == 216 && bytes[2] == 255;
        final isGif = bytes[0] == 71 && bytes[1] == 73 && bytes[2] == 70;
        final isWebp = bytes[0] == 82 && bytes[1] == 73 && bytes[2] == 70 && bytes[3] == 70;

        if (!isPng && !isJpeg && !isGif && !isWebp) {
          final headerString = String.fromCharCodes(bytes.take(20)).toLowerCase();
          if (headerString.contains('<svg') || headerString.contains('<?xml') || headerString.contains('<!doctype')) {
            print("[CandidateCubit] Decoded header contains XML/SVG tags, skipping.");
            return false;
          }
        }
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  String? _normalizeBase64Image(String? base64Str) {
    if (!_isValidRasterImage(base64Str)) return null;
    var cleanStr = base64Str!.trim();
    if (cleanStr.contains(',')) {
      cleanStr = cleanStr.split(',').last;
    }
    return cleanStr.replaceAll(RegExp(r'\s+'), '');
  }

  /// 🌐 FETCH CANDIDATES DYNAMICALLY FROM ODOO BACKEND
  Future<void> loadCandidates() async {
    print("[CandidateCubit] loadCandidates() started. Querying 'hr.applicant' from Odoo...");
    emit(state.copyWith(isLoading: true));
    try {
      // 1. Get valid fields from Odoo dynamically to prevent server ValueError
      Map<String, dynamic>? fieldsInfo;
      try {
        final rawFields = await _svc.executeModelMethod(
          'hr.candidate',
          'fields_get',
          [],
          kwargs: {'attributes': ['type']},
        );
        if (rawFields is Map) {
          fieldsInfo = Map<String, dynamic>.from(rawFields);
          // Print all fields on the hr.candidate model to inspect them for skills relation field names
          print("[DEBUG] hr.candidate available fields from Odoo fields_get: ${fieldsInfo.keys.toList()}");
          try {
            // Write to a local file to read the schema details directly
            final file = File('fields_log.txt');
            file.writeAsStringSync(fieldsInfo.keys.toList().toString());
          } catch (_) {}
        }
      } catch (fe) {
        print("[CandidateCubit] fields_get failed, falling back to defaults. Error: $fe");
      }

      // We ask for both 'candidate_skill_ids' and 'skill_ids' to support different Odoo model variations.
      // The dynamically loaded fieldsInfo map will filter out whichever fields are not active on the server.
      final List<String> requestedFields = [
        'id',
        'name',
        'partner_id',
        'partner_name',
        'email_from',
        'partner_phone',
        'type_id',
        'degree_id',
        'user_id',
        'priority',
        'availability',
        'company_id',
        'stage_id',
        'recruitment_stage_id',
        'resume',
        'candidate_skill_ids',
        'skill_ids',
        'categ_ids',
        // Potential fields for LinkedIn profile
        'linkedin_profile',
        'linkedin',
        'linkedin_url',
        'x_linkedin',
        'x_linkedin_profile',
        'social_linkedin',
        // Potential fields for Alternate Phone / Private Phone
        'private_phone',
        'alternate_phone',
        'alternate_mobile',
        'mobile',
        'phone_alternate',
        'phone_private',
        'x_alternate_phone',
        // Potential image fields from Odoo
        'image_128',
        'image_medium',
        'image_1920',
        'image',
      ];

      // Only select fields that actually exist on the Odoo server (dynamic fallback)
      final List<String> activeFields = fieldsInfo != null
          ? requestedFields.where((f) => fieldsInfo!.containsKey(f)).toList()
          : requestedFields;

      print("[CandidateCubit] loadCandidates() Odoo active fields: $activeFields");

      final candidatesRes = await _svc.executeModelMethod(
        'hr.candidate',
        'search_read',
        [[['active', '=', true]]],
        kwargs: {
          'fields': activeFields,
        },
      );

      print("[CandidateCubit] loadCandidates() Odoo raw response type: ${candidatesRes.runtimeType}");
      if (candidatesRes is List) {
        print("[CandidateCubit] loadCandidates() fetched ${candidatesRes.length} records successfully.");
        
        // -----------------------------------------------------------------
        // BULK FETCH CANDIDATE SKILL DETAILS FROM 'hr.candidate.skill'
        // -----------------------------------------------------------------
        final List<int> allCandidateSkillIds = [];
        final List<int> partnerIds = [];
        for (var e in candidatesRes) {
          // Identify if the field returned is candidate_skill_ids or skill_ids
          final skillField = e['candidate_skill_ids'] ?? e['skill_ids'];
          if (skillField is List) {
            for (var id in skillField) {
              if (id is int) {
                allCandidateSkillIds.add(id);
              }
            }
          }

          // Identify linked res.partner IDs for fetching contact photos
          final partnerVal = e['partner_id'];
          if (partnerVal is List && partnerVal.isNotEmpty && partnerVal[0] is int) {
            partnerIds.add(partnerVal[0] as int);
          }
        }

        // Fetch Odoo candidate skills in bulk to minimize RPC requests
        final Map<int, HrCandidateSkill> skillMap = {};
        if (allCandidateSkillIds.isNotEmpty) {
          try {
            print("[CandidateCubit] Bulk fetching skill details for IDs: $allCandidateSkillIds");
            final skillDetails = await _svc.executeModelMethod(
              'hr.candidate.skill',
              'search_read',
              [[['id', 'in', allCandidateSkillIds]]],
              kwargs: {
                'fields': ['id', 'skill_type_id', 'skill_id', 'skill_level_id'],
              },
            );
            if (skillDetails is List) {
              for (var sd in skillDetails) {
                final id = sd['id'] as int;
                
                // Parse Skill Type Many2one field
                final typeVal = sd['skill_type_id'];
                final typeName = typeVal is List && typeVal.length > 1 ? typeVal[1].toString() : '';
                
                // Parse Skill Many2one field
                final skillVal = sd['skill_id'];
                final skillName = skillVal is List && skillVal.length > 1 ? skillVal[1].toString() : '';
                
                // Parse Skill Level Many2one field
                final levelVal = sd['skill_level_id'];
                final levelName = levelVal is List && levelVal.length > 1 ? levelVal[1].toString() : 'Intermediate';

                skillMap[id] = HrCandidateSkill(
                  skillTypeId: typeName,
                  skillId: skillName,
                  skillLevel: levelName,
                );
              }
              print("[CandidateCubit] Successfully mapped ${skillMap.length} skills in local dictionary.");
            }
          } catch (se) {
            print("[CandidateCubit] Bulk fetch of hr.candidate.skill failed: $se");
          }
        }

        // Fetch Odoo res.partner images in bulk
        final Map<int, String> partnerImageMap = {};
        if (partnerIds.isNotEmpty) {
          try {
            print("[CandidateCubit] Bulk fetching partner images for ResPartner IDs: $partnerIds");
            final partnerDetails = await _svc.executeModelMethod(
              'res.partner',
              'search_read',
              [[['id', 'in', partnerIds]]],
              kwargs: {
                'fields': ['id', 'image_128'],
              },
            );
            if (partnerDetails is List) {
              for (var pd in partnerDetails) {
                final id = pd['id'] as int;
                final img = pd['image_128'];
                if (img is String && img.isNotEmpty) {
                  partnerImageMap[id] = img;
                }
              }
              print("[CandidateCubit] Successfully mapped ${partnerImageMap.length} partner images.");
            }
          } catch (pe) {
            print("[CandidateCubit] Bulk fetch of partner images failed: $pe");
          }
        // Fetch Odoo candidate tags/categories in bulk
        final Map<int, String> tagMap = {};
        try {
          print("[CandidateCubit] Fetching tag categories from 'hr.applicant.category'...");
          final tagsRes = await _svc.executeModelMethod(
            'hr.applicant.category',
            'search_read',
            [[]],
            kwargs: {
              'fields': ['id', 'name'],
            },
          );
          if (tagsRes is List) {
            for (var t in tagsRes) {
              final id = t['id'] as int;
              final name = t['name']?.toString() ?? '';
              tagMap[id] = name;
            }
            print("[CandidateCubit] Successfully mapped ${tagMap.length} tag categories.");
          }
        } catch (te) {
          print("[CandidateCubit] Fetch of hr.applicant.category failed: $te");
        }

        final parsed = candidatesRes.map((e) {
          final nameParts = (e['partner_name']?.toString() ?? e['name']?.toString() ?? 'Unknown').split(' ');
          final fName = nameParts.first;
          final lName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : 'Record';

           final degreeVal = e['degree_id'] ?? e['type_id'];
          final degreeName = degreeVal is List && degreeVal.length > 1 ? degreeVal[1].toString() : '';

          final userVal = e['user_id'];
          final userName = userVal is List && userVal.length > 1 ? userVal[1].toString() : '';

          final compVal = e['company_id'];
          final compName = compVal is List && compVal.length > 1 ? compVal[1].toString() : '';

           final stageVal = e['stage_id'] ?? e['recruitment_stage_id'];
          final stageName = stageVal is List && stageVal.length > 1 ? stageVal[1].toString() : 'Applied';

          DateTime avail = DateTime.now();
          if (e['availability'] != null && e['availability'].toString().isNotEmpty) {
            try {
              avail = DateTime.parse(e['availability'].toString());
            } catch (_) {}
          }

          // Parse skills for this candidate from either maps or bulk-fetched ID dictionary
          List<HrCandidateSkill> parsedSkills = [];
          final skillField = e['candidate_skill_ids'] ?? e['skill_ids'];
          if (skillField is List && skillField.isNotEmpty) {
            if (skillField.first is Map) {
              // If Odoo returns list of maps directly
              parsedSkills = skillField.map((s) => HrCandidateSkill.fromJson(Map<String, dynamic>.from(s))).toList();
            } else {
              // If Odoo returns list of IDs, resolve them using our bulk-fetched dictionary
              for (var id in skillField) {
                if (id is int && skillMap.containsKey(id)) {
                  parsedSkills.add(skillMap[id]!);
                }
              }
            }
          }

          // Detect which field was populated for linkedin profile
          final linkedinValue = e['linkedin_profile'] ?? e['linkedin'] ?? e['linkedin_url'] ?? e['x_linkedin'] ?? e['x_linkedin_profile'] ?? e['social_linkedin'];
          final parsedLinkedin = (linkedinValue is String && linkedinValue.isNotEmpty) ? linkedinValue : null;

          // Detect which field was populated for alternate phone
          final altPhoneValue = e['private_phone'] ?? e['alternate_phone'] ?? e['alternate_mobile'] ?? e['mobile'] ?? e['phone_alternate'] ?? e['phone_private'] ?? e['x_alternate_phone'];
          final parsedAltPhone = (altPhoneValue is String && altPhoneValue.isNotEmpty) 
              ? altPhoneValue 
              : (altPhoneValue is int) 
                  ? altPhoneValue.toString() 
                  : (altPhoneValue == false) ? null : altPhoneValue?.toString();

          // Detect which field was populated for profile image (base64)
          // Fall back to partner image_128 if direct candidate photo doesn't exist
          dynamic rawImage = e['image_128'] ?? e['image_medium'] ?? e['image_1920'] ?? e['image'];
          if (rawImage == null || rawImage == false || rawImage.toString().isEmpty) {
            final partnerVal = e['partner_id'];
            if (partnerVal is List && partnerVal.isNotEmpty && partnerVal[0] is int) {
              final partnerId = partnerVal[0] as int;
              rawImage = partnerImageMap[partnerId];
            }
          }
          final parsedImage = _normalizeBase64Image(rawImage?.toString());


          print("[CandidateCubit]   -> Loaded Candidate: $fName $lName, Email: ${e['email_from']}, Stage: $stageName, Skills: ${parsedSkills.length}, AltPhone: $parsedAltPhone, Linkedin: $parsedLinkedin, HasImage: ${parsedImage != null}");

          // Fix email parsing - handle boolean false values from Odoo
          final emailValue = e['email_from'];
          final emailFromValue = (emailValue is String && emailValue.isNotEmpty)
              ? emailValue
              : (emailValue == false || emailValue == 'false')
                  ? 'no-email@odoo.com'
                  : emailValue?.toString() ?? 'no-email@odoo.com';

            // Parse tags/categ_ids
            List<String> parsedTags = [];
            final categField = e['categ_ids'];
            if (categField is List) {
              for (var id in categField) {
                if (id is int && tagMap.containsKey(id)) {
                  parsedTags.add(tagMap[id]!);
                } else if (id is Map && id.containsKey('name')) {
                  parsedTags.add(id['name'].toString());
                }
              }
            }

            return HrCandidate(
              odooId: e['id'] is int ? e['id'] as int : int.tryParse(e['id']?.toString() ?? ''),
              firstName: fName,
              lastName: lName,
              partnerId: e['partner_name']?.toString() ?? e['name']?.toString() ?? 'Contact',
              emailFrom: emailFromValue,
              partnerPhone: e['partner_phone']?.toString() ?? 'Not provided',
              alternatePhone: parsedAltPhone,
              linkedinProfile: parsedLinkedin,
              typeId: degreeName,
              userId: userName,
              priority: e['priority']?.toString() ?? '0',
              availability: avail,
              categIds: parsedTags,
            resume: e['resume']?.toString(),
            companyId: compName,
            skills: parsedSkills,
            image: parsedImage,
            stage: stageName.contains('Screening') 
                ? 'Screening' 
                : (stageName.contains('HR') 
                    ? 'HR Round' 
                    : (stageName.contains('Tech') || stageName.contains('Interview')
                        ? 'Technical Round' 
                        : 'Applied')),
            stageName: stageName,
          ).computeSkillIds().computeMatchingSkillIds(state.activeRequiredSkills);
        }).toList();

        emit(state.copyWith(candidates: parsed, isLoading: false));
      } }else {
        print("[CandidateCubit] loadCandidates() Odoo returned non-list value: $candidatesRes");
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      print("[CandidateCubit] loadCandidates() Error: $e");
      emit(state.copyWith(isLoading: false));
    }
  }

  /// 🌐 FETCH ALL DROPDOWNS DYNAMICALLY FROM ODOO BACKEND
  Future<void> loadBackendDropdowns() async {
    print("[CandidateCubit] loadBackendDropdowns() started. Loading degree, user, company, and skill types from Odoo...");
    emit(state.copyWith(isLoading: true));
    try {
      final degreesRes = await _svc.executeModelMethod(
        'hr.recruitment.degree',
        'search_read',
        [[]],
        kwargs: {'fields': ['id', 'name']},
      );

      final usersRes = await _svc.executeModelMethod(
        'res.users',
        'search_read',
        [[]],
        kwargs: {'fields': ['id', 'name']},
      );

      final companiesRes = await _svc.executeModelMethod(
        'res.company',
        'search_read',
        [[]],
        kwargs: {'fields': ['id', 'name']},
      );

      final skillTypesRes = await _svc.executeModelMethod(
        'hr.skill.type',
        'search_read',
        [[]],
        kwargs: {'fields': ['id', 'name']},
      );

      final skillLevelsRes = await _svc.executeModelMethod(
        'hr.skill.level',
        'search_read',
        [[]],
        kwargs: {'fields': ['id', 'name']},
      );

      final skillsRes = await _svc.executeModelMethod(
        'hr.skill',
        'search_read',
        [[]],
        kwargs: {'fields': ['id', 'name', 'skill_type_id']},
      );

      print("[CandidateCubit] loadBackendDropdowns() Dropdowns fetched successfully:");
      print("   -> Degrees: ${degreesRes is List ? (degreesRes as List).length : 0} items");
      print("   -> Users/Managers: ${usersRes is List ? (usersRes as List).length : 0} items");
      print("   -> Companies: ${companiesRes is List ? (companiesRes as List).length : 0} items");
      print("   -> Skill Types: ${skillTypesRes is List ? (skillTypesRes as List).length : 0} items");
      print("   -> Skills Dictionary: ${skillsRes is List ? (skillsRes as List).length : 0} items");

      emit(state.copyWith(
        degrees: degreesRes is List && degreesRes.isNotEmpty 
            ? List<Map<String, dynamic>>.from(degreesRes.map((e) => {'id': e['id'], 'name': e['name'] ?? 'Unknown'}))
            : state.degrees,
        managers: usersRes is List && usersRes.isNotEmpty 
            ? List<Map<String, dynamic>>.from(usersRes.map((e) => {'id': e['id'], 'name': e['name'] ?? 'Unknown'}))
            : state.managers,
        companies: companiesRes is List && companiesRes.isNotEmpty 
            ? List<Map<String, dynamic>>.from(companiesRes.map((e) => {'id': e['id'], 'name': e['name'] ?? 'Unknown'}))
            : state.companies,
        skillTypes: skillTypesRes is List && skillTypesRes.isNotEmpty 
            ? List<Map<String, dynamic>>.from(skillTypesRes.map((e) => {'id': e['id'], 'name': e['name'] ?? 'Unknown'}))
            : state.skillTypes,
        skillLevels: skillLevelsRes is List && skillLevelsRes.isNotEmpty 
            ? List<Map<String, dynamic>>.from(skillLevelsRes.map((e) => {'id': e['id'], 'name': e['name'] ?? 'Unknown'}))
            : state.skillLevels,
        skills: skillsRes is List && skillsRes.isNotEmpty
            ? List<Map<String, dynamic>>.from(skillsRes.map((e) {
                final typeVal = e['skill_type_id'];
                final typeName = typeVal is List && typeVal.length > 1 ? typeVal[1]?.toString() ?? '' : '';
                return {
                  'id': e['id'],
                  'name': e['name'] ?? 'Unknown',
                  'skill_type_name': typeName,
                };
              }))
            : state.skills,
        isLoading: false,
      ));
    } catch (e) {
      print("[CandidateCubit] loadBackendDropdowns() Error: $e");
      emit(state.copyWith(isLoading: false));
    }
  }

  void changeTab(String tab) {
    emit(state.copyWith(selectedTab: tab));
  }

  void search(String value) {
    emit(state.copyWith(searchQuery: value));
  }

  void selectCandidate(HrCandidate candidate) {
    emit(state.copyWith(selectedCandidate: candidate));
  }

  /// ➕ ADD CANDIDATE (LOCAL PREVIEW & ASYNC CREATE TO ODOO)
  Future<void> addCandidate(HrCandidate candidate) async {
    print("[CandidateCubit] addCandidate() triggered for Candidate: ${candidate.fullName}");
    
    // 1. Add locally first for instant UI response
    final computed = candidate
        .computeSkillIds()
        .computeMatchingSkillIds(state.activeRequiredSkills);
        
    final list = List<HrCandidate>.from(state.candidates)..add(computed);
    emit(state.copyWith(candidates: list));
    print("[CandidateCubit] addCandidate() local state updated.");

    // 2. Call Odoo create method asynchronously
    try {
      // Get valid fields from Odoo dynamically to prevent server ValueError
      Map<String, dynamic>? fieldsInfo;
      try {
        final rawFields = await _svc.executeModelMethod(
          'hr.applicant',
          'fields_get',
          [],
          kwargs: {'attributes': ['type']},
        );
        if (rawFields is Map) {
          fieldsInfo = Map<String, dynamic>.from(rawFields);
        }
      } catch (fe) {
        print("[CandidateCubit] fields_get failed in create. Error: $fe");
      }

      // Find degree ID
      final degreeMap = state.degrees.firstWhere((e) => e['name'] == candidate.typeId, orElse: () => <String, dynamic>{});
      final degreeId = degreeMap['id'];

      // Find user ID
      final userMap = state.managers.firstWhere((e) => e['name'] == candidate.userId, orElse: () => <String, dynamic>{});
      final userId = userMap['id'];

      // Find company ID
      final companyMap = state.companies.firstWhere((e) => e['name'] == candidate.companyId, orElse: () => <String, dynamic>{});
      final companyId = companyMap['id'];

      final Map<String, dynamic> rawVals = {
        'name': "${candidate.firstName} ${candidate.lastName} - Application",
        'partner_name': candidate.fullName,
        'email_from': candidate.emailFrom,
        'partner_phone': candidate.partnerPhone,
        'priority': candidate.priority,
        'availability': candidate.availability.toIso8601String().split('T').first,
        'type_id': degreeId,
        'user_id': userId,
        'company_id': companyId,
      };

      // Only include fields that actually exist on the Odoo server!
      final Map<String, dynamic> createVals = {};
      rawVals.forEach((key, val) {
        if (val != null) {
          if (fieldsInfo == null || fieldsInfo.containsKey(key)) {
            createVals[key] = val;
          } else {
            print("[CandidateCubit] Filtering out unsupported Odoo field: '$key'");
          }
        }
      });

      print("[CandidateCubit] Resolved Odoo relations:");
      print("   -> degreeId: $degreeId ('${candidate.typeId}')");
      print("   -> userId: $userId ('${candidate.userId}')");
      print("   -> companyId: $companyId ('${candidate.companyId}')");
      print("[CandidateCubit] Final Odoo creation payload after dynamic filtering: $createVals");

      final createRes = await _svc.executeModelMethod(
        'hr.applicant',
        'create',
        [createVals],
      );
      print("[CandidateCubit] Odoo creation response: $createRes");
      
      // Refresh list to pull fully-mapped record and IDs from Odoo
      await loadCandidates();
    } catch (e) {
      print("[CandidateCubit] Odoo Create Exception caught: $e");
    }
  }

  /// 🔄 UPDATE CANDIDATE STAGE
  void moveCandidate(String email, String newStage) {
    final updated = state.candidates.map((c) {
      if (c.emailFrom == email) {
        return c.copyWith(stage: newStage, stageName: newStage);
      }
      return c;
    }).toList();

    emit(state.copyWith(candidates: updated));
    
    // Also update selected candidate if it matches
    if (state.selectedCandidate?.emailFrom == email) {
      final updatedSel = state.selectedCandidate!.copyWith(stage: newStage, stageName: newStage);
      emit(state.copyWith(selectedCandidate: updatedSel));
    }
  }

  /// 🛠️ Odoo Action: Matching Candidate Skills
  /// Compares candidate skills with job-required skills and calculates the matching percentage score.
  void executeMatchingSkills(String email) {
    final updated = state.candidates.map((c) {
      if (c.emailFrom == email) {
        return c.computeSkillIds().computeMatchingSkillIds(state.activeRequiredSkills);
      }
      return c;
    }).toList();

    emit(state.copyWith(candidates: updated));

    // Update selected candidate if matches
    final found = updated.firstWhere((c) => c.emailFrom == email);
    emit(state.copyWith(selectedCandidate: found));
  }

  /// 🛠️ Odoo Action: Candidate Skill Mapping
  /// Automatically updates candidate skills list from lines.
  void updateCandidateSkills(String email, List<HrCandidateSkill> newSkills) {
    final updated = state.candidates.map((c) {
      if (c.emailFrom == email) {
        final withSkills = c.copyWith(skills: newSkills);
        return withSkills.computeSkillIds().computeMatchingSkillIds(state.activeRequiredSkills);
      }
      return c;
    }).toList();

    emit(state.copyWith(candidates: updated));

    // Update selected candidate if matches
    final found = updated.firstWhere((c) => c.emailFrom == email);
    emit(state.copyWith(selectedCandidate: found));
  }

  /// 🛠️ Odoo Action: Create Job Application
  /// Generates applicant records linked to the selected job.
  void executeCreateJobApplication(String email) {
    final updated = state.candidates.map((c) {
      if (c.emailFrom == email) {
        return c.actionCreateApplication("JOB-POS-FLUTTER");
      }
      return c;
    }).toList();

    emit(state.copyWith(candidates: updated));

    // Update selected candidate
    final found = updated.firstWhere((c) => c.emailFrom == email);
    emit(state.copyWith(selectedCandidate: found));
  }
}
