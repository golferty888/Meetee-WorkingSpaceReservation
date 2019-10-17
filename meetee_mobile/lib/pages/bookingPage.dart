import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:meetee_mobile/components/calendarPicker.dart';
import 'package:meetee_mobile/components/periodPicker.dart';
import 'package:meetee_mobile/model/facilityType.dart';
import 'package:meetee_mobile/pages/facilityDetail.dart';

class BookingPage extends StatefulWidget {
  final FacilityType facilityType;
  final int index;
  final String subType;

  BookingPage({
    Key key,
    @required this.facilityType,
    this.index,
    this.subType,
  }) : super(key: key);
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  List categoryNameList;

//  String startDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  DateTime startDate = DateTime.now();
  DateTime startTime = DateTime.now().add(
    Duration(hours: 1),
  );
  DateTime endTime = DateTime.now().add(
    Duration(hours: 2),
  );

  _updateStartDate(DateTime startDate) {
//    String formatted = DateFormat("yyyy-MM-dd").format(startDate);
    setState(() {
      this.startDate = startDate;
    });
  }

  _updateStartTime(DateTime startTime) {
//    String formatted = TimeOfDay(hour: startTime, minute: 0)
//            .toString()
//            .split('(')[1]
//            .split(')')[0] +
//        ':00';
    setState(() {
      this.startTime = startTime;
    });
  }

  _updateEndTime(DateTime endTime) {
//    String formatted = TimeOfDay(hour: endTime, minute: 0)
//            .toString()
//            .split('(')[1]
//            .split(')')[0] +
//        ':00';
    setState(() {
      this.endTime = endTime;
    });
  }

  @override
  void initState() {
    categoryNameList = widget.facilityType.categories.keys.toList();
    print(categoryNameList.length);
    print(widget.facilityType.categories[categoryNameList[0]]["cateImage"]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(
          widget.facilityType.secondaryColorCode,
        ),
        elevation: 0.0,
        title: Text(
          'Booking ${widget.facilityType.typeName.toLowerCase()}',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22.0,
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
                Container(
                  decoration: BoxDecoration(
                    color: Color(
                      widget.facilityType.secondaryColorCode,
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding:
                                EdgeInsets.fromLTRB(40.0, 16.0, 16.0, 16.0),
                            height: 160.0,
                            child: Hero(
                              tag: 'facilityType' + widget.index.toString(),
                              child: SvgPicture.asset(
                                widget.facilityType.imagePath,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 200.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: CalendarPicker(
                                  returnDate: _updateStartDate,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: PeriodPicker(
                                  returnStartTime: _updateStartTime,
                                  returnEndTime: _updateEndTime,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        height: 56.0,
                        decoration: BoxDecoration(
                          color: Color(
                            widget.facilityType.secondaryColorCode,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(32.0),
                            ),
                          ),
                          padding: EdgeInsets.fromLTRB(36.0, 20.0, 0.0, 0.0),
                          child: categoryNameList.length > 1
                              ? Text(
                                  'We have ${categoryNameList.length} types of ${widget.facilityType.typeName.toLowerCase()}.',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black54,
                                  ),
                                )
                              : Text(
                                  'We have ${categoryNameList.length} type of ${widget.facilityType.typeName.toLowerCase()}.',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black54,
                                  ),
                                ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          child: Swiper(
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: EdgeInsets.fromLTRB(
                                    0,
                                    16,
                                    0,
                                    24.0,
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Hero(
                                        tag: 'category + ${index.toString()}',
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                            image: DecorationImage(
                                              image: AssetImage(
                                                widget.facilityType.categories[
                                                        categoryNameList[index]]
                                                    ["cateImage"],
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(),
                                          ),
                                          Hero(
                                            flightShuttleBuilder: (
                                              BuildContext flightContext,
                                              Animation<double> animation,
                                              HeroFlightDirection
                                                  flightDirection,
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
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  bottom: Radius.circular(16.0),
                                                ),
                                                child: BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                    sigmaX: 5.0,
                                                    sigmaY: 5.0,
                                                  ),
                                                  child: Container(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            16.0,
                                                            8.0,
                                                            16.0,
                                                            16.0),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .stretch,
                                                            children: <Widget>[
                                                              Text(
                                                                categoryNameList[
                                                                    index],
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      20.0,
                                                                  color: Colors
                                                                      .white,
//                                                            fontWeight:
//                                                                FontWeight.bold,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 4.0,
                                                              ),
                                                              widget.facilityType
                                                                              .categories[
                                                                          categoryNameList[
                                                                              index]]["capacity"] >
                                                                      1
                                                                  ? Text(
                                                                      '${widget.facilityType.categories[categoryNameList[index]]["capacity"].toString()} persons',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            18.0,
                                                                        letterSpacing:
                                                                            1.5,
                                                                        color:
                                                                            Color(
                                                                          widget
                                                                              .facilityType
                                                                              .secondaryColorCode,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Text(
                                                                      '${widget.facilityType.categories[categoryNameList[index]]["capacity"].toString()} person',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            18.0,
                                                                        letterSpacing:
                                                                            1.5,
                                                                        color:
                                                                            Color(
                                                                          widget
                                                                              .facilityType
                                                                              .secondaryColorCode,
                                                                        ),
                                                                      ),
                                                                    ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  0.0,
                                                                  0.0,
                                                                  16.0,
                                                                  0.0),
                                                          width: 1,
                                                          height: 44.0,
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                        ),
                                                        Container(
                                                          width: 72.0,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Text(
                                                                '฿${widget.facilityType.categories[categoryNameList[index]]["price"].toString()}',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      20.0,
//                                                            color: Colors.white,
//                                                            fontWeight:
//                                                                FontWeight.bold,
                                                                  color: Color(
                                                                    widget
                                                                        .facilityType
                                                                        .secondaryColorCode,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 4.0,
                                                              ),
                                                              Text(
                                                                '/per hour',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  color: Colors
                                                                      .white,
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
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                              loop: false,
                              itemCount: categoryNameList.length,
                              viewportFraction: 0.7,
                              scale: 0.75,
                              onTap: (index) {
                                Navigator.of(context).push(_createRoute(index));
                              }),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Route _createRoute(index) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => FacilityDetail(
        type: widget.index,
        index: index,
        imgPath: widget.facilityType.categories[categoryNameList[index]]
            ["cateImage"],
        categoryName: categoryNameList[index],
        categoryDetail: widget.facilityType.categories[categoryNameList[index]],
        secondaryColor: widget.facilityType.secondaryColorCode,
        startDate: startDate,
        startTime: startTime,
        endTime: endTime,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset(0.0, 0.0);
        var curve = Curves.easeIn;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
