import 'package:flutter_app/ats/features/offer_accept/model/model_class.dart';


class OfferRepository {
  Future<OfferAcceptedModel> getOfferDetails() async {
    await Future.delayed(const Duration(seconds: 2));

    return OfferAcceptedModel(
      candidateName: 'Arjun Mehta',
      joiningDate: '25 May 2024',
      role: 'Flutter Developer',
      company: 'Opsentra Technologies',
    );
  }
}
