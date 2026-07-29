import 'package:equatable/equatable.dart';
import 'package:flutter_app/ats/features/onboard_check/model/model_class.dart';

abstract class OnboardingState
    extends Equatable {

  @override
  List<Object?> get props => [];
}

class OnboardingInitial
    extends OnboardingState {}

class OnboardingLoaded
    extends OnboardingState {

  final List<ChecklistModel> items;

  OnboardingLoaded(
    this.items,
  );

  @override
  List<Object?> get props => [items];
}
