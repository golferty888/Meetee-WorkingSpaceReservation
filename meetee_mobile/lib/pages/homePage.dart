import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetee_mobile/pages/activationPage.dart';
import 'package:meetee_mobile/pages/historyPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:meetee_mobile/pages/logInPage.dart';
import 'package:meetee_mobile/pages/selectFacility.dart';

class HomePage extends StatefulWidget {
  final String userName;

  HomePage({Key key, this.userName}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String upComingUrl = 'http://18.139.12.132:9000/user/history/upcoming';
  Map<String, String> headers = {"Content-type": "application/json"};
  String body = '{'
      '"userId": 1'
      '}';

  List _upComingList;

  @override
  void initState() {
//    getHistoryByUserId();
    super.initState();
  }

  GestureDetector _menuCard(IconData menuIcon, String menuText, destination) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.only(right: 8.0),
        width: 160,
        decoration: BoxDecoration(
          color: Colors.blueGrey[100].withOpacity(0.5),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              menuIcon,
              color: Colors.black,
            ),
            Text(
              menuText,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildUpComingBookingCard(int index) {
    return GestureDetector(
      child: Container(
        width: index == 0 ? 272 : 136,
//        width: 272.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          image: DecorationImage(
            image: NetworkImage(
              'https://storage.googleapis.com/meetee-file-storage/img/fac/bar-chair.jpg',
            ),
            fit: BoxFit.cover,
          ),
          color: Color(0xFFFF8989),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
//            Icon(
//              menuIcon,
//              color: Colors.blue[600],
//            ),
            Container(
              height: 160.0,
              padding: EdgeInsets.fromLTRB(
                20.0,
                20.0,
                0.0,
                0.0,
              ),
//              color: Colors.black.withOpacity(0.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                gradient: LinearGradient(
                  colors: [
                    Colors.black54,
                    Colors.black38,
                    Colors.black26,
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [
                    0.2,
                    0.4,
                    0.6,
                    0.8,
                  ],
                ),
              ),
              child: Text(
                '${_upComingList[index]["period"]}',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
//                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                0.0,
                0.0,
                16.0,
                0.0,
              ),
//              color: Colors.black.withOpacity(0.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                '${_upComingList[index]["catename"]}',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.0,
//                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card _buildFavoriteCard(int index) {
    return Card(
      elevation: 0.0,
      color: Colors.blueGrey[100].withOpacity(0.5),
      child: Container(
        padding: EdgeInsets.all(10.0),
        width: 136,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.favorite,
            ),
            Text(
              _upComingList[index]["period"],
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            centerTitle: false,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
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
              'Welcome, ${widget.userName}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
//                letterSpacing: 0.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 100.0,
              margin: EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 0.0),
              child: ListView(
                padding: EdgeInsets.only(left: 12.0),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  _menuCard(
                    Icons.calendar_today,
                    'Booking',
                    SelectFacilityType(),
                  ),
                  _menuCard(
                    Icons.vpn_key,
                    'Activate',
                    ActivationPage(),
                  ),
                  _menuCard(
                    Icons.history,
                    'History',
                    HistoryPage(),
                  ),
                  _menuCard(
                    Icons.stars,
                    'Promotion',
                    HomePage(),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  width: double.infinity,
                  height: 8.0,
                  color: Colors.grey[100],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 8.0),
                  child: Text(
                    'Upcoming bookings',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
//                letterSpacing: 0.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  height: 3.0,
                  margin: EdgeInsets.fromLTRB(
                    16.0,
                    4.0,
                    MediaQuery.of(context).size.width - 64.0,
                    4.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.all(
                      Radius.circular(2.0),
                    ),
                  ),
                )
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 8.0),
              height: 200.0,
              child: FutureBuilder(
                future: http.post(
                  upComingUrl,
                  body: body,
                  headers: headers,
                ),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Text('none...');
                    case ConnectionState.active:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.waiting:
//                      if (_isFetched == false) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
//                      }
                      print('waiting');
                      continue done;
                    done:
                    case ConnectionState.done:
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      _upComingList = json.decode(snapshot.data.body);
                      print(_upComingList);
                      return Container(
                        margin: EdgeInsets.fromLTRB(12.0, 0.0, 0.0, 0.0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _upComingList.length,
                          itemBuilder: (BuildContext context, index) {
                            return Container(
                              margin: EdgeInsets.only(
                                right: 12.0,
                              ),
                              child: _buildUpComingBookingCard(index),
                            );
                          },
                        ),
                      );
                  }
                  return null;
                },
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 8.0),
                  child: Text(
                    'Favorite',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
//                letterSpacing: 0.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  height: 3.0,
                  margin: EdgeInsets.fromLTRB(
                    16.0,
                    4.0,
                    MediaQuery.of(context).size.width - 64.0,
                    4.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.all(
                      Radius.circular(2.0),
                    ),
                  ),
                )
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 8.0),
              height: 200.0,
              child: FutureBuilder(
                future: http.post(
                  upComingUrl,
                  body: body,
                  headers: headers,
                ),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Text('none...');
                    case ConnectionState.active:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.waiting:
//                      if (_isFetched == false) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
//                      }
                      print('waiting');
                      continue done;
                    done:
                    case ConnectionState.done:
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      _upComingList = json.decode(snapshot.data.body);
                      return Container(
                        margin: EdgeInsets.fromLTRB(12.0, 0.0, 0.0, 0.0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _upComingList.length,
                          itemBuilder: (BuildContext context, index) {
                            return Container(
                              margin: EdgeInsets.only(
                                right: 8.0,
                              ),
                              child: _buildFavoriteCard(index),
                            );
                          },
                        ),
                      );
                  }
                  return null;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
