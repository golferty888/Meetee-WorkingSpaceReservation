import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:meetee_mobile/components/css.dart';
import 'package:meetee_mobile/components/fadeRoute.dart';
import 'package:meetee_mobile/pages/activationPage.dart';
import 'package:meetee_mobile/pages/historyPage.dart';
import 'package:http/http.dart' as http;

import 'package:meetee_mobile/pages/selectFacility.dart';

class SchedulePage extends StatefulWidget {
  final String userName;
  final int userId;

  SchedulePage({
    Key key,
    this.userName,
    this.userId,
  }) : super(key: key);
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage>
    with SingleTickerProviderStateMixin {
  bool _isLargeScreen = false;
  final String upComingUrl = 'http://18.139.12.132:9000/user/history/upcoming';
  final String countDownUrl = 'http://18.139.12.132:9000/activate/initial';
  final String historyUrl = 'http://18.139.12.132:9000/user/history';
  Map<String, String> headers = {"Content-type": "application/json"};

  AnimationController _mostBookingController;

  @override
  void initState() {
    print('userId: ${widget.userId}');
    countDownToUnlock();
    getHistoryByUserId();
    _mostBookingController = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _mostBookingController.dispose();
    super.dispose();
  }

  var _upComingBookingJson;
  bool _isUpComingBookingLoadDone = false;

  List historiesList;
  bool _isHasHistory = false;

  Future countDownToUnlock() async {
    String body = '{'
        '"userId": ${widget.userId}'
        '}';
    final response = await http.post(
      countDownUrl,
      body: body,
      headers: headers,
    );
//    print(json.decode(response.body));
    if (response.statusCode == 200) {
      setState(() {
        _upComingBookingJson = json.decode(response.body);
        _isUpComingBookingLoadDone = true;
      });
      print('_upComingBookingJson : $_upComingBookingJson');
    } else {
      print('ereer');
      setState(() {
        _isUpComingBookingLoadDone = true;
      });
    }
  }

  Future<dynamic> getHistoryByUserId() async {
    final response = await http.post(
      historyUrl,
      body: {
        "userId": '${widget.userId}',
      },
    );
    var jsonData = json.decode(response.body);
//    print(jsonData);
    if (response.statusCode == 200) {
      if (jsonData["errorCode"] == '00') {
//        print('error 00');
        setState(() {
          _isHistoryLoadDone = true;
          _isHasHistory = true;
          historiesList = (json.decode(response.body))["results"];
        });
        print('history: $historiesList');
      } else if (jsonData["errorCode"] == '01') {
        print('error 01');
        setState(() {
          _isHasHistory = false;
          _isHistoryLoadDone = true;
        });
      } else {
        print('else ${jsonData["errorCode"]}');
      }
    } else {
      throw Exception('Failed to load post');
    }
  }

  _buildUpComingBookingCard(int index) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16.0,
        8.0,
        16.0,
        16.0,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            FadeRoute(
              page: ActivationPage(
                userId: widget.userId,
                upComingBookingJson: _upComingBookingJson[index],
              ),
            ),
          ).then((v) {
            countDownToUnlock();
            getHistoryByUserId();
          });
        },
        child: Hero(
          tag: 'activationPanelTag${_upComingBookingJson[index]["start_time"]}',
          child: Container(
            padding: EdgeInsets.all(16.0),
            width: MediaQuery.of(context).size.width * 2 / 3,
            decoration: BoxDecoration(
//              color: Colors.black,
//              color: Theme.of(context).primaryColor,
              color: Colors.black,
              borderRadius: BorderRadius.all(
                Radius.circular(16.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[500],
                  blurRadius: 8.0, // has the effect of softening the shadow
                  spreadRadius: -2, // has the effect of extending the shadow
                  offset: Offset(
                    8.0, // horizontal, move right 10
                    8.0, // vertical, move down 10
                  ),
                )
              ],
            ),
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
                          DateTime.parse(
                              _upComingBookingJson[index]["start_time"]),
                        )}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                        ),
                      ),
                      Text(
                        '${DateFormat("d MMMM").format(
                          DateTime.parse(
                              _upComingBookingJson[index]["start_time"]),
                        )}',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                  _upComingBookingJson[index]["faclist"][0]["status"] ==
                          'In time'
                      ? Text(
                          '${_upComingBookingJson[index]["faclist"][0]["status"]}',
                          style: TextStyle(
                            fontSize: 32.0,
                            color: Colors.greenAccent[400],
                          ),
                        )
                      : Text(
                          '${_upComingBookingJson[index]["faclist"][0]["status"]}',
                          style: TextStyle(
                            fontSize: 32.0,
                            color: Colors.amber[600],
                          ),
                        ),
                  Text(
                    'to activate your '
                    '${_upComingBookingJson[index]["faclist"].length}'
                    ' facilities',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildHistoryList() {
    print('historiesList.length: ${historiesList.length}');
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
          _buildHistories(0),
          historiesList.length <= 1 ? Container() : _buildHistories(1),
          historiesList.length <= 2 ? Container() : _buildHistories(2),
        ],
      ),
    );
  }

  _buildHistories(int index) {
    print('_buildHistories: $index');
    return Container(
      height: 62,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: Color(int.parse(historiesList[index]["typecolor"])),
              shape: BoxShape.circle,
            ),
            child: FittedBox(
              child: Container(
                height: 10,
                child: SvgPicture.network(
                  historiesList[index]["icon_url"],
                  color: Colors.black,
                  height: 4,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              margin: EdgeInsets.only(bottom: 4, top: 4),
              decoration: BoxDecoration(
//                color: Color(int.parse(historiesList[index]["typecolor"])),
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(16.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[500],
                    blurRadius: 16.0, // has the effect of softening the shadow
                    spreadRadius: -14, // has the effect of extending the shadow
                    offset: Offset(
                      10.0, // horizontal, move right 10
                      4.0, // vertical, move down 10
                    ),
                  )
                ],
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${DateFormat("d MMMM yyyy").format(
                            DateTime.parse(historiesList[index]["starttime"]),
                          )}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '${historiesList[index]["period"]}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        '${historiesList[index]["catename"]}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        '฿ ${historiesList[index]["totalprice"]}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isHistoryLoadDone = false;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.height > 700) {
      setState(() {
        _isLargeScreen = true;
      });
    } else {
      setState(() {
        _isLargeScreen = false;
      });
    }
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        right: false,
        left: false,
        bottom: false,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
              child: Text(
                'Schedule',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: _isLargeScreen ? fontSizeH2[0] : fontSizeH2[1],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 8.0),
                  child: Text(
                    'Upcoming bookings',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
                  child: Text(
                    'You can activate your facilities here.',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ],
            ),
            _isUpComingBookingLoadDone
                ? Container(
                    child: _upComingBookingJson.length == 0
                        ? GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  settings:
                                      RouteSettings(name: '/facilityType'),
                                  builder: (context) {
                                    return SelectFacilityType(
                                      userId: widget.userId,
                                      isLargeScreen: _isLargeScreen,
                                    );
                                  },
                                ),
                              ).then((v) {
                                countDownToUnlock();
                                getHistoryByUserId();
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(32.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'No upcoming booking',
                                    style: TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    'Book now',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(
                            height: 184,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: _upComingBookingJson == null
                                  ? 0
                                  : _upComingBookingJson.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _buildUpComingBookingCard(index);
                              },
                            ),
                          ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * 1 / 8,
                    child: Container(
                      height: 60,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8),
              child: Divider(
                indent: 16.0,
                endIndent: 16.0,
                color: Colors.grey[500],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'History',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryPage(
                            userId: widget.userId,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'See all',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 12.0,
//                            fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _isHistoryLoadDone
                ? _isHasHistory
                    ? _buildHistoryList()
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              settings: RouteSettings(name: '/facilityType'),
                              builder: (context) {
                                return SelectFacilityType(
                                  userId: widget.userId,
                                  isLargeScreen: _isLargeScreen,
                                );
                              },
                            ),
                          ).then((v) {
                            countDownToUnlock();
                            getHistoryByUserId();
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(32.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'No history',
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                'Book now',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                : Container(
                    height: MediaQuery.of(context).size.height / 8,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
