import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as Io;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class OCRService{
  OCRService();
  static String apiKey = "be1cb7312ed24adfa0355688741729f1";
  static String endpoint = "https://foodexpiration.cognitiveservices.azure.com/vision/v3.1/ocr";

  static Future<Map> parseText() async {
    
    // select picture from gallery
    final _imageFile = await ImagePicker().getImage(source:ImageSource.gallery);
    var bytes = Io.File(_imageFile.path.toString()).readAsBytesSync();

    var payload = bytes;
    var header = {'Content-Type': 'image/png', "Ocp-Apim-Subscription-Key": apiKey};
    var post = await http.post(endpoint,body: payload, headers: header);
    var result = jsonDecode(post.body) as Map;

    return result;
  }
  
  static Future<DateTime> imageToDate() async {

    var result = await OCRService.parseText();

    RegExp regExp = RegExp('(?<="text"\ *:\ *")(?:\\"|[^"])*');


    // String text = regExp.stringMatch();
    // DateTime date = DateFormat('dd/MM/yy').parse(text);
    return null;
  }

}

