import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:meetee_mobile/pages/selectFacility.dart';

class HistoryPage extends StatefulWidget {
  final int userId;

  HistoryPage({
    Key key,
    this.userId,
  }) : super(key: key);
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    getHistoryByUserId();
    super.initState();
  }

  final String historyUrl = 'http://18.139.12.132:9000/user/history';

  List historiesList;
  bool _isHasHistory = false;
  bool _isHistoryLoadDone = false;

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

  _buildHistoryList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      scrollDirection: Axis.vertical,
      itemCount: historiesList.length,
      reverse: false,
      itemBuilder: (BuildContext context, int index) {
        return _buildHistories(index);
      },
    );
  }

  _buildHistories(int index) {
    return Container(
      height: 80,
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
                        Container(
                          height: 14,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: historiesList[index]["faclist"].length,
                            itemBuilder: (BuildContext context, int i) {
                              return Padding(
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                                child: Text(
                                  '${historiesList[index]["faclist"][i]["facCode"]}',
                                  style: TextStyle(
                                    color: Colors.black54, fontSize: 12,
//                                  fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'History',
        ),
      ),
      body: SafeArea(
        child: Container(
          child: _isHistoryLoadDone
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
                                isLargeScreen: false,
                              );
                            },
                          ),
                        ).then((v) {
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
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
        ),
      ),
    );
  }
}
