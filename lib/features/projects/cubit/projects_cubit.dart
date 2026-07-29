import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/core/utils/shared_pref.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import '../models/project_model.dart';
import 'projects_state.dart';
import 'package:flutter/foundation.dart';

class ProjectsCubit extends Cubit<ProjectsState> {
  ProjectsCubit() : super(const ProjectsState());

  void clearData() {
    emit(const ProjectsState());
  }

  Future<void> fetchProjects() async {
    emit(state.copyWith(status: ProjectsStatus.loading));

    try {
      final prefs = SharedPref();
      final sobj = await prefs.getObject('session');
      var baseUrl = await prefs.getString('baseUrl');

      if (sobj == null || baseUrl == null) {
        emit(state.copyWith(status: ProjectsStatus.error, errorMessage: 'Session expired'));
        return;
      }

      final session = OdooSession.fromJson(sobj);
      final client = OdooClient(baseUrl, sessionId: session);

      var response = await client.callKw({
        'model': 'project.project',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [],
          'fields': [
            'name',
            'description',
            'date_start',
            'date',
            'user_id',
            'task_count',
            'allow_timesheets',
            'partner_id',
            'members_ids',
          ],
          'order': 'name asc',
        },
      });

      List<ProjectModel> projects = (response as List).map((p) => ProjectModel.fromJson(p)).toList();

      final allUserIds = <int>{};
      for (final p in projects) {
        if (p.userId != null) allUserIds.add(p.userId!);
        allUserIds.addAll(p.memberIds);
      }

      if (allUserIds.isNotEmpty) {
        final userDataList = await client.callKw({
          'model': 'res.users',
          'method': 'read',
          'args': [allUserIds.toList()],
          'kwargs': {
            'fields': ['id', 'name', 'image_128'],
          },
        });
        
        final userMap = {
          for (var user in (userDataList as List))
            user['id'] as int: {
              'id': user['id'] as int,
              'name': user['name'].toString(),
              'image': user['image_128'] != false && user['image_128'] != null ? user['image_128'].toString() : null,
            }
        };
        
        for (var i = 0; i < projects.length; i++) {
          final proj = projects[i];
          final List<Map<String, dynamic>> projMembers = [];
          for (final mId in proj.memberIds) {
            if (userMap.containsKey(mId)) {
              projMembers.add(userMap[mId]!);
            }
          }
          
          final managerInfo = proj.userId != null ? userMap[proj.userId!] : null;
          final managerImage = managerInfo != null ? managerInfo['image'] as String? : null;

          projects[i] = proj.copyWith(
            members: projMembers,
            userImage128: managerImage,
          );
        }
      }

      emit(state.copyWith(status: ProjectsStatus.loaded, projects: projects));
    } catch (e) {
      debugPrint('Error fetching projects: $e');
      emit(state.copyWith(status: ProjectsStatus.error, errorMessage: e.toString()));
    }
  }
}
