import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:meetee_mobile/components/css.dart';
import 'package:meetee_mobile/components/datePicker.dart';
import 'package:meetee_mobile/components/fadeRoute.dart';
import 'package:meetee_mobile/components/periodPickerToday.dart';

import 'package:meetee_mobile/components/calendarPicker.dart';
import 'package:meetee_mobile/components/periodPicker.dart';
import 'package:meetee_mobile/model/facilityType.dart';
import 'package:meetee_mobile/pages/facilityDetail.dart';

class CustomerDemandPage extends StatefulWidget {
  final int userId;
  final FacilityType facilityType;
  final int index;
  final String subType;
  final bool isLargeScreen;

  CustomerDemandPage({
    Key key,
    this.facilityType,
    this.userId,
    this.index,
    this.subType,
    this.isLargeScreen,
  }) : super(key: key);
  @override
  _CustomerDemandPageState createState() => _CustomerDemandPageState();
}

class _CustomerDemandPageState extends State<CustomerDemandPage> {
  DateTime startDate;
  int startTime;
  int endTime;
  bool _isToday;

  _updateStartDate(DateTime startDate) {
    if (startDate.day != DateTime.now().day || DateTime.now().hour >= 21) {
      setState(() {
        _isToday = false;
      });
    } else if (startDate.day == DateTime.now().day) {
      setState(() {
        _isToday = true;
      });
    }
    setState(() {
      this.startDate = startDate;
    });
    getAllAvailableCategoryCount();
  }

  _updateStartTime(int startTime) {
    setState(() {
      this.startTime = startTime;
    });
    getAllAvailableCategoryCount();
  }

  _updateEndTime(int endTime) {
    setState(() {
      this.endTime = endTime;
    });
    getAllAvailableCategoryCount();
  }

  String urlGetCategoryByFacilityType;
  String urlGetAllAvailableCategoryCount =
      'http://18.139.12.132:9000/facility/type/status/av';
  Map<String, String> headers = {"Content-type": "application/json"};

  final WebSocketChannel channel =
      IOWebSocketChannel.connect('ws://18.139.12.132:9001/');

  List _categoriesList;
  List _cateCountList;
  bool _isCategoryLoadDone = false;
  bool _isCateCountListLoadDone = false;

  @override
  void initState() {
    super.initState();

//    print(widget.userId);
    startDate = DateTime.now();
    startTime = DateTime.now().add(Duration(hours: 1)).hour;
    endTime = DateTime.now()
        .add(
          Duration(hours: 2),
        )
        .hour;
    _isToday = true;
    if (DateTime.now().hour >= 21) {
      startDate = DateTime.now().add(
        Duration(days: 1),
      );
      startTime = 8;
      endTime = 9;
    } else if (DateTime.now().hour >= 0 && DateTime.now().hour < 8) {
      print('after mid');
      startTime = 8;
      endTime = 9;
      _isToday = true;
    }
    urlGetCategoryByFacilityType =
        'http://18.139.12.132:9000/fac/type/${widget.facilityType.typeId}';

    getCategoryByFacilityType();
    getAllAvailableCategoryCount();
    _connectSocketForCount();
  }

//  @override
//  void dispose() {
//    channel.sink.close();
//    super.dispose();
//  }

  Future _connectSocketForCount() async {
    print('connect');
    channel.sink.add("Hello, this is Meetee");
    channel.stream.listen((message) {
      print(message);
      getAllAvailableCategoryCount();
    });
  }

  Future<dynamic> getCategoryByFacilityType() async {
    final response = await http.get(
      urlGetCategoryByFacilityType,
    );
    if (response.statusCode == 200) {
//      print(response.body);
      setState(() {
        _categoriesList = json.decode(response.body);
        _isCategoryLoadDone = true;
      });
//      print(_categoriesList);
    } else {
      print('400');
      throw Exception('Failed to load post');
    }
  }

  Future<dynamic> getAllAvailableCategoryCount() async {
    String startDateFormatted = DateFormat("MMMM dd, yyyy").format(startDate);
    String startTimeFormatted = '$startTime:00';
    String endTimeFormatted = '$endTime:00';
//    String body = '{'
//        '"typeId": ${widget.facilityType.typeId}, '
//        '"startDate": "November 17, 2019", '
//        '"startTime": "08:00:00", '
//        '"endTime": "12:00:00"'
//        '}';
    String body = '{'
        '"typeId": ${widget.facilityType.typeId}, '
        '"startDate": "$startDateFormatted}", '
        '"startTime": "$startTimeFormatted", '
        '"endTime": "$endTimeFormatted"'
        '}';
    final response = await http.post(
      urlGetAllAvailableCategoryCount,
      headers: headers,
      body: body,
    );
    if (response.statusCode == 200) {
//      print(response.body);
      setState(() {
        _cateCountList = json.decode(response.body);
        _isCateCountListLoadDone = true;
      });
      print(_cateCountList);
    } else {
      print('400');
      throw Exception('Failed to load post');
    }
  }

  _buildFrontPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: _buildSwiper(_categoriesList),
        ),
      ],
    );
  }

  int selectedIndex;

  Swiper _buildSwiper(categoriesMap) {
    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.fromLTRB(
            4,
            16,
            4,
            24.0,
          ),
          child: _buildCategoryCard(index),
        );
      },
      loop: false,
//      index: widget.index,
      itemCount: categoriesMap.length,
      viewportFraction: 0.8,
      scale: 0.9,
      onTap: (index) {
        Navigator.push(
          context,
          FadeRoute(
            page: FacilityDetail(
              isLargeScreen: widget.isLargeScreen,
              userId: widget.userId,
              type: widget.index,
              index: index,
              imgPath: categoriesMap[index]["image_url"],
              mapPath: categoriesMap[index]["map_url"],
              categoryIcon: categoriesMap[index]["icon_url"],
              cateId: categoriesMap[index]["cateid"],
              categoryName: categoriesMap[index]["catename"],
              categoryDetail: categoriesMap[index],
              secondaryColor: widget.facilityType.secondaryColorCode,
              startDate: startDate,
              startTime: startTime,
              endTime: endTime,
              availableSeatCount: _cateCountList[index]["available_count"],
            ),
          ),
        ).then((v) {
          getAllAvailableCategoryCount();
        });
      },
    );
  }

  _countColor(int count) {
    if (count == 1) {
      return Colors.red;
    } else if (count == 0) {
      return Colors.grey[300];
    } else {
      return Color(0xFF292b66);
    }
  }

  _buildCategoryCard(index) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey[500],
            blurRadius: 16.0, // has the effect of softening the shadow
            spreadRadius: -2, // has the effect of extending the shadow
            offset: Offset(
              8.0, // horizontal, move right 10
              8.0, // vertical, move down 10
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          _isCateCountListLoadDone
              ? Container(
                  margin: EdgeInsets.only(right: 14),
                  height: 4,
                  width: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(
                        4.0,
                      ),
                    ),

                    color:
                        _countColor(_cateCountList[index]["available_count"]),
//              color: Colors.indigo[600],
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(right: 14),
                  height: 4,
                  width: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(
                        4.0,
                      ),
                    ),
                    color: Color(0xFF292b66),
//              color: Colors.indigo[600],
                  ),
                ),
          Expanded(
            child: Stack(
              children: <Widget>[
                Hero(
                  tag: 'category + ${index.toString()}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.network(
                      _categoriesList[index]["image_url"],
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                _isCateCountListLoadDone
                    ? Positioned(
                        top: 0.0,
                        right: 14.0,
                        child: Container(
                          width: 72,
                          padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
//            width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(
                                4.0,
                              ),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius:
                                    4.0, // has the effect of softening the shadow
                                spreadRadius:
                                    -2, // has the effect of extending the shadow
                                offset: Offset(
                                  4.0, // horizontal, move right 10
                                  4.0, // vertical, move down 10
                                ),
                              )
                            ],
                            color: _countColor(
                                _cateCountList[index]["available_count"]),
//                      color: Colors.red,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '${_cateCountList[index]["available_count"]}',
                                    style: TextStyle(
                                      fontSize: widget.isLargeScreen
                                          ? fontSizeH1[0]
                                          : fontSizeH1[1],
                                      color: _cateCountList[index]
                                                  ["available_count"] ==
                                              0
                                          ? Colors.grey[500]
                                          : Colors.white,
                                      fontWeight: FontWeight.normal,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  SvgPicture.network(
                                    _categoriesList[index]["icon_url"],
                                    height: widget.isLargeScreen
                                        ? fontSizeH2[0]
                                        : fontSizeH2[1],
                                    color: _cateCountList[index]
                                                ["available_count"] ==
                                            0
                                        ? Colors.grey[500]
                                        : Colors.white,
                                  ),
                                ],
                              ),
                              Text(
                                'available',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: _cateCountList[index]
                                              ["available_count"] ==
                                          0
                                      ? Colors.grey[500]
                                      : Colors.white,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Positioned(
                        top: 0.0,
                        right: 14.0,
                        child: Container(
                          width: 72,
                          height: 48,
                          padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 8.0),
//            width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(
                                4.0,
                              ),
                            ),
                            color: Color(0xFF292b66),
//                      color: Colors.red,
                          ),
                          child: Center(
                            child: Container(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(),
                    ),
                    Hero(
                      flightShuttleBuilder: (
                        BuildContext flightContext,
                        Animation<double> animation,
                        HeroFlightDirection flightDirection,
                        BuildContext fromHeroContext,
                        BuildContext toHeroContext,
                      ) {
                        return SingleChildScrollView(
                          child: fromHeroContext.widget,
                        );
                      },
                      tag: 'detail + ${index.toString()}',
                      child: Material(
                        color: Colors.transparent,
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(16.0),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 5.0,
                              sigmaY: 5.0,
                            ),
                            child: Container(
                              color: Colors.black.withOpacity(0.5),
                              padding:
                                  EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        _categoriesList[index]["catename"]
                                            .toString(),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: widget.isLargeScreen
                                              ? fontSizeH1[0]
                                              : fontSizeH1[1],
                                          color: Colors.white,
                                        ),
                                      ),
                                      SvgPicture.network(
                                        _categoriesList[index]["icon_url"],
                                        height: widget.isLargeScreen
                                            ? fontSizeH1[0]
                                            : fontSizeH1[1],
                                        color: Colors.white,
                                      ),
//
                                    ],
                                  ),
                                  SizedBox(
                                    height: 6.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        '฿${_categoriesList[index]["price"].toString()} per hour',
                                        style: TextStyle(
                                          fontSize: widget.isLargeScreen
                                              ? fontSizeH3[0]
                                              : fontSizeH3[1],
                                          color: Color(
                                            widget.facilityType
                                                .secondaryColorCode,
                                          ),
                                        ),
                                      ),
                                      _categoriesList[index]["capacity"] > 1
                                          ? Text(
                                              '${_categoriesList[index]["capacity"].toString()} persons',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontSize: widget.isLargeScreen
                                                    ? fontSizeH3[0]
                                                    : fontSizeH3[1],
                                                letterSpacing: 1.5,
                                                color: Color(
                                                  widget.facilityType
                                                      .secondaryColorCode,
                                                ),
                                              ),
                                            )
                                          : Text(
                                              '${_categoriesList[index]["capacity"].toString()} person',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontSize: widget.isLargeScreen
                                                    ? fontSizeH3[0]
                                                    : fontSizeH3[1],
                                                letterSpacing: 1.5,
                                                color: Color(
                                                  widget.facilityType
                                                      .secondaryColorCode,
                                                ),
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
//    print(_isToday);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
//        backgroundColor: Color(
//          widget.facilityType.secondaryColorCode,
//        ),
        backgroundColor: Colors.grey[50],
        elevation: 0.0,
        title: Text(
          'Booking ${widget.facilityType.typeName.toLowerCase()}'.toUpperCase(),
          style: TextStyle(
            color: Colors.black54,
            fontSize: widget.isLargeScreen ? fontSizeH3[0] : fontSizeH3[1],
          ),
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: 24.0),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Container(
        child: Container(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                DatePicker(
                  primaryColor: widget.facilityType.secondaryColorCode,
                  returnDate: _updateStartDate,
                  titleFontSize:
                      widget.isLargeScreen ? fontSizeH3[0] : fontSizeH3[1],
                  valueFontSize:
                      widget.isLargeScreen ? fontSizeH3[0] : fontSizeH3[1],
                  isLargeScreen: widget.isLargeScreen,
                ),
                _isToday
                    ? DateTime.now().hour < 21
                        ? PeriodPickerToday(
                            returnStartTime: _updateStartTime,
                            returnEndTime: _updateEndTime,
                            color: widget.facilityType.secondaryColorCode,
                            isLargeScreen: widget.isLargeScreen,
                          )
                        : PeriodPicker(
                            returnStartTime: _updateStartTime,
                            returnEndTime: _updateEndTime,
                            color: widget.facilityType.secondaryColorCode,
                            isLargeScreen: widget.isLargeScreen,
                          )
                    : PeriodPicker(
                        returnStartTime: _updateStartTime,
                        returnEndTime: _updateEndTime,
                        color: widget.facilityType.secondaryColorCode,
                        isLargeScreen: widget.isLargeScreen,
                      ),
                Expanded(
                  child: _isCategoryLoadDone
                      ? _buildFrontPanel()
                      : Center(
                          child: CircularProgressIndicator(),
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
