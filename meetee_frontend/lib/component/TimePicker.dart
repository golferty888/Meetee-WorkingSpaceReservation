import 'package:flutter/material.dart';
import 'package:meetee_frontend/model/Reservation.dart';

class TimePicker extends StatefulWidget {
  final String type;
  TimePicker({this.type});

  @override
  _TimePickerState createState() => _TimePickerState(this.type);
}

class _TimePickerState extends State<TimePicker> {
  String type;
  _TimePickerState(this.type);

  TimeOfDay timeStart = TimeOfDay.now();
  TimeOfDay timeEnd = TimeOfDay.now();

  // Reservation reservation =
  //     new Reservation(type, startDate, timeStart, timeEnd);

  // int _currentValue = 1;

  Future<Null> _selectTimeStart(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: timeStart,
    );
    if (picked != null) {
      print('Selected date: ${timeStart.toString()}');
      setState(() {
        timeStart = picked;
        return picked;
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
    if (type == 'start') {
      return GestureDetector(
        onTap: () => _selectTimeStart(context),
        child: AbsorbPointer(
          child: TextField(
            decoration: InputDecoration(
                border: InputBorder.none, hintText: timeStart.toString()),
            // border: InputBorder.none,
            // hintText: 'Time Start'),
          ),
        ),
      );
    } else if (type == 'end') {
      return GestureDetector(
        onTap: () => _selectTimeEnd(context),
        child: AbsorbPointer(
          child: TextField(
            decoration: InputDecoration(
                border: InputBorder.none, hintText: timeStart.toString()),
            // border: InputBorder.none,
            // hintText: 'Time End'),
          ),
        ),
      );
    }
  }
}
