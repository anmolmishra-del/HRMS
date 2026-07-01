
import 'package:flutter_app/ats/features/offer_accept/model/model_class.dart';

abstract class OfferAcceptedState  {
  @override
  List<Object?> get props => [];
}

class OfferAcceptedInitial extends OfferAcceptedState {}

class OfferAcceptedLoading extends OfferAcceptedState {}

class OfferAcceptedLoaded extends OfferAcceptedState {
  final OfferAcceptedModel model;

  OfferAcceptedLoaded(this.model);

  @override
  List<Object?> get props => [model];
}

class OfferAcceptedError extends OfferAcceptedState {
  final String message;

  OfferAcceptedError(this.message);

  @override
  List<Object?> get props => [message];
}
