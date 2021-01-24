import 'package:flutter/material.dart';
import 'data_storage.dart';
import 'food_data.dart';

class RemindersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FooDataEntries();
  }
}

class FooDataEntries extends StatefulWidget {
  final DataStorage storage = DataStorage();

  @override
  _FooDataEntriesState createState() => _FooDataEntriesState();
}

class _FooDataEntriesState extends State<FooDataEntries> {
  final List<FoodData> _dataList = new List<FoodData>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildListOfReminders(),
    );
  }

  Widget _buildListOfReminders() {
    widget.storage.readData().then((List<FoodData> value) {
      setState(() {
        _dataList.clear();
        _dataList.addAll(value);
      });
    });
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _dataList.length,
      itemBuilder: (context, index) {
        return _buildRow(_dataList[index]);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  Widget _buildRow(FoodData food) {
    return ListTile(
      title: Text(
        food.name + " " + food.date,
        style: _biggerFont,
      ),
      trailing: Icon(
        Icons.delete,
        color: Colors.red,
      ),
      onTap: () {},
    );
  }
}
