import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:meetee_mobile/components/customDialog.dart';

class Summary extends StatefulWidget {
  final int colorCode;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final String facId;
  final String type;
  final String code;
  final String totalPrice;

  Summary({
    Key key,
    @required this.colorCode,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.facId,
    this.type,
    this.code,
    this.totalPrice,
  }) : super(key: key);
  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  final String userId = '1';
  final String reserveURL = 'http://18.139.12.132:9000/reserve';

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> reserveSeat() async {
    final response = await http.post(
      reserveURL,
      body: {
        "userId": userId,
        "facId": widget.facId,
        "startDate": widget.startDate,
        "startTime": widget.startTime,
        "endTime": widget.endTime,
        "endDate": widget.endDate,
      },
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(jsonData);
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.5,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Confirm booking',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
//          color: Color(widget.colorCode),
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage(
              'images/noise.png',
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'images/summary_img.jpg',
                  width: 250,
                  fit: BoxFit.fitHeight,
                ),
                Container(
                  width: 240.0,
                  height: 224.0,
                  margin: EdgeInsets.only(
                    top: 24.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          16.0,
                          8.0,
                          16.0,
                          8.0,
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Text(
                                'Date',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text(
                                '${widget.startDate}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16.0,
                          8.0,
                          16.0,
                          8.0,
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Text(
                                'Time',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text(
                                '${widget.startTime.substring(
                                  0,
                                  5,
                                )} - ${widget.endTime.substring(
                                  0,
                                  5,
                                )}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16.0,
                          8.0,
                          16.0,
                          8.0,
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Text(
                                'Type',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text(
                                '${widget.type}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16.0,
                          8.0,
                          16.0,
                          8.0,
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Text(
                                'Code',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text(
                                '${widget.code}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16.0,
                          8.0,
                          16.0,
                          8.0,
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Text(
                                'Price',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text(
                                '${widget.totalPrice} Baht',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                RaisedButton(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  color: Color(widget.colorCode),
                  onPressed: () {
                    reserveSeat();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => CustomDialog(
                        title: "Success",
                        description:
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                        buttonText: "Okay",
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 24.0,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    width: MediaQuery.of(context).size.width / 3,
                    child: Text(
                      'CONFIRM',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
