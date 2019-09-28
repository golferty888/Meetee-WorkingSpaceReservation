import 'package:flutter/material.dart';

class TimePicker extends StatefulWidget {
  final int secondaryColor;
  final Color primaryColor;
  final ValueChanged<int> returnStartTime;
  final ValueChanged<int> returnEndTime;
  final double titleFontSize;
  final double valueFontSize;

  TimePicker({
    Key key,
    @required this.primaryColor,
    @required this.secondaryColor,
    this.returnStartTime,
    this.returnEndTime,
    this.titleFontSize,
    this.valueFontSize,
  }) : super(key: key);
  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  double hourNow = TimeOfDay.now().hour.toDouble();
  RangeValues _values = RangeValues(
    TimeOfDay.now().hour.toDouble() + 1,
    TimeOfDay.now().hour.toDouble() + 2,
  );

  @override
  void initState() {
    if (hourNow + 1 > 21 || hourNow + 1 < 8) {
      _values = RangeValues(
        8,
        9,
      );
    }
    super.initState();
  }

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
              fontSize: widget.titleFontSize,
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  _values.start.round().toString(),
                  textAlign: TextAlign.end,
                ),
              ),
              Flexible(
                flex: 16,
                child: RangeSlider(
                  activeColor: widget.primaryColor,
                  inactiveColor: Color(widget.secondaryColor),
                  values: _values,
                  labels: RangeLabels(
                    '${_values.start.round()}',
                    '${_values.end.round()}',
                  ),
                  min: 8,
                  max: 22.0,
                  divisions: 14,
                  onChanged: (RangeValues values) {
                    setState(
                      () {
                        if (values.end - values.start >= 1) {
                          _values = values;
                        } else {
                          if (_values.start == values.start) {
                            _values =
                                RangeValues(_values.start, _values.start + 1);
                          } else {
                            _values = RangeValues(_values.end - 1, _values.end);
                          }
                        }
                      },
                    );
                  },
                  onChangeEnd: (RangeValues values) {
                    widget.returnStartTime(
                      _values.start.round(),
                    );
                    widget.returnEndTime(
                      _values.end.round(),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '22',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
