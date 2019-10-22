import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

class SeatMapPage extends StatefulWidget {
//  final int type;
  final int index;
  final String imgPath;
  final String categoryName;
  final int cateId;
  final int secondaryColor;
  final DateTime startDate;
  final DateTime startTime;
  final DateTime endTime;
  final int price;
  final int type;

  SeatMapPage(
      {Key key,
//        this.type,
      this.index,
      this.imgPath,
      this.categoryName,
      this.cateId,
      this.secondaryColor,
      this.startDate,
      this.startTime,
      this.endTime,
      this.price,
      this.type})
      : super(key: key);
  @override
  _SeatMapPageState createState() => _SeatMapPageState();
}

class _SeatMapPageState extends State<SeatMapPage> {
  @override
  void initState() {
    startDateFormatted = DateFormat("dd MMMM").format(widget.startDate);
    startTimeFormatted = DateFormat("HH:00").format(widget.startTime);
    endTimeFormatted = DateFormat("HH:00").format(widget.endTime);

    startDateFormattedForApi =
        DateFormat("yyyy-MM-dd").format(widget.startDate);
    super.initState();
  }

  final String getSeatsByCateURL =
      'http://18.139.12.132:9000/facility/cate/status';
  final String reserveSeatUrl = 'http://18.139.12.132:9000/reserve';
  Map<String, String> headers = {"Content-type": "application/json"};

  String startDateFormatted;
  String startDateFormattedForApi;
  String startTimeFormatted;
  String endTimeFormatted;
  bool _isFetched = false;

  Future<dynamic> reserveSeat() async {
    String body = '{'
        '"userId": 1,'
        '"startDate": "$startDateFormattedForApi",'
        '"startTime": "$startTimeFormatted",'
        '"endTime": "$endTimeFormatted",'
        '"facId": $_selectedSeatList'
        '}';
    print('body: ' + body);
    final response = await http.post(
      reserveSeatUrl,
//      body: {
//        "userId": 1.toString(),
//        "startDate": "2019-11-17",
//        "startTime": "08:00:00",
//        "endTime": "09:00:00",
//        "facId": [10, 11].toString()
//      },
      headers: headers,
      body: body,
    );
    if (response.statusCode == 200) {
//      final jsonData = json.decode(response.body);
//      print(jsonData.toString());
      print(response.body);
    } else {
      print(response.body);
    }
  }

  List _selectedSeatList = [];
  _onSelectedSeat(selectedSeatIndex) {
    setState(() {
      if (_selectedSeatList.contains(selectedSeatIndex)) {
        _selectedSeatList.remove(selectedSeatIndex);
      } else {
        _selectedSeatList.add(selectedSeatIndex);
      }
    });
  }

  List _seatsList;
  FutureBuilder _buildGridView() {
    return FutureBuilder(
        future: http.post(
          getSeatsByCateURL,
          body: {
            "cateId": widget.cateId.toString(),
            "startDate": "$startDateFormattedForApi",
            "startTime": "$startTimeFormatted",
            "endTime": "$endTimeFormatted",
          },
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
              if (_isFetched == false) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              continue done;

//              return null;
            done:
            case ConnectionState.done:
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
//              print('getSeats: ${json.decode(snapshot.data.body)}');
              _seatsList = json.decode(snapshot.data.body);
              _isFetched = true;
//              print(_seatsList);
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: GridView.count(
                    shrinkWrap: true,
                    primary: false,
                    crossAxisCount: 3,
                    childAspectRatio: 1.7,
                    children: List.generate(
                      _seatsList.length,
                      (index) {
                        return _seatsList[index]["status"] == "available"
                            ? GestureDetector(
                                onTap: () =>
                                    _onSelectedSeat(_seatsList[index]["facid"]),
                                child: Container(
                                  margin: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: _selectedSeatList.contains(
                                            _seatsList[index]["facid"])
                                        ? Color(widget.secondaryColor)
                                        : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _seatsList[index]["code"],
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                    color: Colors.grey[200].withOpacity(0.3),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    _seatsList[index]["code"],
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.3),
                                      fontWeight: FontWeight.normal,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                              );
                      },
                    )),
              );
          }
          return null;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: 'category + ${widget.index.toString()}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.network(
                widget.imgPath,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 5.0,
              ),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          SafeArea(
            child: Container(
              padding: EdgeInsets.only(left: 16.0),
              child: FloatingActionButton(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
//              color: Colors.grey,
              child: SafeArea(
                child: Container(
                  height: 56.0,
                  child: Center(
                    child: Text(
                      widget.categoryName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 56,
                ),
                Expanded(
//                  height: 400,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[200].withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    margin: EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
//                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(8.0)),
                          ),
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '$startDateFormatted',
                                style: TextStyle(
                                  color: Color(widget.secondaryColor),
                                  fontSize: 16.0,
                                ),
                              ),
                              Container(
                                width: 1.0,
                                height: 16.0,
                                color: Colors.grey[200].withOpacity(0.5),
                              ),
                              Text(
                                '$startTimeFormatted - $endTimeFormatted',
                                style: TextStyle(
                                  color: Color(widget.secondaryColor),
                                  fontSize: 16.0,
                                ),
                              ),
                              Container(
                                width: 1.0,
                                height: 16.0,
                                color: Colors.grey[200].withOpacity(0.5),
                              ),
                              Text(
                                '฿${widget.price}/hour',
                                style: TextStyle(
                                  color: Color(widget.secondaryColor),
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildGridView(),
                        Expanded(
                          child: Container(),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(8.0)),
                          ),
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    height: 16.0,
                                    width: 24.0,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      'Available',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    height: 16.0,
                                    width: 24.0,
                                    decoration: BoxDecoration(
                                      color: Color(widget.secondaryColor),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      'Selected',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    height: 16.0,
                                    width: 24.0,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(4.0),
                                      border: Border.all(
                                        color:
                                            Colors.grey[200].withOpacity(0.3),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      'Booked',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Image(
                    image: AssetImage('images/map.jpg'),
                  ),
                ),
                Container(
                  height: 48.0,
                  margin: EdgeInsets.fromLTRB(
                    32.0,
                    16.0,
                    32.0,
                    8.0,
                  ),
                  child: RaisedButton(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    color: Color(widget.secondaryColor),
                    disabledColor:
                        Color(widget.secondaryColor).withOpacity(0.5),
                    onPressed: _selectedSeatList.length == 0
                        ? null
                        : () {
                            reserveSeat();
                          },
                    child: Center(
                      child: _selectedSeatList.length == 0
                          ? widget.type == 0
                              ? Text(
                                  'Select seats to book'.toUpperCase(),
                                  style: TextStyle(
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                )
                              : Text(
                                  'Select rooms to book'.toUpperCase(),
                                  style: TextStyle(
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'BOOK',
                                  style: TextStyle(
                                    letterSpacing: 2.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    ' ${_selectedSeatList.length} ',
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      letterSpacing: 2.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                widget.type == 0
                                    ? Text(
                                        'SEAT',
                                        style: TextStyle(
                                          letterSpacing: 2.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      )
                                    : Text(
                                        'ROOM',
                                        style: TextStyle(
                                          letterSpacing: 2.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                _selectedSeatList.length > 1
                                    ? Text(
                                        'S',
                                        style: TextStyle(
                                          letterSpacing: 2.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      )
                                    : Text(
                                        '',
                                        style: TextStyle(
                                          letterSpacing: 2.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
