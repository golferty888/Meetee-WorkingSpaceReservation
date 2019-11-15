import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:meetee_mobile/components/css.dart';

class PeriodPicker extends StatefulWidget {
  final ValueChanged<int> returnStartTime;
  final ValueChanged<int> returnEndTime;
  final int color;
  final bool isLargeScreen;

  PeriodPicker({
    Key key,
    this.returnStartTime,
    this.returnEndTime,
    this.color,
    this.isLargeScreen,
  }) : super(key: key);
  @override
  _PeriodPickerState createState() => _PeriodPickerState();
}

class _PeriodPickerState extends State<PeriodPicker> {
  int hourNow = 7;
  int startTime = 8;
  int endTime = 9;

  @override
  void initState() {
    print('not today');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            'Schedule between',
            style: TextStyle(
              fontSize: widget.isLargeScreen ? fontSizeH3[0] : fontSizeH3[1],
            ),
          ),
          SizedBox(
            height: 4.0,
          ),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        startTime > 8 && startTime > hourNow + 1
                            ? GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(widget.color),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.keyboard_arrow_left,
                                    size: 24,
//                            color: Color(widget.color),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    startTime--;
                                  });
                                  widget.returnStartTime(startTime);
                                },
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.keyboard_arrow_left,
                                  color: Colors.grey[400],
                                  size: 24,
                                ),
                              ),
                        Column(
                          children: <Widget>[
                            Text(
                              'Start',
                              style: TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                            Text(
                              '$startTime:00',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                        startTime < 21
                            ? GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(widget.color),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.keyboard_arrow_right,
                                    size: 24,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    startTime++;
                                    if (endTime - startTime == 0) {
                                      endTime++;
                                    }
                                  });
                                  widget.returnStartTime(startTime);
                                  widget.returnEndTime(endTime);
                                },
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.grey[400],
                                  size: 24,
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 24,
                  height: 40,
                ),
                Expanded(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        endTime - startTime > 1
                            ? GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(widget.color),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.keyboard_arrow_left,
                                    size: 24,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    endTime--;
                                  });
                                  widget.returnEndTime(endTime);
                                },
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.keyboard_arrow_left,
                                  color: Colors.grey[400],
                                  size: 24,
                                ),
                              ),
                        Column(
                          children: <Widget>[
                            Text(
                              'End',
                              style: TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                            Text(
                              '$endTime:00',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                        endTime < 22
                            ? GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(widget.color),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.keyboard_arrow_right,
                                    size: 24,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    endTime++;
                                  });
                                  widget.returnEndTime(endTime);
                                },
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.grey[400],
                                  size: 24,
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
