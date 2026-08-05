import 'package:equatable/equatable.dart';
import 'package:flutter_app/features/profile/models/expense_model.dart';

abstract class HelpDeskState extends Equatable {
  const HelpDeskState();

  @override
  List<Object?> get props => [];
}

class HelpDeskInitial extends HelpDeskState {}

class HelpDeskLoading extends HelpDeskState {}

class HelpDeskLoaded extends HelpDeskState {
  final List<ExpenseModel> expenses;

  const HelpDeskLoaded(this.expenses);

  @override
  List<Object?> get props => [expenses];
}

class HelpDeskError extends HelpDeskState {
  final String message;

  const HelpDeskError(this.message);

  @override
  List<Object?> get props => [message];
}