import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as Io;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ComputerVisionAPI {
  ComputerVisionAPI();
  static String apiKey = "be1cb7312ed24adfa0355688741729f1";
  static String endpoint =
      "https://foodexpiration.cognitiveservices.azure.com/vision/v3.1/ocr";

  static Future<List<String>> imageToText() async {
    List<String> buffer = new List<String>();
    // select picture from gallery
    final _imageFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    var bytes = Io.File(_imageFile.path.toString()).readAsBytesSync();

    var payload = bytes;
    var header = {
      'Content-Type': 'image/png',
      "Ocp-Apim-Subscription-Key": apiKey
    };
    var post = await http.post(endpoint, body: payload, headers: header);
    var result = jsonDecode(post.body) as Map;

    if (result != null && result["regions"] != null) {
      for (var item in result["regions"]) {
        for (var line in item["lines"]) {
          for (var word in line["words"]) {
            buffer.add(word["text"]);
          }
        }
      }
    }

    return buffer;
  }

  static Future<DateTime> imageToDate() async {
    var text = await ComputerVisionAPI.imageToText();

    DateTime date = _dateParser(text);

    return date;
  }

  static DateTime _dateParser(List<String> buffer) {
    DateTime date;
    for (String text in buffer) {
      date = DateTime.tryParse(text);
      if (date != null) {
        break;
      }
    }

    if (date == null) {
      for (String text in buffer) {
        try {
          date = DateFormat().add_yMMMd().parse(text);
            break;      
        } catch (e) {}
      }
    }

    if (date == null) {
      for (String text in buffer) {
        try {
          date = DateFormat('d/M/yyyy').parse(text);
            break;     
        } catch (e) {}
      }
    }

    if (date == null) {
      for (String text in buffer) {
        try {
          date = DateFormat('d/M/yy').parse(text);
            break;
        } catch (e) {}
      }
    }

    return date;
  }
}
