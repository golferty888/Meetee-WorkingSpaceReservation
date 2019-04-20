import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // date form
// import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:numberpicker/numberpicker.dart'; //number picker

class DatePicker extends StatefulWidget {
  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime dateNow = DateTime.now();
  TimeOfDay timeStart = TimeOfDay.now();
  TimeOfDay timeEnd = TimeOfDay.now();

  int _currentValue = 1;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime(2020));
    if (picked != null) {
      print('Selected date: ' + DateFormat('yyyy-MM-dd').format(dateNow));
      setState(() {
        dateNow = picked;
      });
    }
  }

  Future<Null> _selectTimeStart(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: timeStart,
    );
    if (picked != null) {
      print('Selected date: ${timeStart.toString()}');
      setState(() {
        timeStart = picked;
      });
    }
  }

  Future<Null> _selectTimeEnd(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: timeEnd,
    );
    if (picked != null) {
      print('Selected date: ${timeEnd.toString()}');
      setState(() {
        timeEnd = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextField(
          decoration: InputDecoration(
              border: InputBorder.none, hintText: dateNow.toString()),
        ),
      ),
    );
  }
}
