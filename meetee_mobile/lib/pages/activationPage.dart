import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:meetee_mobile/components/countDownPanel.dart';

import 'package:meetee_mobile/config.dart';

class ActivationPage extends StatefulWidget {
  final int index;
  final int userId;
  final String userName;
  final upComingBookingJson;

  ActivationPage({
    Key key,
    this.index,
    this.userId,
    this.userName,
    this.upComingBookingJson,
  }) : super(key: key);
  @override
  _ActivationPageState createState() => _ActivationPageState();
}

String activateUrl = 'http://18.139.12.132:9000/activate';

class _ActivationPageState extends State<ActivationPage> {
  int _start;

  @override
  void initState() {
    print('init: ${widget.upComingBookingJson}');
//    countDownToUnlock();
    _start = DateTime.parse(widget.upComingBookingJson[0]["start_time"])
        .difference(
          DateTime.now(),
        )
        .inSeconds;
//    _start = 7200;
//    _start = 172850;
    print('seconds: $_start');

    super.initState();
  }

  Future<dynamic> activateNow() async {
    final response = await http.post(
      activateUrl,
      body: {
        "userId": widget.userId,
      },
      headers: {HttpHeaders.authorizationHeader: fakeToken},
    );
    if (response.statusCode == 200) {
      print(response.body);
//      final jsonData = (json.decode(response.body));
      setState(() {});
    } else {
      print('400');
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Text(
                  'Activation',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  ),
                )
              ],
            ),
            Expanded(
              child: Hero(
                tag: 'activationPanelTag${widget.index}',
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${DateFormat("HH:00").format(
                                DateTime.parse(widget.upComingBookingJson[0]
                                    ["start_time"]),
                              )}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24.0,
                              ),
                            ),
                            Text(
                              '${DateFormat("d MMMM").format(
                                DateTime.parse(widget.upComingBookingJson[0]
                                    ["start_time"]),
                              )}',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
//                      Container(
//                        padding: EdgeInsets.all(16.0),
//                        decoration: BoxDecoration(
//                          border: Border.all(color: Colors.black),
//                          shape: BoxShape.circle,
//                        ),
//                        child: Icon(
//                          Icons.lock,
//                          color: Colors.black,
//                        ),
//                      ),
                        GestureDetector(
                          onTap: () {
                            activateNow();
                          },
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: CountDownPanel(
                                start: _start,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
                                    decoration: BoxDecoration(
                                      color: Colors.yellow[600],
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                    child: Text(
                                      'Bar Table',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    ' x 2',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
                                    decoration: BoxDecoration(
                                      color: Colors.pink[200],
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                    child: Text(
                                      'Meeting Room S',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    ' x 1',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
