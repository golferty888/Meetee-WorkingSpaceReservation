import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:meetee_mobile/components/calendarPicker.dart';
import 'package:meetee_mobile/components/periodPicker.dart';
import 'package:meetee_mobile/model/facilityType.dart';

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
        backgroundColor: Colors.white,
        title: Text(
          'Booking',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22.0,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
//          image: DecorationImage(
//            image: AssetImage(
//              'images/noise.png',
//            ),
//            fit: BoxFit.fill,
//          ),
            ),
        child: Container(
//          color: Colors.white,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.grey[100],
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
//              color: Colors.black,
                          height: 88.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Color(
                              widget.facilityType.secondaryColorCode,
                            ),
//                            image: DecorationImage(
//                              image: AssetImage(
//                                'images/noise.png',
//                              ),
//                              fit: BoxFit.fill,
//                            ),
                          ),
                          margin: EdgeInsets.fromLTRB(
                            24.0,
                            16.0,
                            24.0,
                            8.0,
                          ),
                          padding: EdgeInsets.all(16.0),
                          child: Hero(
                            tag: 'facilityType' + widget.index.toString(),
                            child: SvgPicture.asset(
                              widget.facilityType.imagePath,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: CalendarPicker(),
                          ),
                          Expanded(
                            flex: 1,
                            child: PeriodPicker(),
                          ),
                        ],
                      ),
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
//                          color: Colors.grey,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(32.0),
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(36.0, 16.0, 0.0, 0.0),
                          child: Text(
                            'Select category',
                            style: TextStyle(
                              fontSize: 24.0,
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
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: Colors.white,
                                  image: DecorationImage(
                                    image: AssetImage(
                                      widget.facilityType.categories[
                                          categoryNameList[index]]["cateImage"],
                                    ),
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                margin: EdgeInsets.fromLTRB(
                                  0,
                                  16,
                                  0,
                                  48.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(16.0),
                                      ),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 5.0,
                                          sigmaY: 5.0,
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              Text(
                                                categoryNameList[index],
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: 40.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                '${widget.facilityType.categories[categoryNameList[index]]["capacity"].toString()} persons',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: 24.0,
                                                  fontWeight: FontWeight.bold,
//                                              color: Colors.white,
                                                  color: Color(
                                                    widget.facilityType
                                                        .secondaryColorCode,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
//                                child: Stack(
//                                  children: <Widget>[
//                                    ConstrainedBox(
//                                      constraints: BoxConstraints.expand(),
//                                      child: Container(
//                                        margin: EdgeInsets.fromLTRB(
//                                          24.0,
//                                          300.0,
//                                          24.0,
//                                          24.0,
//                                        ),
//                                        height: 56.0,
////                                            width: 160.0,
////                                        decoration: BoxDecoration(
//                                        color: Colors.grey,
////                                        ),
//                                        child: Text(
//                                          categoryNameList[index],
//                                          textAlign: TextAlign.right,
//                                          style: TextStyle(
//                                            fontSize: 48.0,
//                                            fontWeight: FontWeight.bold,
//                                            color: Colors.white,
//                                          ),
//                                        ),
//                                      ),
//                                    ),
//                                  ],
//                                ),
                              );
                            },
                            itemCount: categoryNameList.length,
                            viewportFraction: 0.7,
                            scale: 0.7,
//                            pagination: SwiperPagination(
//                              margin: EdgeInsets.fromLTRB(0.0, 0, 0.0, 16.0),
//                            ),
                          ),
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
}
