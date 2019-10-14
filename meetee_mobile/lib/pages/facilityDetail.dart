import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:meetee_mobile/model/facilityType.dart';

class FacilityDetail extends StatefulWidget {
  final int index;
  final String imgPath;
  final String categoryName;
  final Map categoryDetail;
  final int secondaryColor;

  FacilityDetail(
      {Key key,
      this.index,
      this.imgPath,
      this.categoryName,
      this.categoryDetail,
      this.secondaryColor})
      : super(key: key);
  @override
  FacilityDetailState createState() => FacilityDetailState();
}

Widget _flightShuttleBuilder(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  return DefaultTextStyle(
    style: DefaultTextStyle.of(toHeroContext).style,
    child: toHeroContext.widget,
  );
}

class FacilityDetailState extends State<FacilityDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Hero(
            flightShuttleBuilder: _flightShuttleBuilder,
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
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(child: Container()),
                    Container(
                      margin: EdgeInsets.fromLTRB(48.0, 0.0, 48.0, 48.0),
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
                            padding: EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
                            child: Row(
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
                                      widget.categoryDetail["capacity"] > 1
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
                                  margin:
                                      EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                                  width: 1,
                                  height: 40.0,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                Container(
                                  width: 72.0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
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
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: ListTile(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                '${widget.categoryName}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
