import 'package:flutter/material.dart';
import 'package:food_expiration_reminder/src/data_storage.dart';
import 'food_data.dart';
import 'package:flushbar/flushbar.dart';
import 'package:intl/intl.dart';
import 'notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as Io;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'apikey.dart';


class AddNew extends StatefulWidget {
  final DataStorage storage = DataStorage();

  AddNew();

  @override
  _AddNewState createState() => _AddNewState();
}

class _AddNewState extends State<AddNew> {
  String _name = "";
  String _parsedText = "";
  bool _showClearButton = false;
  bool _nameAdded = false;
  bool _dateAdded = false;
  DateTime _date = new DateTime.now();
  TextEditingController _datePickerController = TextEditingController();
  TextEditingController _foodNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _foodNameController.addListener(() {
      setState(() {
        _showClearButton = _foodNameController.text.length > 0;
      });
    });
  }

  Widget _getClearButton() {
    if (!_showClearButton) {
      return null;
    }
    return IconButton(
      onPressed: () => _foodNameController.clear(),
      icon: Icon(Icons.clear),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Container(
          padding: EdgeInsets.all(40),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  // ignore: missing_return
                  validator: (String txt) {
                    if (txt.length > 0) {
                      _nameAdded = true;
                    } else {
                      _nameAdded = false;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "What's in your fridge?",
                    suffixIcon: _getClearButton(),
                    labelText: 'Food name',
                  ),
                  controller: _foodNameController,
                  onChanged: (value) {
                    _name = value;
                  },
                ),
                Stack(alignment: Alignment.centerRight, children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.always,
                    // ignore: missing_return
                    validator: (String txt) {
                      if (txt.length > 0) {
                        _dateAdded = true;
                      } else {
                        _dateAdded = false;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Expiration date',
                    ),
                    controller: _datePickerController,
                    focusNode: AlwaysDisabledFocusNode(),
                    onTap: _selectDate,
                  ),
                  IconButton(
                    icon: Icon(Icons.photo_camera),
                    onPressed: () => _parseText(),
                  ),
                ]),
                TextButton(
                  child: Text('Create'),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    primary: Colors.white,
                    textStyle: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onPressed: (_nameAdded && _dateAdded)
                      ? () async {
                          widget.storage
                              .readData()
                              .then((List<FoodData> value) {
                            int newID = 0;
                            if (value != null && value.isNotEmpty) {
                              newID = value.fold<int>(
                                      0,
                                      (max, food) =>
                                          food.id > max ? food.id : max) +
                                  1;
                            }
                            FoodData newFoodData =
                                new FoodData(_name, _date, newID);
                            List<FoodData> newList = [newFoodData] + value;
                            widget.storage.writeData(newList);
                            Notifications.scheduleNotification(newFoodData);
                          });
                          _foodNameController.clear();
                          _datePickerController.clear();
                          _showDialog('Succesfully added.');
                        }
                      : null,
                ),
              ]),
        ),
      ),
    );
  }

  void _selectDate() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    var todaysDate = new DateTime.now();
    final DateTime newDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: todaysDate,
      //add one year to get the max boundary
      lastDate: todaysDate.add(Duration(days: 365)),
      helpText: 'Select a date',
    );

    if (newDate != null && _date == DateTime.now()) {
      _date = newDate;
      _datePickerController
        ..text = DateFormat.yMMMd().format(_date)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _datePickerController.text.length,
            affinity: TextAffinity.upstream));
    }
  }

  void _showDialog(String message) {
    Flushbar(message: message, duration: Duration(seconds: 1))..show(context);
  }
  
  
  void _parseText() async {
    final _imageFile = await ImagePicker().getImage(source:ImageSource.gallery);

    var bytes = Io.File(_imageFile.path.toString()).readAsBytesSync();

    //String img64 = base64Encode(bytes);

    var url = 'https://foodexpiration.cognitiveservices.azure.com/vision/v3.1/ocr';
    var payload = bytes;
    var header = {'Content-Type': 'image/png', "Ocp-Apim-Subscription-Key": apiKey};
    var post = await http.post(url=url,body: payload, headers: header);

    var result = jsonDecode(post.body);
    print(result);
    setState(() {
      _parsedText = result['ParsedResults'][0]['ParsedText'];
    });
    _textToDate();
  }
  
  void _textToDate() {
    var splitText = _parsedText.split("/");
    String combinedDate = splitText[0].substring(splitText[0].length-2) + "/" + splitText[1].substring(splitText[1].length-2) + "/" + splitText[2].substring(0, 2);
    print(splitText[0] + "  " + splitText[1] + "  " + splitText[2]);
    print(combinedDate);
    _date = DateFormat('dd/MM/yy').parse(combinedDate);
    _datePickerController
      ..text = DateFormat('dd/MM/yy').format(_date)
      ..selection = TextSelection.fromPosition(TextPosition(
          offset: _datePickerController.text.length,
          affinity: TextAffinity.upstream));
    print(_date);
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
