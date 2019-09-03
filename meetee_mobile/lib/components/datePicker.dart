import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        24.0,
        0.0,
        24.0,
        16.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Today',
          ),
          Text(
            'Tomorrow',
          ),
          Text(
            '5',
          ),
          Text(
            '6',
          ),
          Text(
            '7',
          ),
          Text(
            '8',
          ),
        ],
      ),
    );
  }
}
