import 'dart:async';

import 'package:flutter/material.dart';

class CountDownText extends StatefulWidget {
  final int start;

  CountDownText({
    Key key,
    this.start,
  }) : super(key: key);
  @override
  _CountDownTextState createState() => _CountDownTextState();
}

class _CountDownTextState extends State<CountDownText>
    with TickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    setState(() {
      _start = widget.start;
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

  _buildTimerText() {
    if (_start > 0 && _start < 86400) {
      return Text(
        '${(_start / 60 / 60 % 24).floor().toString().padLeft(2, '0')}'
        ':'
        '${(_start / 60 % 60).floor().toString().padLeft(2, '0')}'
        ':'
        '${(_start % 60).toString().padLeft(2, '0')}',
        style: TextStyle(
          fontSize: 24.0,
        ),
      );
    } else if (_start >= 86400 && _start < 172800) {
      return Text(
        '${(_start / 60 / 60 / 24 % 30).floor().toString()} day',
        style: TextStyle(
          fontSize: 24.0,
        ),
      );
    } else if (_start >= 172800) {
      Text(
        '${(_start / 60 / 60 / 24 % 30).floor().toString()} days',
        style: TextStyle(
          fontSize: 24.0,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildTimerText();
  }
}
