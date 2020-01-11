import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:meetee_mobile/config_tmp.dart';

class ActivationPage extends StatefulWidget {
  final int userId;
  final upComingBookingJson;

  ActivationPage({
    Key key,
    this.userId,
    this.upComingBookingJson,
  }) : super(key: key);
  @override
  _ActivationPageState createState() => _ActivationPageState();
}

String activateUrl = 'http://18.139.12.132:9000/activate';

class _ActivationPageState extends State<ActivationPage>
    with SingleTickerProviderStateMixin {
  AnimationController _fadeController;
  Animation _fadeAnimation;

  int _start;
  Timer _timer;

  @override
  void initState() {
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_fadeController);
    _start = DateTime.parse(widget.upComingBookingJson["start_time"])
        .difference(
          DateTime.now(),
        )
        .inSeconds;
    startTimer();
    print('seconds: $_start');
    _fadeController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();

    _fadeController.dispose();

    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            print('time\' up');
            timer.cancel();
            _start = 0;
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  Future<dynamic> activateNow() async {
    String body = '{'
        '"userId": ${widget.userId}'
        '}';
    final response = await http.post(
      activateUrl,
      body: body,
      headers: {
        HttpHeaders.authorizationHeader: $fakeToken,
        "Content-type": "application/json"
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {});
    } else {
      print('400');
      throw Exception('Failed to load post');
    }
  }

  _buildUpComingFacilities(int index) {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 8, 12, 8),
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Color(
          int.parse(widget.upComingBookingJson["faclist"][index]["color_code"]),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              SvgPicture.network(
                widget.upComingBookingJson["faclist"][index]["icon_url"],
                color: Colors.black,
                height: 48,
              ),
              SizedBox(
                width: 6,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Until ',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        '${DateFormat("hh:00").format(
                          DateTime.parse(widget.upComingBookingJson["faclist"]
                              [index]["end_time"]),
                        )}',
                        style: TextStyle(
                          color: Colors.black54,
                          wordSpacing: 2,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${widget.upComingBookingJson["faclist"][index]["cateName"]}',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    '${widget.upComingBookingJson["faclist"][index]["code"]}',
                    style: TextStyle(
                      color: Colors.black,
                      wordSpacing: 2,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  _buildTimerPanel() {
    if (_start <= 0) {
      return Text(
        'Activate',
        style: TextStyle(
          fontSize: 24.0,
          color: Colors.black,
        ),
      );
    } else if (_start <= 1) {
      print('prepare');
      return Text(
        'Preparing',
        style: TextStyle(
          fontSize: 24.0,
          color: Colors.amber[400],
        ),
      );
    } else if (_start > 1 && _start < 86400) {
      return Text(
        '${(_start / 60 / 60 % 24).floor().toString().padLeft(2, '0')}'
        ':'
        '${(_start / 60 % 60).floor().toString().padLeft(2, '0')}'
        ':'
        '${(_start % 60).toString().padLeft(2, '0')}',
        style: TextStyle(
          fontSize: 24.0,
          color: Colors.white,
        ),
      );
    } else if (_start >= 86400 && _start < 172800) {
      return Text(
        '${(_start / 60 / 60 / 24 % 30).floor().toString()} day',
        style: TextStyle(
          fontSize: 24.0,
          color: Colors.white,
        ),
      );
    } else if (_start >= 172800) {
      return Text(
        '${(_start / 60 / 60 / 24 % 30).floor().toString()} days',
        style: TextStyle(
          fontSize: 24.0,
          color: Colors.white,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Hero(
              tag:
                  'activationPanelTag${widget.upComingBookingJson["start_time"]}',
              child: Material(
                color: Colors.transparent,
                child: Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: Container(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 24.0, bottom: 16),
                          child: Text(
                            'to activate your '
                            '${widget.upComingBookingJson["faclist"].length}'
                            ' facilities',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Container(
                            height: 72,
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  widget.upComingBookingJson["faclist"].length,
                              itemBuilder: (BuildContext context, int index) {
                                return _buildUpComingFacilities(index);
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                    Positioned(
                      top: 56,
                      child: Padding(
                        padding: EdgeInsets.only(left: 24.0, right: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${DateFormat("HH:00").format(
                                DateTime.parse(
                                    widget.upComingBookingJson["start_time"]),
                              )}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  '${DateFormat("d MMMM").format(
                                    DateTime.parse(widget
                                        .upComingBookingJson["start_time"]),
                                  )}',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: _start <= 0
                          ? GestureDetector(
                              onTap: () {
                                activateNow();
                              },
                              child: Container(
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.greenAccent[400],
                                ),
                                child: Center(
                                  child: _buildTimerPanel(),
                                ),
                              ),
                            )
                          : Container(
                              height: 140,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: _buildTimerPanel(),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.popUntil(
                        context,
                        ModalRoute.withName('/navigationPage'),
                      );
                    },
                  ),
                ),
                Text(
                  'Activate your facility',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
