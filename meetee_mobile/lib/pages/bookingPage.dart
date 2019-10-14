import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
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
                                child: CalendarPicker(),
                              ),
                              Expanded(
                                flex: 1,
                                child: PeriodPicker(),
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
                                return Hero(
                                  tag: 'category + ${index.toString()}',
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      color: Colors.white,
                                      image: DecorationImage(
                                        image: AssetImage(
                                          widget.facilityType.categories[
                                                  categoryNameList[index]]
                                              ["cateImage"],
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    margin: EdgeInsets.fromLTRB(
                                      0,
                                      16,
                                      0,
                                      24.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              padding: EdgeInsets.fromLTRB(
                                                  16.0, 8.0, 8.0, 8.0),
                                              child: Row(
//                                                crossAxisAlignment:
//                                                    CrossAxisAlignment.end,
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
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            fontSize: 24.0,
                                                            color: Colors.white,
//                                                            fontWeight:
//                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        widget.facilityType.categories[
                                                                        categoryNameList[
                                                                            index]]
                                                                    [
                                                                    "capacity"] >
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
                                                                  color: Color(
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
                                                                  color: Color(
                                                                    widget
                                                                        .facilityType
                                                                        .secondaryColorCode,
                                                                  ),
                                                                ),
                                                              ),
                                                      ],
                                                    ),
                                                  ),
//
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        0.0, 0.0, 16.0, 0.0),
                                                    width: 1,
//                                                    height: double.maxFinite,
                                                    height: 40.0,
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                  ),
                                                  Container(
                                                    width: 72.0,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          '฿${widget.facilityType.categories[categoryNameList[index]]["price"].toString()}',
                                                          style: TextStyle(
                                                            fontSize: 24.0,
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
                                                        Text(
                                                          '/per hour',
                                                          style: TextStyle(
                                                            fontSize: 16.0,
                                                            color: Colors.white,
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
                                      ],
                                    ),
                                  ),
                                );
                              },
                              loop: false,
                              itemCount: categoryNameList.length,
                              viewportFraction: 0.7,
                              scale: 0.75,
                              onTap: (index) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return FacilityDetail(
                                      index: index,
                                      imgPath: widget.facilityType.categories[
                                          categoryNameList[index]]["cateImage"],
                                      categoryName: categoryNameList[index],
                                      categoryDetail: widget.facilityType
                                          .categories[categoryNameList[index]],
                                      secondaryColor: widget
                                          .facilityType.secondaryColorCode,
                                    );
                                  }),
                                );
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
}
