import 'dart:ui';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meetee_mobile/components/css.dart';
import 'package:meetee_mobile/components/fadeRoute.dart';
import 'package:http/http.dart' as http;

import 'package:meetee_mobile/model/facilityType.dart';
import 'package:meetee_mobile/pages/seatMapPage.dart';

class FacilityDetail extends StatefulWidget {
  final bool isLargeScreen;
  final int userId;
  final int type;
  final int index;
  final String imgPath;
  final String mapPath;
  final String categoryIcon;
  final int cateId;
  final String categoryName;
  final Map categoryDetail;
  final int secondaryColor;
  final DateTime startDate;
  final int startTime;
  final int endTime;

  FacilityDetail({
    Key key,
    this.isLargeScreen,
    this.userId,
    this.type,
    this.index,
    this.imgPath,
    this.mapPath,
    this.categoryIcon,
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
  void initState() {
    super.initState();
    getEquipmentByCateId();
  }

  List _equipmentList;
  bool _isEquipmentLoadDone = false;

  List _tmpIcon = [Icons.power, Icons.network_wifi];

  Future<dynamic> getEquipmentByCateId() async {
    final response = await http.get(
      'http://18.139.12.132:9000/fac/cate/${widget.cateId}',
    );
    if (response.statusCode == 200) {
      print(json.decode(response.body));
      setState(() {
        _equipmentList = (json.decode(response.body))["eqlist"];
        _isEquipmentLoadDone = true;
      });
      print(_equipmentList);
    } else {
      print('400');
      throw Exception('Failed to load post');
    }
  }

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
                Expanded(
                  child: Container(),
                ),
                _isEquipmentLoadDone
                    ? Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 5 / 6,
//                        padding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                          height: 40,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _equipmentList.length,
                              reverse: true,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: EdgeInsets.only(left: 8.0),
                                  child: ClipOval(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 5.0,
                                        sigmaY: 5.0,
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                        child: Tooltip(
                                          preferBelow: false,
                                          margin: EdgeInsets.only(bottom: 8.0),
                                          height: 40,
                                          waitDuration: Duration(seconds: 100),
                                          message: _equipmentList[index]
                                              ["eqname"],
                                          child: Icon(
                                            IconData(
                                                _equipmentList[index]
                                                    ["iconcode"],
                                                fontFamily: 'MaterialIcons'),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 16.0,
                ),
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
                                  EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                      SvgPicture.network(
                                        widget.categoryIcon,
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
                                              mapPath: widget.mapPath,
                                              categoryIcon: widget.categoryIcon,
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
                  height: 16.0,
                ),
//                Center(
//                  child: ClipRRect(
//                    borderRadius: BorderRadius.all(
//                      Radius.circular(16.0),
//                    ),
//                    child: BackdropFilter(
//                      filter: ImageFilter.blur(
//                        sigmaX: 5.0,
//                        sigmaY: 5.0,
//                      ),
//                      child: Container(
//                        color: Colors.black.withOpacity(0.5),
//                        padding: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
//                        child: Row(
//                          mainAxisSize: MainAxisSize.min,
//                          children: <Widget>[
//                            Text(
//                              'More detail',
//                              style: TextStyle(
//                                color: Colors.white,
//                                letterSpacing: 1.5,
//                              ),
//                            ),
//                            Icon(
//                              Icons.keyboard_arrow_down,
//                              color: Colors.white,
//                            ),
//                          ],
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
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
