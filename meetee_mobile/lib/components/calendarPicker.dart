import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarPicker extends StatefulWidget {
  final int primaryColor;
  final ValueChanged<DateTime> returnDate;
  final double titleFontSize;
  final double valueFontSize;

  CalendarPicker({
    Key key,
    @required this.primaryColor,
    this.returnDate,
    this.titleFontSize,
    this.valueFontSize,
  }) : super(key: key);
  @override
  _CalendarPickerState createState() => _CalendarPickerState();
}

class _CalendarPickerState extends State<CalendarPicker> {
  DateTime initialDate = DateTime.now();
  String formattedDate = DateFormat('d, MMMM').format(DateTime.now());

  Future<Null> calendar(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().add(
        Duration(
          days: -1,
        ),
      ),
      lastDate: DateTime(2022),
    );
    if (picked != null) {
      setState(() {
        initialDate = picked;
        formattedDate = DateFormat('d, MMMM').format(picked);
//        widget.returnDate(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(24.0, 24.0, 12.0, 12.0),
      height: 84.0,
      child: GestureDetector(
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Date',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                formattedDate,
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        ),
        onTap: () => calendar(context),
      ),
    );
  }
}
