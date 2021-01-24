class FoodData {
  String name;
  DateTime date;

  FoodData(
    this.name,
    this.date,
  );

  factory FoodData.fromJson(dynamic json) {
    return FoodData(json['name'] as String, DateTime.parse(json['date'] as String));
  }

  Map toJson() => {
    'name': name,
    'date': date.toString(),
  };
}
