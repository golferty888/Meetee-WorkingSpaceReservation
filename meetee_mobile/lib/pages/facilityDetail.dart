import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:meetee_mobile/model/facilityType.dart';
import 'package:meetee_mobile/pages/seatMapPage.dart';

class FacilityDetail extends StatefulWidget {
  final int type;
  final int index;
  final String imgPath;
  final String categoryName;
  final Map categoryDetail;
  final int secondaryColor;
  final DateTime startDate;
  final DateTime startTime;
  final DateTime endTime;

  FacilityDetail({
    Key key,
    this.type,
    this.index,
    this.imgPath,
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
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    widget.imgPath,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
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
                  child: Container(
                    width: 320.0,
                    child: Hero(
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
                                  EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            Text(
                                              widget.categoryName,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontSize: 24.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                            widget.categoryDetail["capacity"] >
                                                    1
                                                ? Text(
                                                    '${widget.categoryDetail["capacity"].toString()} persons',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontSize: 18.0,
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
                                                      fontSize: 18.0,
                                                      letterSpacing: 1.5,
                                                      color: Color(
                                                        widget.secondaryColor,
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(
                                            0.0, 0.0, 16.0, 0.0),
                                        width: 1,
                                        height: 40.0,
                                        color: Colors.grey.withOpacity(0.5),
                                      ),
                                      Container(
                                        width: 72.0,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              '฿${widget.categoryDetail["price"].toString()}',
                                              style: TextStyle(
                                                fontSize: 24.0,
                                                color: Color(
                                                  widget.secondaryColor,
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
                                          MaterialPageRoute(
                                            builder: (context) => SeatMapPage(
                                              index: widget.index,
                                              imgPath: widget.imgPath,
                                              secondaryColor:
                                                  widget.secondaryColor,
                                              categoryName: widget.categoryName,
                                              startDate: widget.startDate,
                                              startTime: widget.startTime,
                                              endTime: widget.endTime,
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
                        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
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
