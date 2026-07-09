import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/features/candidatefolder/candidate_screen/state/candidate_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter_app/ats/core/services/odoo_service.dart';
import 'package:flutter_app/ats/core/constants/api_config.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState());

  /// 📄 LOAD RESUME (DYNAMIC FROM ODOO)
  Future<void> loadResume(int? candidateId, [String? email]) async {
    if (candidateId == null && (email == null || email.isEmpty)) {
      print("[ProfileCubit] loadResume() called with null candidateId and empty email");
      emit(state.copyWith(
        loading: false,
        pdfUrl: "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",
      ));
      return;
    }
    
    print("[ProfileCubit] loadResume() started for Odoo Candidate ID: $candidateId, Email: $email");
    emit(state.copyWith(loading: true));
    try {
      final OdooService svc = OdooService(ApiConfig.baseUrl);
      await svc.ensureSession();

      // 0. Check if candidate has a direct resume field value
      bool hasDirectResume = false;
      if (candidateId != null) {
        try {
          print("[ProfileCubit] Querying hr.candidate direct resume field for candidate: $candidateId...");
          final candInfo = await svc.executeModelMethod(
            'hr.candidate',
            'read',
            [[candidateId]],
            kwargs: {
              'fields': ['resume'],
            },
          );
          if (candInfo is List && candInfo.isNotEmpty) {
            final resumeField = candInfo[0]['resume'];
            if (resumeField != null && resumeField != false && resumeField.toString().isNotEmpty) {
              hasDirectResume = true;
              print("[ProfileCubit] Candidate has direct resume binary field populated!");
            }
          }
        } catch (e) {
          print("[ProfileCubit] Error reading direct resume field: $e");
        }
      }

      if (hasDirectResume) {
        final sessionToken = svc.sessionId?.id ?? '';
        final directResumeUrl = "${ApiConfig.baseUrl}/web/content?model=hr.candidate&id=$candidateId&field=resume&download=true";
        print("[ProfileCubit] Found direct candidate resume! Dynamic URL: $directResumeUrl");
        emit(state.copyWith(
          loading: false,
          pdfUrl: directResumeUrl,
          sessionToken: sessionToken,
        ));
        return;
      }
      
      List<dynamic> attachments = [];

      // 1. Try to find attachments directly linked to hr.candidate
      if (candidateId != null) {
        try {
          print("[ProfileCubit] Searching ir.attachment for hr.candidate with ID: $candidateId...");
          final res = await svc.executeModelMethod(
            'ir.attachment',
            'search_read',
            [[
              ['res_model', '=', 'hr.candidate'],
              ['res_id', '=', candidateId],
            ]],
            kwargs: {
              'fields': ['id', 'name', 'url', 'type'],
            },
          );
          if (res is List && res.isNotEmpty) {
            attachments = res;
            print("[ProfileCubit] Found attachments on hr.candidate: $attachments");
          }
        } catch (e) {
          print("[ProfileCubit] Error searching hr.candidate attachments: $e");
        }
      }

      // 2. Try to find attachments linked to hr.applicant via candidate_id
      if (attachments.isEmpty && candidateId != null) {
        try {
          print("[ProfileCubit] Searching hr.applicant records linked to candidate ID: $candidateId...");
          final applicants = await svc.executeModelMethod(
            'hr.applicant',
            'search_read',
            [[
              ['candidate_id', '=', candidateId],
            ]],
            kwargs: {
              'fields': ['id'],
            },
          );
          
          if (applicants is List && applicants.isNotEmpty) {
            final applicantIds = applicants.map((a) => a['id'] as int).toList();
            print("[ProfileCubit] Found linked applicant IDs: $applicantIds. Querying their attachments...");
            final res = await svc.executeModelMethod(
              'ir.attachment',
              'search_read',
              [[
                ['res_model', '=', 'hr.applicant'],
                ['res_id', 'in', applicantIds],
              ]],
              kwargs: {
                'fields': ['id', 'name', 'url', 'type'],
              },
            );
            if (res is List && res.isNotEmpty) {
              attachments = res;
              print("[ProfileCubit] Found attachments on linked applicants: $attachments");
            }
          }
        } catch (e) {
          print("[ProfileCubit] Error searching hr.applicant attachments by candidate_id: $e");
        }
      }

      // 3. Try to find attachments linked to hr.applicant via email
      if (attachments.isEmpty && email != null && email.isNotEmpty) {
        try {
          print("[ProfileCubit] Searching hr.applicant records matching email: $email...");
          final applicants = await svc.executeModelMethod(
            'hr.applicant',
            'search_read',
            [[
              ['email_from', '=', email],
            ]],
            kwargs: {
              'fields': ['id'],
            },
          );
          
          if (applicants is List && applicants.isNotEmpty) {
            final applicantIds = applicants.map((a) => a['id'] as int).toList();
            print("[ProfileCubit] Found applicant IDs by email: $applicantIds. Querying their attachments...");
            final res = await svc.executeModelMethod(
              'ir.attachment',
              'search_read',
              [[
                ['res_model', '=', 'hr.applicant'],
                ['res_id', 'in', applicantIds],
              ]],
              kwargs: {
                'fields': ['id', 'name', 'url', 'type'],
              },
            );
            if (res is List && res.isNotEmpty) {
              attachments = res;
              print("[ProfileCubit] Found attachments on applicants by email: $attachments");
            }
          }
        } catch (e) {
          print("[ProfileCubit] Error searching hr.applicant attachments by email: $e");
        }
      }

      print("[ProfileCubit] Odoo resolved attachment: $attachments");
      
      if (attachments.isNotEmpty) {
        final attachment = attachments.first;
        final attachmentId = attachment['id'];
        
        // Form the dynamic absolute URL to download the attachment from Odoo
        final dynamicResumeUrl = "${ApiConfig.baseUrl}/web/content/$attachmentId?download=true";
        print("[ProfileCubit] Found Odoo resume attachment! Dynamic URL: $dynamicResumeUrl");
        
        final sessionToken = svc.sessionId?.id ?? '';
        emit(state.copyWith(
          loading: false,
          pdfUrl: dynamicResumeUrl,
          sessionToken: sessionToken,
        ));
      } else {
        print("[ProfileCubit] No Odoo resume attachment found. Falling back to default.");
        emit(state.copyWith(
          loading: false,
          pdfUrl: "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",
        ));
      }
    } catch (e) {
      print("[ProfileCubit] Exception loading resume: $e");
      emit(state.copyWith(
        loading: false,
        pdfUrl: "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",
      ));
    }
  }

  /// 📥 DOWNLOAD RESUME (FIXED)
  Future<void> downloadResume(BuildContext context, String url) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Downloading Resume...")),
      );

      // 1️⃣ Permission FIRST
      await Permission.manageExternalStorage.request();

      Directory? dir;

      if (Platform.isAndroid) {
        // safer approach
        dir =  Directory('/storage/emulated/0/Download');
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      final filePath = "${dir.path}/resume.pdf";

      final OdooService svc = OdooService(ApiConfig.baseUrl);
      await svc.ensureSession();
      final sessionToken = svc.sessionId?.id ?? '';

      // 2️⃣ Download file
      await Dio().download(
        url,
        filePath,
        options: Options(
          headers: sessionToken.isNotEmpty ? {'Cookie': 'session_id=$sessionToken'} : null,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Saved at: $filePath")),
      );
    } catch (e) {
      print("Download error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Download Failed")),
      );
    }
  }

  /// ⭐ SHORTLIST
  void shortlist(BuildContext context) {
    emit(state.copyWith(
      isShortlisted: true,
      isRejected: false,
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Candidate Shortlisted")),
    );
  }

  /// ❌ REJECT
  void reject(BuildContext context) {
    emit(state.copyWith(
      isRejected: true,
      isShortlisted: false,
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Candidate Rejected")),
    );
  }

  /// ℹ️ MORE
  void more(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("More Details"),
          content: const Text(
            "Senior Flutter Developer with strong experience in Firebase, APIs and clean architecture.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            )
          ],
        );
      },
    );
  }
}
