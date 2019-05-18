import 'package:flutter/material.dart';
import 'package:meetee_frontend/blocs/bloc_provider.dart';
import 'package:meetee_frontend/blocs/bloc_reservation.dart';

class TimePicker extends StatefulWidget {
  final String type;
  TimePicker({this.type});

  @override
  _TimePickerState createState() => _TimePickerState(this.type);
}

class _TimePickerState extends State<TimePicker> {
  String type;
  _TimePickerState(this.type);

  // TimeOfDay timeStart;
  // TimeOfDay timeEnd;
  TimeOfDay timeStart = TimeOfDay.now();
  TimeOfDay timeEnd =
      TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute);
  // @override
  // initState() {
  //   timeStart = TimeOfDay.now();
  //   timeEnd = TimeOfDay(
  //       hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute);
  //   super.initState();
  // }

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
    final BlocReservation timeReserveBloc =
        BlocProvider.of<BlocReservation>(context);

    if (type == 'start') {
      return GestureDetector(
        onTap: () => _selectTimeStart(context, timeReserveBloc),
        child: AbsorbPointer(
          child: TextField(
            decoration: InputDecoration(
                border: InputBorder.none, hintText: timeStart.format(context)),
            // border: InputBorder.none,
            // hintText: 'Time Start'),
          ),
        ),
      );
    } else if (type == 'end') {
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