import 'package:flutter/material.dart';
import 'src/reminders_list.dart';

void main() {
  runApp(FormApp());
}

class FormApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FormAppState();
  }
}

class _FormAppState extends State<FormApp> {
  int _currentIndex = 0;
  List<String> titleList = ['Reminder', 'Add new', 'Settings'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: new Text(titleList[_currentIndex]),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
              title: Text('Reminders'),
              icon: Icon(Icons.format_list_bulleted),
            ),
            BottomNavigationBarItem(
              title: Text('Add reminder'),
              icon: Icon(Icons.add),
            ),
            BottomNavigationBarItem(
              title: Text('Settings'),
              icon: Icon(Icons.settings),
            ),
          ],
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            RemindersList(),
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
