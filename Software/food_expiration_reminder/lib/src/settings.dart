import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'notifications.dart';
import 'data_storage.dart';

class Settings extends StatelessWidget {
  final DataStorage storage = DataStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child:
              Text('Delete all food reminders', 
              style: TextStyle(fontSize: 20)),
          onPressed: () => _showMyDialog(context),
        ),
      ),
    );
  }

  void deleteAllFoodEntries() {
    storage.deleteFile();
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset reminders'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete all the reminders?'),
                Text('This action is irreversible.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                deleteAllFoodEntries();
                Notifications.deleteAllNotifications();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
