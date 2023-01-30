class Merchant {
  int? id;
  String? name;
  double? distance;

  Merchant({
    this.id,
    this.name,
    this.distance,
  });

  Merchant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    distance = json['distance'];
  }

  @override
  String toString() => 'Merchant(id: $id, name: $name, distance: $distance)';
}
