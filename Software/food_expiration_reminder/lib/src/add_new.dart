// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:food_expiration_reminder/src/data_storage.dart';
import 'food_data.dart';
import 'package:flushbar/flushbar.dart';

class AddNew extends StatefulWidget {

  final DataStorage storage = DataStorage();
  AddNew();

  @override
  _AddNewState createState() => _AddNewState();
}

class _AddNewState extends State<AddNew> {
  List<FoodData> _dataList = <FoodData>[];
  String _name = "";
  String _date = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                ...[
                  TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Broccoli, Bacon, Pizza',
                      labelText: 'Food name',
                    ),
                    onChanged: (value) {
                      _name = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Expiration date',
                    ),
                    onChanged: (value) {
                      _date = value;
                    },
                  ),
                  TextButton(
                    child: Text('Submit'),
                    onPressed: () async{
                        widget.storage.readData().then((List<FoodData> value) {
                        setState(() {
                          _dataList.clear();
                          _dataList.addAll(value);
                        });
                      });

                      _dataList.add(FoodData(_name,_date));

                      widget.storage.writeData(_dataList);   
                      _showDialog('Succesfully added.');   
                    },
                  ),
                ]
              ]
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(String message) {
    Flushbar(
      message: message,
      duration:  Duration(seconds: 3)
    )..show(context);
  }
}
