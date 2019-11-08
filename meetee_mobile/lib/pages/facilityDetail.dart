import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:meetee_mobile/components/css.dart';
import 'package:meetee_mobile/components/fadeRoute.dart';

import 'package:meetee_mobile/model/facilityType.dart';
import 'package:meetee_mobile/pages/seatMapPage.dart';

class FacilityDetail extends StatefulWidget {
  final bool isLargeScreen;
  final int userId;
  final int type;
  final int index;
  final String imgPath;
  final int cateId;
  final String categoryName;
  final Map categoryDetail;
  final int secondaryColor;
  final DateTime startDate;
  final DateTime startTime;
  final DateTime endTime;

  FacilityDetail({
    Key key,
    this.isLargeScreen,
    this.userId,
    this.type,
    this.index,
    this.imgPath,
    this.cateId,
    this.categoryName,
    this.categoryDetail,
    this.secondaryColor,
    this.startDate,
    this.startTime,
    this.endTime,
  }) : super(key: key);
  @override
  FacilityDetailState createState() => FacilityDetailState();
}

class FacilityDetailState extends State<FacilityDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
//                  color: Colors.grey,
                  height: 56.0,
                ),
                Expanded(child: Container()),
                Center(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 5000),
                    width: MediaQuery.of(context).size.width * 5 / 6,
                    child: Hero(
//                      flightShuttleBuilder: (
//                        BuildContext flightContext,
//                        Animation<double> animation,
//                        HeroFlightDirection flightDirection,
//                        BuildContext fromHeroContext,
//                        BuildContext toHeroContext,
//                      ) {
//                        return SingleChildScrollView(
//                          child: fromHeroContext.widget,
//                        );
//                      },
                      tag: 'detail + ${widget.index.toString()}',
                      child: Material(
                        color: Colors.transparent,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 5.0,
                              sigmaY: 5.0,
                            ),
                            child: Container(
                              color: Colors.black.withOpacity(0.5),
                              padding:
                                  EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        widget.categoryName,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        '฿${widget.categoryDetail["price"].toString()} per hour',
                                        style: TextStyle(
                                          fontSize: widget.isLargeScreen
                                              ? fontSizeH3[0]
                                              : fontSizeH3[1],
                                          color: Color(
                                            widget.secondaryColor,
                                          ),
                                        ),
                                      ),
                                      widget.categoryDetail["capacity"] > 1
                                          ? Text(
                                              '${widget.categoryDetail["capacity"].toString()} persons',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontSize: widget.isLargeScreen
                                                    ? fontSizeH3[0]
                                                    : fontSizeH3[1],
                                                letterSpacing: 1.5,
                                                color: Color(
                                                  widget.secondaryColor,
                                                ),
                                              ),
                                            )
                                          : Text(
                                              '${widget.categoryDetail["capacity"].toString()} person',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontSize: widget.isLargeScreen
                                                    ? fontSizeH3[0]
                                                    : fontSizeH3[1],
                                                letterSpacing: 1.5,
                                                color: Color(
                                                  widget.secondaryColor,
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                  Container(
                                    height: 48.0,
                                    margin: EdgeInsets.fromLTRB(
                                      0.0,
                                      16.0,
                                      0.0,
                                      8.0,
                                    ),
                                    child: RaisedButton(
                                      elevation: 0.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      color: Color(widget.secondaryColor),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          FadeRoute(
                                            page: SeatMapPage(
                                              userId: widget.userId,
                                              isLargeScreen:
                                                  widget.isLargeScreen,
                                              index: widget.index,
                                              imgPath: widget.imgPath,
                                              secondaryColor:
                                                  widget.secondaryColor,
                                              cateId: widget.cateId,
                                              categoryName: widget.categoryName,
                                              startDate: widget.startDate,
                                              startTime: widget.startTime,
                                              endTime: widget.endTime,
                                              price: widget
                                                  .categoryDetail["price"],
                                              type: widget.type,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 16.0),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: widget.type == 0
                                            ? Text(
                                                'Select seat'.toUpperCase(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  letterSpacing: 2.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : Text(
                                                'Select room'.toUpperCase(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  letterSpacing: 2.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(16.0),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 5.0,
                        sigmaY: 5.0,
                      ),
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        padding: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'More detail',
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: FloatingActionButton(
                elevation: 0.0,
                backgroundColor: Color(
                  widget.secondaryColor,
                ).withOpacity(0.9),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
