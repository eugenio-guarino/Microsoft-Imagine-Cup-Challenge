// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:food_expiration_reminder/src/data_storage.dart';
import 'food_data.dart';
import 'package:flushbar/flushbar.dart';
import 'package:intl/intl.dart';

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
                  controller: _datePickerController,
                  focusNode: AlwaysDisabledFocusNode(),
                  onTap: _selectDate,
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
                    _showDialog('Succesfully added.');
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

    if (newDate != null) {
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