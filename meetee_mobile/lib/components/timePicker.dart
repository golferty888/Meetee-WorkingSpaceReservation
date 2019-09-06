import 'package:flutter/material.dart';

class TimePicker extends StatefulWidget {
  final int secondaryColor;
  final Color primaryColor;

  TimePicker(
      {Key key, @required this.primaryColor, @required this.secondaryColor})
      : super(key: key);
  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  RangeValues _values = RangeValues(9, 10);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        24.0,
        0.0,
        24.0,
        16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Select time (${_values.start.round()}.00 - ${_values.end.round()}.00)',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          RangeSlider(
              activeColor: widget.primaryColor,
              inactiveColor: Color(widget.secondaryColor),
              values: _values,
//              labels: '${_values.round()}',
              labels: RangeLabels(
                '${_values.start.round()}',
                '${_values.end.round()}',
              ),
              min: 8,
              max: 22,
              divisions: 14,
              onChanged: (RangeValues values) {
                setState(() {
                  if (values.end - values.start >= 1) {
                    _values = values;
                  } else {
                    if (_values.start == values.start) {
                      _values = RangeValues(_values.start, _values.start + 1);
                    } else {
                      _values = RangeValues(_values.end - 1, _values.end);
                    }
                  }
                });
              }),
        ],
      ),
    );
  }
}
