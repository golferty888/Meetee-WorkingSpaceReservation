import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:meetee_mobile/components/css.dart';
import 'package:meetee_mobile/pages/homePage.dart';

class BookingCompletePage extends StatefulWidget {
  final int userId;
  final bool isLargeScreen;
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
            children: <Widget>[
              Text('Complete'),
              RaisedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return HomePage(
                          userName: 'eiei',
                          upComingBookingJson: _upComingBookingJson,
                          userId: widget.userId,
                        );
                      },
                    ),
                    ModalRoute.withName('/homePage'),
                  );
                },
                child: Text('press me!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
