import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // date form
import 'package:meetee_frontend/model/Reservation.dart';

class DatePicker extends StatefulWidget {
  DateTime dateStart;
  Function(DateTime) callback;

  DatePicker(this.dateStart, this.callback);

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime dateNow = DateTime.now();

  Future<Null> _selectDate(BuildContext context, Function callback) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime(2020));
    if (picked != null) {
      print('Selected date: ' + DateFormat('yyyy-MM-dd').format(picked));
      setState(() {
        dateNow = picked;
        callback(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context, widget.callback),
      child: AbsorbPointer(
        child: TextField(
          decoration: InputDecoration(
              border: InputBorder.none, hintText: dateNow.toString()),
          // border: InputBorder.none, hintText: 'Select Date'),
        ),
      ),
    );
  }
}
