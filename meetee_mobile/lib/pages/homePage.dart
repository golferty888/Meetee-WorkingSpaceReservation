import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:meetee_mobile/components/countDownPanel.dart';
import 'package:meetee_mobile/components/css.dart';
import 'package:meetee_mobile/components/fadeRoute.dart';
import 'package:meetee_mobile/model/facilityType.dart';
import 'package:meetee_mobile/pages/activationPage.dart';
import 'package:meetee_mobile/pages/customerDemandPage.dart';
import 'package:meetee_mobile/pages/historyPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:skeleton_text/skeleton_text.dart';

import 'package:meetee_mobile/pages/selectFacility.dart';

class HomePage extends StatefulWidget {
  final String userName;
  final int userId;

  HomePage({
    Key key,
    this.userName,
    this.userId,
  }) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLargeScreen = false;
  final String upComingUrl = 'http://18.139.12.132:9000/user/history/upcoming';
  final String countDownUrl = 'http://18.139.12.132:9000/activate/initial';
  final String historyUrl = 'http://18.139.12.132:9000/user/history';
  Map<String, String> headers = {"Content-type": "application/json"};

  final _scrollController = ScrollController();

  @override
  void initState() {
    print('userId: ${widget.userId}');
    countDownToUnlock();
    getHistoryByUserId();
//    _scrollController.addListener(onScroll);
    super.initState();
  }

  @override
  void dispose() {
//    _scrollController.removeListener(onScroll);
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
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      setState(() {
        _upComingBookingJson = json.decode(response.body);
        _isUpComingBookingLoadDone = true;
      });
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
    print(jsonData);
    if (response.statusCode == 200) {
      if (jsonData["errorCode"] == '00') {
        print('error 00');
        setState(() {
          _isHistoryLoadDone = true;
          _isHasHistory = true;
          historiesList = (json.decode(response.body))["results"];
        });
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
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16.0,
        8.0,
        16.0,
        0.0,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            FadeRoute(
              page: ActivationPage(
                userId: widget.userId,
                index: index,
                userName: widget.userName,
                upComingBookingJson: _upComingBookingJson,
              ),
            ),
          );
        },
        child: Hero(
          tag: 'activationPanelTag$index',
          child: Container(
            padding: EdgeInsets.all(16.0),
            width: MediaQuery.of(context).size.width * 2 / 3,
            decoration: BoxDecoration(
//              color: Colors.black,
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.all(
                Radius.circular(16.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[700],
                  blurRadius: 16.0, // has the effect of softening the shadow
                  spreadRadius: -8, // has the effect of extending the shadow
                  offset: Offset(
                    0.0, // horizontal, move right 10
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
                  Container(
                    padding: EdgeInsets.all(16.0),
//                    decoration: BoxDecoration(
//                      border: Border.all(
//                        color: Colors.white,
//                      ),
//                      shape: BoxShape.circle,
//                    ),
                    child: Icon(
                      Icons.lock,
                      color: Colors.white,
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
                              padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
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
                                color: Colors.white,
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
                              padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
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
                                color: Colors.white,
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
    );
  }

  _buildHistoryList(int index) {
//    return ListTile(
//      title: Text('dfgdfgd $index'),
//    );
    return Container(
      padding: EdgeInsets.fromLTRB(
        16.0,
        0.0,
        16.0,
        0.0,
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
            child: Row(
              children: <Widget>[
                Text(
                  'Today',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 4.0,
                ),
                Text(
                  'Reservations',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
//              SizedBox(
//                width: 4.0,
//              ),
                Container(
                  width: 12.0,
                  child: IconButton(
                    icon: Icon(
                      Icons.expand_more,
                      color: Colors.black38,
                    ),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(16.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[350],
                  blurRadius: 16.0, // has the effect of softening the shadow
                  spreadRadius: -8, // has the effect of extending the shadow
                  offset: Offset(
                    -3.0, // horizontal, move right 10
                    8.0, // vertical, move down 10
                  ),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(
                        0.0,
                        4.0,
                        0.0,
                        0.0,
                      ),
                      child: Text(
                        '12:00',
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                ' - ',
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                              Text(
                                '13:00',
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              16.0, 0.0, 8.0, 0.0),
                                          padding: EdgeInsets.fromLTRB(
                                              8.0, 4.0, 8.0, 4.0),
                                          decoration: BoxDecoration(
                                            color: Colors.pink[200],
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.0),
                                            ),
                                          ),
                                          child: Text(
                                            'MR-S',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'x 1',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '฿130',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                ' - ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                ),
                              ),
                              Text(
                                '13:00',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              16.0, 2.0, 8.0, 0.0),
                                          padding: EdgeInsets.fromLTRB(
                                              8.0, 4.0, 8.0, 4.0),
                                          decoration: BoxDecoration(
                                            color: Colors.yellow[600],
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.0),
                                            ),
                                          ),
                                          child: Text(
                                            'BT',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'x 2',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '฿120',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                ' - ',
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                              Text(
                                '15:00',
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              16.0, 2.0, 8.0, 0.0),
                                          padding: EdgeInsets.fromLTRB(
                                              8.0, 4.0, 8.0, 4.0),
                                          decoration: BoxDecoration(
                                            color: Colors.yellow[600],
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.0),
                                            ),
                                          ),
                                          child: Text(
                                            'TSF',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'x 2',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '฿120',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                ' - ',
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                              Text(
                                '19:00',
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              16.0, 2.0, 8.0, 0.0),
                                          padding: EdgeInsets.fromLTRB(
                                              8.0, 4.0, 8.0, 4.0),
                                          decoration: BoxDecoration(
                                            color: Colors.blue[300],
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.0),
                                            ),
                                          ),
                                          child: Text(
                                            'SR',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'x 1',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '฿1200',
                                      style: TextStyle(
                                        fontSize: 14.0,
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
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Total    ฿1500',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
//          Divider(
//            color: Colors.black38,
//          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(16.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[350],
                  blurRadius: 16.0, // has the effect of softening the shadow
                  spreadRadius: -8, // has the effect of extending the shadow
                  offset: Offset(
                    -3.0, // horizontal, move right 10
                    8.0, // vertical, move down 10
                  ),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(
                        0.0,
                        4.0,
                        0.0,
                        0.0,
                      ),
                      child: Text(
                        '14:00',
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                ' - ',
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                              Text(
                                '16:00',
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              16.0, 0.0, 8.0, 0.0),
                                          padding: EdgeInsets.fromLTRB(
                                              8.0, 4.0, 8.0, 4.0),
                                          decoration: BoxDecoration(
                                            color: Colors.pink[200],
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.0),
                                            ),
                                          ),
                                          child: Text(
                                            'MR-L',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'x 1',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '฿300',
                                      style: TextStyle(
                                        fontSize: 14.0,
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
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                  child: Text(
                    'Total    ฿300',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
            child: Row(
              children: <Widget>[
                Text(
                  '8 Nov',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 4.0,
                ),
                Text(
                  'Reservations',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
//              SizedBox(
//                width: 4.0,
//              ),
                Container(
                  width: 12.0,
                  child: IconButton(
                    icon: Icon(
                      Icons.expand_more,
                      color: Colors.black38,
                    ),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(16.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[350],
                  blurRadius: 16.0, // has the effect of softening the shadow
                  spreadRadius: -8, // has the effect of extending the shadow
                  offset: Offset(
                    -3.0, // horizontal, move right 10
                    8.0, // vertical, move down 10
                  ),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(
                        0.0,
                        4.0,
                        0.0,
                        0.0,
                      ),
                      child: Text(
                        '09:00',
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                ' - ',
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                              Text(
                                '12:00',
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              16.0, 0.0, 8.0, 0.0),
                                          padding: EdgeInsets.fromLTRB(
                                              8.0, 4.0, 8.0, 4.0),
                                          decoration: BoxDecoration(
                                            color: Colors.yellow[600],
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.0),
                                            ),
                                          ),
                                          child: Text(
                                            'SC',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'x 3',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '฿90',
                                      style: TextStyle(
                                        fontSize: 14.0,
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
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                  child: Text(
                    'Total    ฿90',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
//          Divider(
//            color: Colors.black38,
//          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
            child: Row(
              children: <Widget>[
                Text(
                  '11 Nov',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 4.0,
                ),
                Text(
                  'Reservations',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
//              SizedBox(
//                width: 4.0,
//              ),
                Container(
                  width: 12.0,
                  child: IconButton(
                    icon: Icon(
                      Icons.expand_less,
                      color: Colors.black38,
                    ),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isHistoryLoadDone = false;
  bool _isShowFloatingActionButton = false;

//  _delayHistory() {
//    Future.delayed(Duration(seconds: 2), () {
//      setState(() {
//        _isHistoryLoadDone = true;
//      });
//    });
//  }

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
      backgroundColor: Colors.grey[50],
      floatingActionButton: _isShowFloatingActionButton
          ? Padding(
              padding: EdgeInsets.fromLTRB(
                0.0,
                0.0,
                0.0,
                MediaQuery.of(context).padding.bottom,
              ),
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                tooltip: 'Tab to book',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SelectFacilityType(
                          userId: widget.userId,
                          isLargeScreen: _isLargeScreen,
                        );
                      },
                    ),
                  );
                },
                child: Icon(
                  Icons.add,
                ),
              ),
            )
          : null,
      body: SafeArea(
        right: false,
        left: false,
        bottom: false,
        child: NotificationListener(
          onNotification: (t) {
//            print(_scrollController.position.pixels);
            if (_scrollController.position.pixels.floor() >= 60 &&
                _scrollController.position.pixels.floor() <= 700) {
              setState(() {
                _isShowFloatingActionButton = true;
              });
            } else {
              setState(() {
                _isShowFloatingActionButton = false;
              });
            }
            return true;
          },
          child: CustomScrollView(
            physics: ClampingScrollPhysics(),
            controller: _scrollController,
            shrinkWrap: false,
            slivers: <Widget>[
              SliverAppBar(
                elevation: 0.0,
                centerTitle: false,
                floating: true,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.grey[50],
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Colors.black,
                    ),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.remove('userName');
                      prefs.remove('passWord');
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login', (Route<dynamic> route) => false);
                    },
                  ),
                ],
                title: Text(
                  '${DateFormat("EEEE d MMMM").format(DateTime.now())}',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: _isLargeScreen ? fontSizeH2[0] : fontSizeH2[1],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    16.0,
                    0.0,
                    0.0,
                    16.0,
                  ),
                  child: Text(
                    'Welcome, ${widget.userName}',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: _isLargeScreen ? fontSizeH1[0] : fontSizeH1[1],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    16.0,
                    0.0,
                    16.0,
                    0.0,
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 3 / 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16.0),
                      ),
                      image: DecorationImage(
                        image: AssetImage(
                          'images/single_chair.jpg',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            20.0,
                            0.0,
                            0.0,
                            18.0,
                          ),
                          child: Text(
                            'Most\nBooking',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 48.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
//                          color:
//                              Theme.of(context).primaryColor.withOpacity(0.9),
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(16.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(4.0),
                                    height: 40.0,
                                    width: 40.0,
                                    decoration: BoxDecoration(
                                      color: Colors.yellow[600],
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                    child: SvgPicture.asset(
                                      facilityTypeList[0].imagePath,
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 24,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Single Chair',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${facilityTypeList[0].typeName}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                height: 40.0,
                                width: 80.0,
                                child: RaisedButton(
                                  elevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0),
                                  ),
                                  color: Colors.white,
                                  child: Text(
                                    'Book',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return CustomerDemandPage(
                                            userId: widget.userId,
                                            facilityType: facilityTypeList[0],
                                            index: 0,
                                            subType: 0 == 0 ? 'Seat' : 'Room',
                                            isLargeScreen: _isLargeScreen,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 32.0),
                  child: Divider(
                    indent: 16.0,
                    endIndent: 16.0,
                    color: Colors.grey[400],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate.fixed(
                  [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 8.0),
                      child: Text(
                        'Upcoming bookings',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24.0,
//                letterSpacing: 0.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
                      child: Text(
                        'You can unlock your rooms here.',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _isUpComingBookingLoadDone
                  ? SliverToBoxAdapter(
                      child: _upComingBookingJson.length == 0
                          ? Container(
                              height: 80,
                              child: Center(
                                child: Text('No upcoming booking'),
                              ),
                            )
                          : Container(
                              height:
                                  MediaQuery.of(context).size.height * 2 / 3,
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
                  : SliverToBoxAdapter(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 1 / 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15.0,
                                bottom: 5.0,
                                top: 8.0,
                              ),
                              child: SkeletonAnimation(
                                child: Container(
                                  height: 15,
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.grey[300]),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15.0,
                                bottom: 5.0,
                                top: 8.0,
                              ),
                              child: SkeletonAnimation(
                                child: Container(
                                  height: 15,
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.grey[300]),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15.0,
                                bottom: 5.0,
                                top: 8.0,
                              ),
                              child: SkeletonAnimation(
                                child: Container(
                                  height: 15,
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.grey[300]),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: SkeletonAnimation(
                                  child: Container(
                                    width: 60,
                                    height: 13,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Colors.grey[300]),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 32.0),
                  child: Divider(
                    indent: 16.0,
                    endIndent: 16.0,
                    color: Colors.grey[400],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate.fixed(
                  [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
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
                          Text(
                            'See all',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12.0,
//                            fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _isHistoryLoadDone
                  ? _isHasHistory
                      ? SliverToBoxAdapter(
                          child: _buildHistoryList(0),
                        )
                      : SliverToBoxAdapter(
                          child: Container(
                            height: 80,
                            child: Center(
                              child: Text('No history'),
                            ),
                          ),
                        )
                  : SliverToBoxAdapter(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 15.0,
                              bottom: 5.0,
                              top: 16.0,
                            ),
                            child: SkeletonAnimation(
                              child: Container(
                                height: 15,
                                width: MediaQuery.of(context).size.width * 0.6,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.grey[300]),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: SkeletonAnimation(
                                child: Container(
                                  width: 60,
                                  height: 13,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.grey[300]),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 32.0),
                  child: Divider(
                    indent: 16.0,
                    endIndent: 16.0,
                    color: Colors.grey[400],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                  child: RaisedButton(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
//                  color: Colors.black,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SelectFacilityType(
                              userId: widget.userId,
                              isLargeScreen: _isLargeScreen,
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        'Book now'.toUpperCase(),
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
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
