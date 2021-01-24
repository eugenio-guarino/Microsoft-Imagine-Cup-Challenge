// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'package:flutter/material.dart';
import 'food_data.dart';

class AddNew extends StatefulWidget {

  AddNew();

  @override
  _AddNewState createState() => _AddNewState();
}

class _AddNewState extends State<AddNew> {
  ExpirationDateEntry formData = ExpirationDateEntry();

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
                      formData.name = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Expiration date',
                    ),
                    obscureText: true,
                    onChanged: (value) {
                      formData.date = value;
                    },
                  ),
                  FlatButton(
                    child: Text('Submit'),
                    onPressed: () {},
                  ),
                ].expand(
                  (widget) => [
                    widget,
                    SizedBox(
                      height: 24,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          FlatButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
