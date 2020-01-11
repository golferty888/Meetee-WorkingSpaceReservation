import 'dart:async';

import 'package:flutter/material.dart';

class CountDownPanel extends StatefulWidget {
  final int start;
  final ValueChanged<bool> returnIsInTime;

  CountDownPanel({
    Key key,
    this.start,
    this.returnIsInTime,
  }) : super(key: key);
  @override
  _CountDownPanelState createState() => _CountDownPanelState();
}

class _CountDownPanelState extends State<CountDownPanel>
    with TickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    setState(() {
      _start = widget.start;
//      _start = 62;
      if (widget.start <= 0) {
        _start = 0;
        widget.returnIsInTime(true);
      }
    });

    startTimer();
    super.initState();
  }

  Timer _timer;
  int _start;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            print('cancel');
            timer.cancel();
            _start = 0;
            widget.returnIsInTime(true);
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (_start == 0 || _start < 0)
          Text(
            'It\'s time!',
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.greenAccent[400],
            ),
          ),
        if (_start == 1)
          Text(
            'Preparing',
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.amber[600],
            ),
          ),
        if (_start > 0 && _start < 86400)
          Text(
            '${(_start / 60 / 60 % 24).floor().toString().padLeft(2, '0')}'
            ':'
            '${(_start / 60 % 60).floor().toString().padLeft(2, '0')}'
            ':'
            '${(_start % 60).toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.white,
            ),
          ),
        if (_start >= 86400 && _start < 172800)
          Text(
            '${(_start / 60 / 60 / 24 % 30).floor().toString()} day',
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.white,
            ),
          ),
        if (_start >= 172800)
          Text(
            '${(_start / 60 / 60 / 24 % 30).floor().toString()} days',
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.white,
            ),
          ),
      ],
    );
  }
}
