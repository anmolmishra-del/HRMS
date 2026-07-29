import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/features/offer_accept/repository/repository.dart';
import 'package:flutter_app/ats/features/offer_accept/state/offer_accept_state.dart';



class OfferAcceptedCubit extends Cubit<OfferAcceptedState> {
  final OfferRepository repository;

  OfferAcceptedCubit(this.repository)
      : super(OfferAcceptedInitial());

  Future<void> loadOfferDetails() async {
    try {
      emit(OfferAcceptedLoading());

      final response = await repository.getOfferDetails();

      emit(OfferAcceptedLoaded(response));
    } catch (e) {
      emit(OfferAcceptedError(e.toString()));
    }
  }
}
