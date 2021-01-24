class FoodData {
  String name;
  String date;

  FoodData(
    this.name,
    this.date,
  );

  factory FoodData.fromJson(dynamic json) {
    return FoodData(json['name'] as String, json['date'] as String);
  }

  Map toJson() => {
    'name': name,
    'date': date,
  };
}
