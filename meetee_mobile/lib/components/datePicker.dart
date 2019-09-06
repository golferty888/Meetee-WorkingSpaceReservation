import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  final int primaryColor;

  DatePicker({Key key, @required this.primaryColor}) : super(key: key);

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime now = DateTime.now();
  int today = 0;
  int _selectedIndex = 0;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(2019, 8),
        lastDate: DateTime(2022));
    if (picked != null && picked != now)
      setState(() {
        now = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        24.0,
        8.0,
        24.0,
        24.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Select date (${DateFormat('d MMMM yyyy').format(
                  DateTime.now().add(
                    Duration(
                      days: _selectedIndex,
                    ),
                  ),
                ).toString()})',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              selectedDateWithText(today, 'Today', 56.0),
              selectedDateWithText(today + 1, 'Tomorrow', 72.0),
              selectedDate(today + 2),
              selectedDate(today + 3),
              selectedDate(today + 4),
              InkWell(
//                onTap: () => _selectDate(context),
                child: Icon(
                  Icons.calendar_today,
                  size: 24.0,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
    print(index);
  }

  Widget selectedDateWithText(index, text, width) {
    return GestureDetector(
      onTap: () => _onSelected(index),
      child: Container(
        height: 24.0,
        width: width,
        decoration: BoxDecoration(
          color: _selectedIndex != null && _selectedIndex == index
              ? Color(widget.primaryColor)
              : Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(text),
        ),
      ),
    );
  }

  Widget selectedDate(index) {
    return GestureDetector(
      onTap: () => _onSelected(index),
      child: Container(
        height: 24.0,
        width: 32.0,
        decoration: BoxDecoration(
          color: _selectedIndex != null && _selectedIndex == index
              ? Color(widget.primaryColor)
              : Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            DateFormat('d')
                .format(DateTime.now().add(Duration(days: index)))
                .toString(),
          ),
        ),
      ),
    );
  }
}
