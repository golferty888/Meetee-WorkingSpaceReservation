import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:meetee_mobile/components/css.dart';

import 'package:meetee_mobile/pages/summary.dart';

class SeatMapPage extends StatefulWidget {
//  final int type;
  final bool isLargeScreen;
  final int userId;
  final int index;
  final String imgPath;
  final String mapPath;
  final String categoryIcon;
  final String categoryName;
  final int cateId;
  final int secondaryColor;
  final DateTime startDate;
  final int startTime;
  final int endTime;
  final int price;
  final int type;

  SeatMapPage(
      {Key key,
//        this.type,
      this.isLargeScreen,
      this.userId,
      this.index,
      this.imgPath,
      this.mapPath,
      this.categoryIcon,
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
    startDateFormatted = DateFormat("dd MMM").format(widget.startDate);
    startTimeFormatted = '${widget.startTime}:00';
    endTimeFormatted = '${widget.endTime}:00';
//    totalHour = widget.endTime.difference(widget.startTime).inHours;
    totalHour = widget.endTime - widget.startTime;

    startDateFormattedForApi =
        DateFormat("yyyy-MM-dd").format(widget.startDate);
    super.initState();
  }

  final String getSeatsByCateURL =
      'http://18.139.12.132:9000/facility/cate/status';

  String startDateFormatted;
  String startDateFormattedForApi;
  String startTimeFormatted;
  String endTimeFormatted;
  int totalHour;
  bool _isFetched = false;

  int _totalPrice = 0;
  List _selectedSeatList = [];
  List _selectedSeatCode = [];
  _onSelectedSeat(selectedSeatFacId, selectedSeatCode) {
    setState(() {
      if (_selectedSeatList.contains(selectedSeatFacId)) {
        _selectedSeatList.remove(selectedSeatFacId);
        _selectedSeatCode.remove(selectedSeatCode);
      } else {
        _selectedSeatList.add(selectedSeatFacId);
        _selectedSeatCode.add(selectedSeatCode);
      }
      _totalPrice = (widget.price * totalHour) * _selectedSeatList.length;
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
//            print(_seatsList);

            return Container(
              height: 64,
              child: Stack(
                children: <Widget>[
                  ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _seatsList.length,
                    padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                    itemBuilder: (BuildContext context, int index) {
                      return _buildSelectableGrid(_seatsList, index);
//                      return _seatsList[index]["status"] == "available"
//                          ? GestureDetector(
//                              onTap: () => _onSelectedSeat(
//                                _seatsList[index]["facid"],
//                                _seatsList[index]["code"],
//                              ),
//                              child: Container(
//                                margin: EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 0.0),
//                                decoration: BoxDecoration(
//                                  color: _selectedSeatList
//                                          .contains(_seatsList[index]["facid"])
//                                      ? Color(widget.secondaryColor)
//                                      : Colors.transparent,
//                                  borderRadius: BorderRadius.circular(8.0),
////                                  border: Border.all(
////                                    color: Colors.grey[900].withOpacity(0.2),
////                                  ),
//                                ),
//                                width: 64,
//                                child: Column(
//                                  mainAxisAlignment:
//                                      MainAxisAlignment.spaceEvenly,
//                                  children: <Widget>[
//                                    SvgPicture.network(
//                                      widget.categoryIcon,
//                                      height: 24,
//                                      color: _selectedSeatList.contains(
//                                              _seatsList[index]["facid"])
//                                          ? Colors.black
//                                          : Colors.white,
//                                    ),
//                                    Center(
//                                      child: Text(
//                                        _seatsList[index]["code"].toString(),
//                                        style: TextStyle(
//                                          color: _selectedSeatList.contains(
//                                                  _seatsList[index]["facid"])
//                                              ? Colors.black
//                                              : Colors.white,
//                                          fontWeight: FontWeight.normal,
////                                      letterSpacing: 1.0,
//                                        ),
//                                      ),
//                                    ),
//                                  ],
//                                ),
//                              ),
//                            )
//                          : Container(
//                              width: 64,
//                              margin: EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 0.0),
//                              color: Colors.transparent,
//                              child: Column(
//                                mainAxisAlignment:
//                                    MainAxisAlignment.spaceEvenly,
//                                children: <Widget>[
//                                  SvgPicture.network(
//                                    widget.categoryIcon,
//                                    height: 24,
//                                    color: Colors.grey[800].withOpacity(0.4),
//                                  ),
//                                  Center(
//                                    child: Text(
////                                      _seatsList[index]["code"].toString(),
//                                      'Booked',
//                                      style: TextStyle(
//                                        color:
//                                            Colors.grey[800].withOpacity(0.5),
//                                        fontWeight: FontWeight.normal,
////                                    letterSpacing: 1.5,
//                                      ),
//                                    ),
//                                  ),
//                                ],
//                              ),
//                            );
                    },
                  ),
                ],
              ),
            );
        }
        return null;
      },
    );
  }

  _buildSelectableGrid(List seatsList, int index) {
//    print(seatsList[index]["status"]);
    if (seatsList[index]["status"] == "available") {
      return GestureDetector(
        onTap: () => _onSelectedSeat(
          _seatsList[index]["facid"],
          _seatsList[index]["code"],
        ),
        child: Container(
          margin: EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 0.0),
          decoration: BoxDecoration(
            color: _selectedSeatList.contains(_seatsList[index]["facid"])
                ? Color(widget.secondaryColor)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: _selectedSeatList.contains(_seatsList[index]["facid"])
                  ? Colors.transparent
                  : Colors.grey[500].withOpacity(0.4),
            ),
          ),
          width: 64,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SvgPicture.network(
                widget.categoryIcon,
                height: 24,
                color: _selectedSeatList.contains(_seatsList[index]["facid"])
                    ? Colors.black
                    : Colors.white,
              ),
              Center(
                child: Text(
                  _seatsList[index]["code"].toString(),
                  style: TextStyle(
                    color:
                        _selectedSeatList.contains(_seatsList[index]["facid"])
                            ? Colors.black
                            : Colors.white,
                    fontWeight: FontWeight.normal,
//                                      letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (seatsList[index]["status"] == "unavailable") {
      return Container(
        width: 64,
        margin: EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 0.0),
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SvgPicture.network(
              widget.categoryIcon,
              height: 24,
              color: Colors.grey[800].withOpacity(0.4),
            ),
            Center(
              child: Text(
                'Booked',
                style: TextStyle(
                  color: Colors.grey[800].withOpacity(0.5),
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (seatsList[index]["status"] == "pending") {
      return Container(
        width: 64,
        margin: EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 0.0),
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SvgPicture.network(
              widget.categoryIcon,
              height: 24,
              color: Colors.amber[600].withOpacity(0.7),
            ),
            Center(
              child: Text(
                'Pending',
                style: TextStyle(
                  color: Colors.amber[600].withOpacity(0.7),
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  _buildLegends(Color color, String text) {
    return Row(
      children: <Widget>[
        Container(
          height: widget.isLargeScreen ? 16.0 : 12.0,
          width: widget.isLargeScreen ? 24.0 : 12.0,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: widget.isLargeScreen ? null : 12.0,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
//    print(widget.categoryIcon);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: 'category + ${widget.index.toString()}',
            child: Image.network(
              widget.imgPath,
              height: double.infinity,
              fit: BoxFit.cover,
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
          Container(
            color: Colors.black.withOpacity(0.7),
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
                      widget.categoryName.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: widget.isLargeScreen
                            ? fontSizeH3[0]
                            : fontSizeH3[1],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 56,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                    child: Container(
//                      color: Colors.black.withOpacity(0.7),
                      child: SvgPicture.network(
                        widget.mapPath,
//                        'images/map/meetee-map.svg',
//                          width: MediaQuery.of(context).size.width,
//                          fit: BoxFit.fitWidth,
                      ),
//                        child: Image.asset('images/map/meetee-map-test-01.png'),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
//                    color: Colors.black.withOpacity(0.7),
//                      border: Border.all(
//                        color: Colors.grey[200].withOpacity(0.5),
//                      ),
//                    borderRadius: BorderRadius.circular(8.0),
                      ),
//                  margin: EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 8.0),
//                  padding: EdgeInsets.fromLTRB(24, 0.0, 24, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(48.0, 0.0, 48.0, 8.0),
                        child: Text(
                          widget.categoryName,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: widget.isLargeScreen
                                ? fontSizeH2[0]
                                : fontSizeH2[1],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
//                            color: Colors.black.withOpacity(0.5),
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(8.0)),
                        ),
                        padding: EdgeInsets.fromLTRB(48.0, 0.0, 48.0, 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '$startDateFormatted',
                              style: TextStyle(
                                color: Color(widget.secondaryColor),
                                fontSize: widget.isLargeScreen
                                    ? fontSizeH3[0]
                                    : fontSizeH3[1],
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
                                fontSize: widget.isLargeScreen
                                    ? fontSizeH3[0]
                                    : fontSizeH3[1],
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
                                fontSize: widget.isLargeScreen
                                    ? fontSizeH3[0]
                                    : fontSizeH3[1],
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildGridView(),
//                        Expanded(
//                          child: Container(),
//                        ),
                      Container(
                        decoration: BoxDecoration(
//                            color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(8.0),
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(48.0, 16.0, 48.0, 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            _buildLegends(
                              Color(widget.secondaryColor),
                              'Selected',
                            ),
                            _buildLegends(
                              Colors.white,
                              'Available',
                            ),
                            _buildLegends(
//                              Colors.grey[800].withOpacity(0.4),
                              Colors.amber,
                              'Pending',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 48.0,
                  margin: EdgeInsets.fromLTRB(
                    24.0,
                    8.0,
                    24.0,
                    16.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[500],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Text(
                              '฿${_totalPrice.toString()}',
                              style: TextStyle(
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Expanded(
                        flex: 3,
                        child: RaisedButton(
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          color: Color(widget.secondaryColor),
                          disabledColor:
                              Color(widget.secondaryColor).withOpacity(0.3),
                          onPressed: _selectedSeatList.length == 0
                              ? null
                              :
//                        () {
//                            reserveSeat();
//                          },
                              () {
                                  print('userId: ${widget.userId}');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Summary(
                                        userId: widget.userId,
                                        isLargeScreen: widget.isLargeScreen,
                                        colorCode: widget.secondaryColor,
                                        startDate: widget.startDate,
                                        startTime: widget.startTime,
                                        endTime: widget.endTime,
                                        facId: _selectedSeatList,
                                        type: widget.categoryName,
                                        code: _selectedSeatCode,
                                        totalPrice: _totalPrice.toString(),
                                        imgPath: widget.imgPath,
                                        index: widget.index,
                                      ),
                                    ),
                                  );
                                },
                          child: Center(
                            child: _selectedSeatList.length == 0
                                ? widget.type == 0
                                    ? Text(
                                        'Book 0 seat'.toUpperCase(),
                                        style: TextStyle(
                                          letterSpacing: 1.5,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700],
                                        ),
                                      )
                                    : Text(
                                        'Book 0 room'.toUpperCase(),
                                        style: TextStyle(
                                          letterSpacing: 1.5,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700],
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
                                            fontSize: 20.0,
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
          ),
        ],
      ),
    );
  }
}
