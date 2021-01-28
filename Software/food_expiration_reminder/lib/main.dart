import 'package:flutter/material.dart';
import 'src/notifications.dart';
import 'src/reminders_list.dart';
import 'src/add_new.dart';
import 'src/settings.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Notifications.initialisePlugin();

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
  final result = Notifications.askIOSpermissions();
  int _currentIndex = 0;
  List<String> titleList = ['Active Reminders', 'New Expiration Date Reminder', 'Settings'];


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
          selectedItemColor: Colors.greenAccent,
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
