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
import 'package:transparent_image/transparent_image.dart';

import 'package:meetee_mobile/components/calendarPicker.dart';
import 'package:meetee_mobile/components/periodPicker.dart';
import 'package:meetee_mobile/model/facilityType.dart';
import 'package:meetee_mobile/pages/facilityDetail.dart';

class BookingPage extends StatefulWidget {
  final FacilityType facilityType;
  final int index;
  final String subType;
  final bool isLargeScreen;

  BookingPage({
    Key key,
    @required this.facilityType,
    this.index,
    this.subType,
    this.isLargeScreen,
  }) : super(key: key);
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime startDate = DateTime.now();
  DateTime startTime = DateTime.now().add(
    Duration(hours: 1),
  );
  DateTime endTime = DateTime.now().add(
    Duration(hours: 2),
  );

  _updateStartDate(DateTime startDate) {
    setState(() {
      this.startDate = startDate;
    });
  }

  _updateStartTime(DateTime startTime) {
    setState(() {
      this.startTime = startTime;
    });
  }

  _updateEndTime(DateTime endTime) {
    setState(() {
      this.endTime = endTime;
    });
  }

  @override
  void initState() {
    urlGetCategoryByFacilityType =
        'http://18.139.12.132:9000/fac/type/${widget.facilityType.typeId}';
    super.initState();
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
//                  Container(
//                    height: 56.0,
//                    decoration: BoxDecoration(
//                      color: Color(
//                        widget.facilityType.secondaryColorCode,
//                      ),
//                    ),
//                    child: Container(
//                      decoration: BoxDecoration(
//                        color: Colors.white,
//                        borderRadius: BorderRadius.vertical(
//                          top: Radius.circular(32.0),
//                        ),
//                      ),
//                      padding: EdgeInsets.fromLTRB(36.0, 20.0, 0.0, 0.0),
//                      child: _categoriesList.length > 1
//                          ? Text(
//                              'We have ${_categoriesList.length} types of ${widget.facilityType.typeName.toLowerCase()}.',
//                              style: TextStyle(
//                                fontSize: 20.0,
//                                color: Colors.black54,
//                              ),
//                            )
//                          : Text(
//                              'We have ${_categoriesList.length} type of ${widget.facilityType.typeName.toLowerCase()}.',
//                              style: TextStyle(
//                                fontSize: 20.0,
//                                color: Colors.black54,
//                              ),
//                            ),
//                    ),
//                  ),
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
              type: index,
              index: index,
              imgPath: categoriesMap[index]["link_url"],
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
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey[350],
            blurRadius: 16.0, // has the effect of softening the shadow
            spreadRadius: 10, // has the effect of extending the shadow
            offset: Offset(
              0.0, // horizontal, move right 10
              8.0, // vertical, move down 10
            ),
          )
        ],
      ),
      child: Stack(
        children: <Widget>[
          Hero(
            tag: 'category + ${index.toString()}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                child: Image.network(
                  _categoriesList[index]["link_url"],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
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
                        padding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
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
                              ],
                            ),
                            SizedBox(
                              height: 4.0,
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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
//        backgroundColor: Color(
//          widget.facilityType.secondaryColorCode,
//        ),
        backgroundColor: Colors.grey[50],
        elevation: 0.0,
        title: Text(
          'Booking ${widget.facilityType.typeName.toLowerCase()}',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 18.0,
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
//                Container(
//                  decoration: BoxDecoration(
//                    color: Color(
//                      widget.facilityType.secondaryColorCode,
//                    ),
//                  ),
//                  child: Row(
//                    children: <Widget>[
////                      Expanded(
////                        child: GestureDetector(
////                          onTap: () => Navigator.pop(context),
////                          child: Container(
////                            padding:
////                                EdgeInsets.fromLTRB(40.0, 16.0, 16.0, 16.0),
////                            height: 160.0,
////                            child: Hero(
////                              tag: 'facilityType' + widget.index.toString(),
////                              child: SvgPicture.asset(
////                                widget.facilityType.imagePath,
////                              ),
////                            ),
////                          ),
////                        ),
////                      ),
//                      Expanded(
//                        child: Container(
////                          height: 80.0,
//                          child: Row(
////                            crossAxisAlignment: CrossAxisAlignment.stretch,
//                            children: <Widget>[
//                              Expanded(
//                                flex: 1,
//                                child: CalendarPicker(
//                                  returnDate: _updateStartDate,
//                                  primaryColor: null,
//                                ),
//                              ),
//                              Expanded(
//                                flex: 1,
//                                child: PeriodPicker(
//                                  returnStartTime: _updateStartTime,
//                                  returnEndTime: _updateEndTime,
//                                ),
//                              ),
//                            ],
//                          ),
//                        ),
//                      )
//                    ],
//                  ),
//                ),
                DatePicker(
                  primaryColor: widget.facilityType.secondaryColorCode,
                  returnDate: _updateStartDate,
                  titleFontSize:
                      widget.isLargeScreen ? fontSizeH3[0] : fontSizeH3[1],
                  valueFontSize:
                      widget.isLargeScreen ? fontSizeH3[0] : fontSizeH3[1],
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
