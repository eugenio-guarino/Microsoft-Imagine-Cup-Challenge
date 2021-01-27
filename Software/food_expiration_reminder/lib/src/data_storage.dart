import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'food_data.dart';

class DataStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.json');
  }

  Future<List<FoodData>> readData() async {
    try {
      final file = await _localFile;

      String contents = await file.readAsString();

      var dataObjsJson = jsonDecode(contents) as List;
      List<FoodData> expirationList =
          dataObjsJson.map((dataJson) => FoodData.fromJson(dataJson)).toList();

      return expirationList;
    } catch (e) {
      List<FoodData> emptyList = [];
      return emptyList;
    }
  }

  Future<File> writeData(List<FoodData> data) async {
    final file = await _localFile;

    String jsonData = jsonEncode(data);
    // Write the file
    return file.writeAsString(jsonData);
  }

  Future<int> deleteFile() async {
      try {
        final file = await _localFile;

        await file.delete();
      } catch (e) {
        return 0;
      }
    }
}
