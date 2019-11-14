import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:meetee_mobile/components/css.dart';

class PeriodPickerToday extends StatefulWidget {
  final ValueChanged<int> returnStartTime;
  final ValueChanged<int> returnEndTime;
  final int color;
  final bool isLargeScreen;

  PeriodPickerToday({
    Key key,
    this.returnStartTime,
    this.returnEndTime,
    this.color,
    this.isLargeScreen,
  }) : super(key: key);
  @override
  _PeriodPickerTodayState createState() => _PeriodPickerTodayState();
}

class _PeriodPickerTodayState extends State<PeriodPickerToday> {
//  ScrollController _scrollController;

  int hourNow = DateTime.now().hour;
//  int hourNow = 12;
  int startTime = DateTime.now().hour + 1;
//  int startTime = 13;
  int endTime = DateTime.now().hour + 2;
//  int endTime = 14;

  @override
  void initState() {
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
                        startTime < 22
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
                  child: Center(
                    child: Container(
                      width: 1,
                      color: Colors.grey,
                    ),
                  ),
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
