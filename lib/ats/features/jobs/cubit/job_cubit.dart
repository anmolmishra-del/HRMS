import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/features/jobs/model/model_class.dart';
import 'package:flutter_app/ats/features/jobs/repository/create_job_servic.dart';
import 'package:flutter_app/ats/features/jobs/repository/hr_job_service file.dart';

import 'package:flutter_app/ats/core/services/odoo_service.dart';
import 'package:flutter_app/ats/core/constants/api_config.dart';
import '../state/job_state.dart';

class JobCubit extends Cubit<JobState> {
  final HrJobService _service;

  JobCubit({HrJobService? service})
      : _service = service ?? HrJobService(),
        super(JobState.initial());

  Future<void> fetchJobs() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final jobs = await _service.fetchJobs();
      emit(state.copyWith(jobs: jobs, isLoading: false, error: null));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void changeTab(String tab) {
    emit(state.copyWith(selectedTab: tab));
  }

  void search(String value) {
    emit(state.copyWith(searchQuery: value));
  }

  void setJobs(List<JobData> jobs) {
    emit(state.copyWith(jobs: jobs));
  }

  void addJob(JobData job) {

    final updatedJobs = List<JobData>.from(state.jobs)
      ..insert(0, job);

    emit(state.copyWith(jobs: updatedJobs));
  }

  void updateJob(
    JobData oldJob,
    JobData newJob,
  ) {

    final updatedJobs = List<JobData>.from(state.jobs);

    int idx = -1;

    if (newJob.id != null) {

      idx = updatedJobs.indexWhere(
        (j) => j.id == newJob.id,
      );
    }

    // fallback to match by title+department if no id
    if (idx == -1) {

      idx = updatedJobs.indexWhere(
        (j) =>
            j.title == oldJob.title &&
            j.department == oldJob.department,
      );
    }

    if (idx != -1) {

      updatedJobs[idx] = newJob;

      emit(state.copyWith(
        jobs: updatedJobs,
      ));

    } else {

      updatedJobs.insert(0, newJob);

      emit(state.copyWith(
        jobs: updatedJobs,
      ));
    }
  }

  Future<void> togglePublishStatus(JobData job) async {
    final updatedIsPublished = !job.isPublished;
    
    final newJob = JobData(
      id: job.id,
      jobId: job.jobId,
      title: job.title,
      department: job.department,
      category: job.category,
      experience: job.experience,
      primarySkills: job.primarySkills,
      secondarySkills: job.secondarySkills,
      location: job.location,
      salary: job.salary,
      type: job.type,
      status: job.status,
      newCount: job.newCount,
      description: job.description,
      responsibilities: job.responsibilities,
      requirements: job.requirements,
      isPublished: updatedIsPublished,
      priority: job.priority,
      company: job.company,
      noOfRecruitment: job.noOfRecruitment,
      noOfEligibleSubmissions: job.noOfEligibleSubmissions,
    );
    
    updateJob(job, newJob);

    try {
      final odoo = OdooService(ApiConfig.baseUrl);
      
      if (job.id != null) {
        try {
          await odoo.executeModelMethod(
            'hr.job.recruitment',
            'write',
            [[job.id], {'is_published': updatedIsPublished, 'website_published': updatedIsPublished}],
          );
        } catch (_) {}
      }
      
      if (job.jobId != null) {
        try {
          await odoo.executeModelMethod(
            'hr.job',
            'write',
            [[job.jobId], {'website_published': updatedIsPublished}],
          );
        } catch (_) {}
      }
    } catch (e) {
      print("Failed to sync publish status to Odoo: $e");
      updateJob(newJob, job);
    }
  }
}

class RecruitmentCubit
    extends Cubit<RecruitmentState> {

  final RecruitmentService service;

  RecruitmentCubit(this.service)
      : super(RecruitmentState.initial());

  Future<void> fetchRecruitments() async {

    emit(state.copyWith(
      loading: true,
    ));

    try {

      final data =
          await service.fetchRecruitments();

      emit(
        state.copyWith(
          recruitments: data,
          loading: false,
        ),
      );

    } catch (e) {

      emit(
        state.copyWith(
          loading: false,
        ),
      );
    }
  }
}