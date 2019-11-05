import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meetee_mobile/components/customTimerPainter.dart';

class CountDownPanel extends StatefulWidget {
  final int start;

  CountDownPanel({
    Key key,
    this.start,
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
    });
    startTimer();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );
    controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Icon(
          Icons.lock,
          size: 32,
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Your schedule will start in',
            style: TextStyle(
              fontSize: 16.0,
            ),
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
            ),
          ),
        if (_start >= 86400 && _start < 172800)
          Text(
            '${(_start / 60 / 60 / 24 % 30).floor().toString()} day',
            style: TextStyle(
              fontSize: 24.0,
            ),
          ),
        if (_start >= 172800)
          Text(
            '${(_start / 60 / 60 / 24 % 30).floor().toString()} days',
            style: TextStyle(
              fontSize: 24.0,
            ),
          ),
      ],
    );
  }
}
