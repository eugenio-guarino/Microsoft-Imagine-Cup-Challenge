import 'package:flutter/material.dart';
import 'src/reminders_list.dart';
import 'src/add_new.dart';
import 'src/settings.dart';
import 'package:path_provider/path_provider.dart';

void main () {
  runApp(FormApp());
}

class FormApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FormAppState();
  }
}

class _FormAppState extends State<FormApp> {
  final directory = getApplicationDocumentsDirectory();
  int _currentIndex = 0;
  List<String> titleList = ['BEST BEFORE dates', 'Add food', 'Settings'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.amber,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: new Text(titleList[_currentIndex]),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: onTabTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: 'Food reminders',
              icon: Icon(Icons.format_list_bulleted),
            ),
            BottomNavigationBarItem(
              label: 'Add food',
              icon: Icon(Icons.add),
            ),
            BottomNavigationBarItem(
              label: 'Settings',
              icon: Icon(Icons.settings),
            ),
          ],
          selectedItemColor: Colors.amber[800],
          currentIndex: _currentIndex,
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            RemindersList(),
            AddNew(),
            Settings(),    
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
