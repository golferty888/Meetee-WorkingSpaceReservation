import 'package:flutter/material.dart';
import 'package:meetee_frontend/blocs/bloc_provider.dart';
import 'package:meetee_frontend/blocs/bloc_reservation.dart';

class TimePicker extends StatefulWidget {
  final String type;
  final String format;
  TimePicker({this.type, this.format});

  @override
  _TimePickerState createState() => _TimePickerState(this.type);
}

class _TimePickerState extends State<TimePicker> {
  String type;
  _TimePickerState(this.type);
  // TimeOfDay timeStart;
  TimeOfDay timeEnd;
  TimeOfDay timeStart = TimeOfDay.now();
  int endHour = TimeOfDay.now().hour;
  // TimeOfDay timeEnd = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute);
  // @override
  // initState() {
  //   timeStart = TimeOfDay.now();
  //   timeEnd = TimeOfDay(
  //       hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute);
  //   super.initState();
  // }
  @override
  void initState() {
    timeEnd = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute);
     if ( TimeOfDay.now().hour + 1 >= 24) {
      print('check');
      timeEnd = TimeOfDay(hour: 0, minute: TimeOfDay.now().minute);
    }
    super.initState();
  }

  Future<Null> _selectTimeStart(
      BuildContext context, BlocReservation timeReserveBloc) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: timeStart,
    );
    if (picked != null) {
      setState(() {
        timeStart = picked;
        // timeEnd = TimeOfDay(hour: picked.hour + 1, minute: picked.minute);
        timeReserveBloc.reserveTimeStart(timeStart);
        // timeReserveBloc.reserveTimeStart(timeEnd);
      });
    }
  }

  Future<Null> _selectTimeEnd(
      BuildContext context, BlocReservation timeReserveBloc) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: timeEnd,
    );
    if (picked != null) {
      setState(() {
        timeEnd = picked;
        timeReserveBloc.reserveTimeEnd(timeEnd);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // timeEnd = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute);
    final BlocReservation timeReserveBloc =
        BlocProvider.of<BlocReservation>(context);

    if (type == 'start') {
      if (widget.format == 'tab') {
        return GestureDetector(
          onTap: () => _selectTimeStart(context, timeReserveBloc),
          child: AbsorbPointer(
            child: TextField(
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: timeStart.hour.toString() +
                    ':' +
                    timeStart.minute.toString(),
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      } else {
        return GestureDetector(
          onTap: () => _selectTimeStart(context, timeReserveBloc),
          child: AbsorbPointer(
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: timeStart.format(context)),
            ),
          ),
        );
      }
    } else if (type == 'end') {
      if (widget.format == 'tab') {
        return GestureDetector(
          onTap: () => _selectTimeEnd(context, timeReserveBloc),
          child: AbsorbPointer(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: timeEnd.hour.toString() +
                    ':' +
                    timeEnd.minute.toString(),
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      } else {
        return GestureDetector(
          onTap: () => _selectTimeEnd(context, timeReserveBloc),
          child: AbsorbPointer(
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: timeEnd.format(context)),
              // border: InputBorder.none,
              // hintText: 'Time End'),
            ),
          ),
        );
      }
    }
  }
}
