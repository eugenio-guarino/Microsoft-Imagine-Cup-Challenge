import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'data_storage.dart';

class Settings extends StatelessWidget {
  final DataStorage storage = DataStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: TextButton(
            child: Text('Reset'),
            onPressed: deleteAllFoodEntries,
            ),
        ),
    );
  }

    void deleteAllFoodEntries() {
      storage.deleteFile();
  }
}