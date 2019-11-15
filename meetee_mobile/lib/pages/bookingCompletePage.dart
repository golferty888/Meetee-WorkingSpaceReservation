import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flare_flutter/flare_actor.dart';
import 'package:meetee_mobile/components/countDownPanel.dart';

import 'package:meetee_mobile/components/css.dart';
import 'package:meetee_mobile/pages/activationPage.dart';
import 'package:meetee_mobile/pages/homePage.dart';
import 'package:meetee_mobile/pages/selectFacility.dart';

class BookingCompletePage extends StatefulWidget {
  final int userId;
  final bool isLargeScreen;
  final String response;
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

  int _start;

  @override
  void initState() {
    countDownToUnlock();

    super.initState();
  }

  Future countDownToUnlock() async {
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
        _start = DateTime.parse(_upComingBookingJson[0]["start_time"])
            .difference(
              DateTime.now(),
            )
            .inSeconds;
        _start = 230;
      });
      print(_upComingBookingJson);
    } else {
      print('ereer');
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
//        title: Text(
//          'Confirm booking'.toUpperCase(),
//          style: TextStyle(
//            color: Colors.black54,
//            fontSize: widget.isLargeScreen ? fontSizeH3[0] : fontSizeH3[1],
//          ),
//        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
//              Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Text(
//                    'Thank you'.toUpperCase(),
//                    style: TextStyle(
//                      fontSize: 32,
//                    ),
//                  ),
//                  Text(
//                    'for'.toUpperCase(),
//                    style: TextStyle(
//                      fontSize: 32,
//                    ),
//                  ),
//                  Text(
//                    'your booking'.toUpperCase(),
//                    style: TextStyle(
//                      fontSize: 32,
//                    ),
//                  ),
//                ],
//              ),
              Text(
                'Booking completed'.toUpperCase(),
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              Text('${widget.response}'),
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
              Text(
                'You can activate your facilities in 02:51',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize:
                      widget.isLargeScreen ? fontSizeH3[0] : fontSizeH3[1],
                ),
              ),
//              Container(
//                height: 40,
//                child: CountDownPanel(
//                  start: _start,
//                ),
//              ),
              Container(
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                child: OutlineButton(
                  borderSide: BorderSide(color: Colors.grey[200]),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  color: Colors.indigo[100],
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SelectFacilityType(
                            userId: widget.userId,
                            isLargeScreen: widget.isLargeScreen,
                          );
                        },
                      ),
                      ModalRoute.withName('/homePage'),
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
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return HomePage(
                            userName: 'eiei',
                            userId: widget.userId,
                          );
                        },
                      ),
                      ModalRoute.withName('/homePage'),
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
                            userName: 'eiei',
                            upComingBookingJson: _upComingBookingJson,
                            userId: widget.userId,
                          );
                        },
                      ),
                      ModalRoute.withName('/homePage'),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'Activate now'.toUpperCase(),
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
//              Text(
//                'You can activate your facilities in 02:46',
//                style: TextStyle(
//                  fontSize: 16,
//                ),
//              ),
            ],
          ),
        ),
      ),
    );
  }
}
