// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:food_expiration_reminder/src/data_storage.dart';
import 'food_data.dart';
import 'package:flushbar/flushbar.dart';
import 'package:intl/intl.dart';

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
  DateTime _date = new DateTime.now();
  TextEditingController _datePickerController = TextEditingController();
  TextEditingController _foodNameController = TextEditingController();

  String _parsedText = "";

  parseText() async {
    final _imageFile = await ImagePicker().getImage(source:ImageSource.gallery, maxWidth: 670,   maxHeight: 970);

    var bytes = Io.File(_imageFile.path.toString()).readAsBytesSync();
    String img64 = base64Encode(bytes);

    var url = 'https://api.ocr.space/parse/image';
    var payload = {"base64Image": "data:image/jpg;base64,${img64.toString()}"};
    var header = {"apikey": api_key};
    var post = await http.post(url=url,body: payload,headers: header);

    var result = jsonDecode(post.body);
    setState(() {
      _parsedText = result['ParsedResults'][0]['ParsedText'];
    });
    textToDate();
  }

  textToDate() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(children: [
              ...[
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    hintText: "What's in your fridge?",
                    labelText: 'Food name',
                    
                  ),
                  controller: _foodNameController,
                  onChanged: (value) {
                    _name = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Expiration date',
                  ),
                  controller: (_datePickerController),
                  focusNode: AlwaysDisabledFocusNode(),
                  onTap: _selectDate,
                ),
                RaisedButton(
                  onPressed: () => parseText(),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.amber,
                    size: 40,
                  ),
                ),
                TextButton(
                  child: Text('Submit'),
                  onPressed: () async {
                    widget.storage.readData().then((List<FoodData> value) {
                      List<FoodData> _tempList =
                          [FoodData(_name, _date)] + value;
                      widget.storage.writeData(_tempList);
                    });

                    _foodNameController.clear();
                    _datePickerController.clear();
                    _showDialog('Successfully added.');
                  },
                ),
              ]
            ]),
          ),
        ),
      ),
    );
  }

  void _selectDate() async {
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
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}