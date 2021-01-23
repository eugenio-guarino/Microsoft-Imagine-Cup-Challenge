part of 'add_new.dart';

FormData _$FormDataFromJson(Map<String, dynamic> json) {
  return FormData(
    name: json['name'] as String,
    date: json['date'] as String,
  );
}

Map<String, dynamic> _$FormDataToJson(FormData instance) => <String, dynamic>{
      'name': instance.name,
      'date': instance.date,
    };