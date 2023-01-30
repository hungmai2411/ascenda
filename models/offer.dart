import '../utils/convert_date.dart';
import 'merchant.dart';

class Offer {
  int? id;
  String? title;
  String? description;
  int? category;
  List<Merchant>? merchants;
  DateTime? validTo;

  Offer({
    this.id,
    this.title,
    this.description,
    this.category,
    this.merchants,
    this.validTo,
  });

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        category: json["category"],
        merchants: json["merchants"] == null
            ? []
            : List<Merchant>.from(
                json["merchants"].map((x) => Merchant.fromJson(x))),
        validTo: convertDate(json["valid_to"]),
      );

  bool isValidOffer(DateTime checkIn) {
    if (checkIn.add(const Duration(days: 5)).compareTo(validTo!) == -1) {
      return true;
    }

    return false;
  }

  bool isEligibleCategory() {
    if (category == 3) {
      return false;
    }

    return true;
  }

  void findNearestMerchant() {
    if (merchants!.length == 1) {
      return;
    }

    late double distance;
    late Merchant result;

    result = merchants![0];
    distance = result.distance!;

    for (var merchant in merchants!) {
      if (merchant.distance! < distance) {
        result = merchant;
        distance = merchant.distance!;
      }
    }

    merchants = [];
    merchants!.add(result);
  }

  @override
  String toString() {
    return 'Offer(id: $id, title: $title, description: $description, category: $category, merchants: $merchants, validTo: $validTo)';
  }
}
