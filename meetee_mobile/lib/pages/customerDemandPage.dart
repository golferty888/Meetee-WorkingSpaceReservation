import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:meetee_mobile/components/css.dart';
import 'package:meetee_mobile/components/datePicker.dart';
import 'package:meetee_mobile/components/fadeRoute.dart';
import 'package:meetee_mobile/components/periodPickerToday.dart';
import 'package:transparent_image/transparent_image.dart';

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
    @required this.facilityType,
    this.userId,
    this.index,
    this.subType,
    this.isLargeScreen,
  }) : super(key: key);
  @override
  _CustomerDemandPageState createState() => _CustomerDemandPageState();
}

class _CustomerDemandPageState extends State<CustomerDemandPage> {
  DateTime startDate = DateTime.now();
  int startTime = DateTime.now().add(Duration(hours: 1)).hour;
  int endTime = DateTime.now()
      .add(
        Duration(hours: 2),
      )
      .hour;
  bool _isToday = true;

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
  }

  _updateStartTime(int startTime) {
    setState(() {
      this.startTime = startTime;
    });
  }

  _updateEndTime(int endTime) {
    setState(() {
      this.endTime = endTime;
    });
  }

  @override
  void initState() {
    super.initState();
//    if (DateTime.now().hour >= 0) {
//      startTime = 8;
//      endTime = 9;
//      _isToday = false;
//    }
    print(widget.userId);
    urlGetCategoryByFacilityType =
        'http://18.139.12.132:9000/fac/type/${widget.facilityType.typeId}';

    getCategoryByFacilityType();
  }

  String urlGetCategoryByFacilityType;
  List _categoriesList;
  bool _isCategoryLoadDone = false;

  Future<dynamic> getCategoryByFacilityType() async {
    final response = await http.get(
      urlGetCategoryByFacilityType,
    );
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        _categoriesList = json.decode(response.body);
        _isCategoryLoadDone = true;
      });
      print(_categoriesList);
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
            ),
          ),
        );
      },
    );
  }

  _buildCategoryCard(index) {
    return Container(
      child: Stack(
        children: <Widget>[
          Hero(
            tag: 'category + ${index.toString()}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                child: Image.network(
                  _categoriesList[index]["image_url"],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 8.0,
            right: 8.0,
            child: Container(
              padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
//            width: 100,
              decoration: BoxDecoration(
//                borderRadius: BorderRadius.horizontal(
//                  left: Radius.circular(
//                    8.0,
//                  ),
//                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
                color: Colors.black.withOpacity(0.5),
//                color: Color(
//                  widget.facilityType.secondaryColorCode,
//                ),
              ),
              child: Text(
                '4 seats available',
                style: TextStyle(
                  fontSize:
                      widget.isLargeScreen ? fontSizeH3[0] : fontSizeH3[1],
                  color: Colors.white,
                  letterSpacing: 1.0,
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
                        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  _categoriesList[index]["catename"].toString(),
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
                              ],
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '฿${_categoriesList[index]["price"].toString()} per hour',
                                  style: TextStyle(
                                    fontSize: widget.isLargeScreen
                                        ? fontSizeH3[0]
                                        : fontSizeH3[1],
                                    color: Color(
                                      widget.facilityType.secondaryColorCode,
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
                    ? DateTime.now().hour <= 21
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
