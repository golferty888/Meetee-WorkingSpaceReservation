import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  final int primaryColor;
  final ValueChanged<DateTime> returnDate;
  final double titleFontSize;
  final double valueFontSize;
  final bool isLargeScreen;

  DatePicker({
    Key key,
    @required this.primaryColor,
    this.returnDate,
    this.titleFontSize,
    this.valueFontSize,
    this.isLargeScreen,
  }) : super(key: key);

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  int today = 0;
  bool timeOut = false;
  int _selectedIndex = 0;
  DateTime initialDate = DateTime.now().add(Duration(days: 5));
  String formattedDate = DateFormat('d MMMM yyyy').format(DateTime.now());

  @override
  void initState() {
    checkTimeOut();
    super.initState();
  }

  checkTimeOut() {
    if (TimeOfDay.now().hour >= 21) {
      _selectedIndex = 1;
      timeOut = true;
    }
  }

  _onSelected(int index) {
    setState(() {
      _selectedIndex = index;
      formattedDate = DateFormat('d MMMM yyyy')
          .format(
            DateTime.now().add(
              Duration(
                days: _selectedIndex,
              ),
            ),
          )
          .toString();
    });
    widget.returnDate(
      DateTime.now().add(
        Duration(
          days: _selectedIndex,
        ),
      ),
    );
  }

  Widget disabledButton(text, width) {
    return Container(
      height: 24.0,
      width: width,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black38,
            fontSize: widget.valueFontSize,
          ),
        ),
      ),
    );
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
              : null,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: _selectedIndex != null && _selectedIndex == index
                  ? FontWeight.bold
                  : FontWeight.normal,
              fontSize: widget.valueFontSize,
            ),
          ),
        ),
      ),
    );
  }

  Widget selectedDate(index) {
    return GestureDetector(
      onTap: () => _onSelected(index),
      child: Container(
        height: 24.0,
        width: 34.0,
        decoration: BoxDecoration(
          color: _selectedIndex != null && _selectedIndex == index
              ? Color(widget.primaryColor)
              : null,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            DateFormat('d')
                .format(DateTime.now().add(Duration(days: index)))
                .toString(),
            style: TextStyle(
              fontWeight: _selectedIndex != null && _selectedIndex == index
                  ? FontWeight.bold
                  : FontWeight.normal,
              fontSize: widget.valueFontSize,
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> calendar(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime.now().add(Duration(days: 4)),
        lastDate: DateTime(2022));
    if (picked != null) {
      setState(() {
        initialDate = picked;
        formattedDate = DateFormat('d MMMM yyyy').format(picked);
        _selectedIndex = 6;
        widget.returnDate(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//      width: double.infinity,
      margin: EdgeInsets.fromLTRB(
        24.0,
        8.0,
        24.0,
        8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Select date (' + formattedDate + ')',
            style: TextStyle(
              fontSize: widget.titleFontSize,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          widget.isLargeScreen
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    timeOut == false
                        ? selectedDateWithText(today, 'Today', 64.0)
                        : disabledButton('Today', 56.0),
                    selectedDateWithText(today + 1, 'Tomorrow', 96.0),
                    selectedDate(today + 2),
                    selectedDate(today + 3),
                    selectedDate(today + 4),
                    Container(
                      width: 34.0,
                      padding: EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: _selectedIndex != null && _selectedIndex == 6
                            ? Color(widget.primaryColor)
                            : null,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: GestureDetector(
                        onTap: () => calendar(context),
                        child: Icon(
//                    Icons.calendar_today,
                          Icons.more_horiz,
                          size: 20.0,
                        ),
                      ),
                    )
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    timeOut == false
                        ? selectedDateWithText(today, 'Today', 56.0)
                        : disabledButton('Today', 56.0),
                    selectedDateWithText(today + 1, 'Tomorrow', 80.0),
                    selectedDate(today + 2),
                    selectedDate(today + 3),
                    Container(
                      width: 34.0,
                      padding: EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: _selectedIndex != null && _selectedIndex == 6
                            ? Color(widget.primaryColor)
                            : null,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: GestureDetector(
                        onTap: () => calendar(context),
                        child: Icon(
//                    Icons.calendar_today,
                          Icons.calendar_today,
                          size: 16.0,
                        ),
                      ),
                    )
                  ],
                ),
        ],
      ),
    );
  }
}
