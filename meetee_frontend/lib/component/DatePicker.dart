import 'package:flutter/material.dart';
import 'package:meetee_frontend/blocs/bloc_provider.dart';
import 'package:meetee_frontend/blocs/bloc_reservation.dart';

class DatePicker extends StatefulWidget {
  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime dateNow = DateTime.now();

  void _selectDate(
      BuildContext context, BlocReservation dateReserveBloc) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime(2020));
    if (picked != null) {
      dateReserveBloc.reserveDate(picked);
      setState(() {
        dateNow = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final BlocReservation dateReserveBloc =
        BlocProvider.of<BlocReservation>(context);

    return GestureDetector(
      onTap: () => _selectDate(context, dateReserveBloc),
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
