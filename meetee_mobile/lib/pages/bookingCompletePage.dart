import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flare_flutter/flare_actor.dart';
import 'package:meetee_mobile/components/countDownPanel.dart';
import 'package:meetee_mobile/components/countDownText.dart';

import 'package:meetee_mobile/components/css.dart';
import 'package:meetee_mobile/pages/activationPage.dart';
import 'package:meetee_mobile/pages/schedulePage.dart';
import 'package:meetee_mobile/pages/selectFacility.dart';

class BookingCompletePage extends StatefulWidget {
  final int userId;
  final bool isLargeScreen;
  final Map response;
//  final int colorCode;
//  final DateTime startDate;
//  final DateTime startTime;
//  final DateTime endTime;
//  final List facId;
//  final String type;
//  final List code;
//  final String totalPrice;
//  final String imgPath;
//  final int index;

  BookingCompletePage({
    Key key,
//    @required this.colorCode,
    @required this.userId,
    @required this.isLargeScreen,
    @required this.response,
//    @required this.startDate,
//    @required this.startTime,
//    @required this.endTime,
//    @required this.facId,
//    @required this.type,
//    @required this.code,
//    @required this.totalPrice,
//    @required this.imgPath,
//    @required this.index,
  }) : super(key: key);
  @override
  _BookingCompletePageState createState() => _BookingCompletePageState();
}

class _BookingCompletePageState extends State<BookingCompletePage> {
  final String countDownUrl = 'http://18.139.12.132:9000/activate/initial';
  Map<String, String> headers = {"Content-type": "application/json"};

  var _upComingBookingJson;
  bool _isUpComingBookingJsonLoadDone = false;

  int _start;

  Timer _timer;

  @override
  void initState() {
    print(widget.response);
    print(widget.response["message"]);
    getUpComingBookingJson();
    _start = DateTime.parse(widget.response["startTime"])
            .difference(
              DateTime.now(),
            )
            .inSeconds -
        25200;
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

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

  Future getUpComingBookingJson() async {
    String body = '{'
        '"userId": ${widget.userId}'
        '}';
    final response = await http.post(
      countDownUrl,
      body: body,
      headers: headers,
    );

    if (response.statusCode == 200) {
      setState(() {
        _upComingBookingJson = json.decode(response.body);
        print(_upComingBookingJson);
//        _start = DateTime.parse(_upComingBookingJson[0]["start_time"])
//            .difference(
//              DateTime.now(),
//            )
//            .inSeconds;
        _isUpComingBookingJsonLoadDone = true;
//        _start = 230;
      });
      print(_upComingBookingJson);
    } else {
      print('ereer');
    }
  }

  _buildTimerText() {
    if (_start > 0 && _start < 60) {
      return Text(
        'You can activate your facilities in '
        ' ${(_start % 60).toString().padLeft(2, '0')}'
        ' seconds',
        style: TextStyle(
          fontSize: 12.0,
        ),
      );
    } else if (_start >= 60 && _start < 3600) {
      return Text(
        'You can activate your facilities in '
        '${(_start / 60 % 60).floor().toString()}'
        ' minutes',
        style: TextStyle(
          fontSize: 12.0,
        ),
      );
    } else if (_start >= 3600 && _start < 86400) {
      return Text(
        'You can activate your facilities in '
        '${(_start / 60 / 60 % 24).floor().toString()}'
        ' hours',
        style: TextStyle(
          fontSize: 12.0,
        ),
      );
    } else if (_start >= 86400 && _start < 172800) {
      return Text(
        'You can activate your facilities in '
        '${(_start / 60 / 60 / 24 % 30).floor().toString()} day',
        style: TextStyle(
          fontSize: 14.0,
        ),
      );
    } else if (_start >= 172800) {
      Text(
        'You can activate your facilities in  '
        '${(_start / 60 / 60 / 24 % 30).floor().toString()} days',
        style: TextStyle(
          fontSize: 14.0,
        ),
      );
    } else {
      Text('start = $_start');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
//        leading: IconButton(
//          icon: Icon(
//            Icons.arrow_back,
//            color: Colors.black,
//          ),
//          onPressed: () => Navigator.pop(context),
//        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                'Booking completed'.toUpperCase(),
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              Text('${widget.response["message"]}'),
              Container(
                height: MediaQuery.of(context).size.height * 1 / 3,
                child: FlareActor(
                  'images/success_end.flr',
                  animation: 'Wait',
                ),
              ),
              Expanded(
                child: Container(),
              ),
              Center(
                child: _isUpComingBookingJsonLoadDone
                    ? _buildTimerText()
                    : Container(
                        height: 16,
                        width: 16,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                child: OutlineButton(
                  borderSide: BorderSide(color: Colors.grey[200]),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  color: Colors.indigo[100],
                  onPressed: () {
                    Navigator.popUntil(
                      context,
                      ModalRoute.withName('/customerDemand'),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'Keep booking'.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
//                        color: Theme.of(context).primaryColor,
                        color: Colors.grey[500],
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
                child: RaisedButton(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  color: Colors.indigo[50],
                  onPressed: () {
                    Navigator.popUntil(
                      context,
                      ModalRoute.withName('/navigationPage'),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'Go to home page'.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 32.0),
                child: RaisedButton(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ActivationPage(
                            userId: widget.userId,
                            upComingBookingJson: _upComingBookingJson[0],
                          );
                        },
                      ),
                      ModalRoute.withName('/navigationPage'),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'My schedule'.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
