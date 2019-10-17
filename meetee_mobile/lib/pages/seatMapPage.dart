import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SeatMapPage extends StatefulWidget {
//  final int type;
  final int index;
  final String imgPath;
  final String categoryName;
//  final Map categoryDetail;
  final int secondaryColor;
  final DateTime startDate;
  final DateTime startTime;
  final DateTime endTime;

  SeatMapPage({
    Key key,
//        this.type,
    this.index,
    this.imgPath,
    this.categoryName,
//        this.categoryDetail,
    this.secondaryColor,
    this.startDate,
    this.startTime,
    this.endTime,
  }) : super(key: key);
  @override
  _SeatMapPageState createState() => _SeatMapPageState();
}

class _SeatMapPageState extends State<SeatMapPage> {
  @override
  Widget build(BuildContext context) {
    String startDateFormatted = DateFormat("dd MMMM").format(widget.startTime);
    String startTimeFormatted = DateFormat("HH:00").format(widget.startTime);
    String endTimeFormatted = DateFormat("HH:00").format(widget.endTime);

    return Scaffold(
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
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5.0,
                  sigmaY: 5.0,
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: FloatingActionButton(
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
                  title: Text(
                    widget.categoryName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                    ),
                  ),
                  subtitle: Text(
                    '$startTimeFormatted - $endTimeFormatted, $startDateFormatted',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
