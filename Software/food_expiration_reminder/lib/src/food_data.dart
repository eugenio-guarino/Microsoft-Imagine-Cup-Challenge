class FoodData {
  String name;
  DateTime date;
  int id;

  FoodData(
    this.name,
    this.date,
    this.id
  );

  factory FoodData.fromJson(dynamic json) {
    return FoodData(json['name'] as String, DateTime.parse(json['date'] as String), json['id'] as int);
  }

  Map toJson() => {
    'name': name,
    'date': date.toString(),
    'id': id,
  };
}
