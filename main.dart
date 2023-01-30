import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/info.dart';
import 'models/offer.dart';
import 'utils/convert_date.dart';

void main() async {
  Info info = await getData();

  List<Offer> validOffersWithEligileCategory =
      info.findValidOffersAndEligileCategory();

  List<List<Offer>> offersSameCategory =
      findSameCategories(validOffersWithEligileCategory);

  List<Offer> result = [];

  for (int i = 0; i < offersSameCategory.length; i++) {
    List<Offer> offers = offersSameCategory[i];

    if (offers.length >= 2) {
      Offer offer = findOfferWithNearestMerchant(offers);
      result.add(offer);
    } else {
      result.add(offers[0]);
    }
  }

  result.sort(
      (a, b) => a.merchants![0].distance!.compareTo(b.merchants![0].distance!));

  List<Offer> bestOffers = findTwoOffers(result);

  String resultString = '';

  for (var offer in bestOffers) {
    resultString += "$offer\n";
  }
  print(resultString);
}

List<Offer> findTwoOffers(List<Offer> offers) {
  List<Offer> result = [];
  if (offers.length >= 2) {
    result.add(offers[0]);
    result.add(offers[1]);
  } else {
    result.addAll(offers);
  }
  return result;
}

Offer findOfferWithNearestMerchant(List<Offer> offers) {
  Offer tmp = offers[0];

  for (var offer in offers) {
    if (offer.merchants![0].distance! < tmp.merchants![0].distance!) {
      tmp = offer;
    }
  }

  return tmp;
}

List<List<Offer>> findSameCategories(List<Offer> offers) {
  List<List<Offer>> result = [];
  List<Offer> offerRestaurants = [];
  List<Offer> offerRetails = [];
  List<Offer> offerActivities = [];

  for (int i = 0; i < offers.length; i++) {
    Offer offer = offers[i];
    switch (offer.category) {
      case 1:
        offerRestaurants.add(offer);
        break;
      case 2:
        offerRetails.add(offer);
        break;
      default:
        offerActivities.add(offer);
        break;
    }
  }

  result.add(offerRestaurants);
  result.add(offerRetails);
  result.add(offerActivities);

  return result;
}

Future<Info> getData() async {
  dynamic responseJson;
  const url =
      "https://61c3deadf1af4a0017d990e7.mockapi.io/offers/near_by?lat=1.313492&lon=103.860359&rad=20";
  String checkInDate = "2019-12-25";
  DateTime checkIn = convertDate(checkInDate);

  try {
    final response = await http.get(Uri.parse(url));
    responseJson = jsonDecode(response.body);
  } catch (e) {
    print('error: $e');
  }

  Info info = Info.fromJson(responseJson);
  info.setCheckIn(checkIn);

  return info;
}
