import 'offer.dart';

class Info {
  List<Offer>? offers;
  DateTime? checkIn;

  Info({
    this.offers,
    this.checkIn,
  });

  factory Info.fromJson(Map<String, dynamic> json) => Info(
        offers: List<Offer>.from(json["offers"]!.map((x) => Offer.fromJson(x))),
      );

  void setCheckIn(DateTime checkIn) {
    this.checkIn = checkIn;
  }

  List<Offer> findValidOffersAndEligileCategory() {
    List<Offer> result = [];
    for (var offer in offers!) {
      if (offer.isValidOffer(checkIn!) && offer.isEligibleCategory()) {
        offer.findNearestMerchant();
        result.add(offer);
      }
    }

    return result;
  }
}
