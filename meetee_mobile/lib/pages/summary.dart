import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:meetee_mobile/components/css.dart';
import 'package:meetee_mobile/pages/bookingCompletePage.dart';

import 'package:meetee_mobile/config.dart';

class Summary extends StatefulWidget {
  final int userId;
  final bool isLargeScreen;
  final int colorCode;
  final DateTime startDate;
  final int startTime;
  final int endTime;
  final List facId;
  final String type;
  final List code;
  final String totalPrice;
  final String imgPath;
  final int index;
  final String cateIcon;

  Summary({
    Key key,
    @required this.colorCode,
    @required this.userId,
    @required this.isLargeScreen,
    @required this.startDate,
    @required this.startTime,
    @required this.endTime,
    @required this.facId,
    @required this.type,
    @required this.code,
    @required this.totalPrice,
    @required this.imgPath,
    @required this.index,
    @required this.cateIcon,
  }) : super(key: key);
  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  final String reserveSeatUrl = 'http://18.139.12.132:9000/reserve';
  final String lockUrl = 'http://18.139.12.132:9000/facility/pending/lock';
  final String unlockUrl = 'http://18.139.12.132:9000/facility/pending/unlock';

  String startDateFormattedForApi;
  String startDateFormatted;
  String startTimeFormatted;
  String endTimeFormatted;

  Map<String, String> headers = {"Content-type": "application/json"};

  Map _responseFromReserve;

  @override
  void initState() {
    super.initState();

    startDateFormattedForApi =
        DateFormat("yyyy-MM-dd").format(widget.startDate);
    startDateFormatted = DateFormat("dd MMMM yyy").format(widget.startDate);
    startTimeFormatted = '${widget.startTime}:00';
    endTimeFormatted = '${widget.endTime}:00';
    lock();
  }

  Future<dynamic> reserveSeat() async {
    String body = '{'
        '"userId": ${widget.userId}, '
        '"startDate": "$startDateFormattedForApi", '
        '"startTime": "$startTimeFormatted", '
        '"endTime": "$endTimeFormatted", '
        '"facId": ${widget.facId}, '
        '"totalPrice": ${widget.totalPrice}'
        '}';
    print(body);
    final response = await http.post(
      reserveSeatUrl,
      headers: headers,
      body: body,
    );
    if (response.statusCode == 200) {
      setState(() {
        _responseFromReserve = json.decode(response.body);
      });
      print('_responseFromReserve: ${_responseFromReserve["message"]}');
    } else {
      print(response.body);
    }
  }

  Future<dynamic> lock() async {
    String body = '{'
        '"startDate": "$startDateFormattedForApi", '
        '"startTime": "$startTimeFormatted", '
        '"endTime": "$endTimeFormatted", '
        '"facList": ${widget.facId}'
        '}';
    print(body);
    final response = await http.post(
      lockUrl,
      headers: headers,
      body: body,
    );
    if (response.statusCode == 200) {
      var responseFromLock = response.body;
      print('responseFromLock: $responseFromLock');
    } else {
      print(response.body);
    }
  }

  Future<dynamic> unlock() async {
    String body = '{'
        '"startDate": "$startDateFormattedForApi", '
        '"startTime": "$startTimeFormatted", '
        '"endTime": "$endTimeFormatted", '
        '"facList": ${widget.facId}'
        '}';
    print(body);
    final response = await http.post(
      unlockUrl,
      headers: headers,
      body: body,
    );
    if (response.statusCode == 200) {
      var responseFromUnlock = response.body;
      print('responseFromLock: $responseFromUnlock');
      return;
    } else {
      print(response.body);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () async {
            await unlock();
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Confirm booking'.toUpperCase(),
          style: TextStyle(
            color: Colors.black54,
            fontSize: widget.isLargeScreen ? fontSizeH3[0] : fontSizeH3[1],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      widget.imgPath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      widget.type,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Date: ',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            startDateFormatted,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Schedule: ',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '$startTimeFormatted - $endTimeFormatted',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Expanded(
                      child: Scrollbar(
                        child: GridView.count(
                          childAspectRatio: 2,
                          crossAxisCount: 3,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          physics: ClampingScrollPhysics(),
                          children: List.generate(widget.code.length, (index) {
                            return Container(
//                            margin: EdgeInsets.fromLTRB(0.0, 4.0, 8.0, 4.0),
                              padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                              decoration: BoxDecoration(
                                color: Color(widget.colorCode),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    SvgPicture.network(
                                      widget.cateIcon,
                                      height: 16,
                                      color: Colors.black,
                                    ),
                                    Text(
                                      widget.code[index],
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total price',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '${widget.totalPrice} Baht',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
//              SizedBox(
//                height: 2.0,
//              ),
              Divider(
                color: Colors.grey[700],
              ),
              RaisedButton(
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                color: Color(widget.colorCode),
                onPressed: () {
//                        _onStartCardEntryFlow();

                  _onCardEntryComplete();
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 24.0,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(
                    'CHECK OUT',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 32.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onCardEntryComplete() async {
    await reserveSeat();
    print('_onCardEntryComplete');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return BookingCompletePage(
            userId: widget.userId,
            isLargeScreen: widget.isLargeScreen,
            response: _responseFromReserve,
          );
        },
      ),
    );
  }
}
