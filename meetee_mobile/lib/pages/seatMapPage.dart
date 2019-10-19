import 'dart:async';
import 'dart:ui';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:meetee_mobile/model/facility.dart';

class SeatMapPage extends StatefulWidget {
//  final int type;
  final int index;
  final String imgPath;
  final String categoryName;
  final String cateId;
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
    this.cateId,
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
  void initState() {
    getSeatByCategory();

    super.initState();
  }

  FacilitiesList facilitiesList;
  final String getSeatByCateURL =
      'http://18.139.12.132:9000/facility/cate/status/av';

  Future<dynamic> getSeatByCategory() async {
    print('cateId: ${widget.cateId},\n'
        'startDate: ${widget.startDate},\n'
        'startTime: ${widget.startTime},\n'
        'endTime: ${widget.endTime},\n'
        'endDate: ${widget.startDate},\n');
    final response = await http.post(
      getSeatByCateURL,
      body: {
        "cateId": widget.cateId,
        "startDate": DateFormat("yyyy-MM-dd").format(widget.startDate),
        "startTime": DateFormat("HH:00:00").format(widget.startTime),
        "endTime": DateFormat("HH:00").format(widget.endTime),
        "endDate": DateFormat("yyyy-MM-dd").format(widget.startDate),
      },
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(jsonData);
      setState(() {
        facilitiesList = FacilitiesList.fromJson(jsonData);
      });
//      print(facilitiesList);
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    String startDateFormatted = DateFormat("dd MMMM").format(widget.startDate);
    String startTimeFormatted = DateFormat("HH:00").format(widget.startTime);
    String endTimeFormatted = DateFormat("HH:00").format(widget.endTime);

    return Scaffold(
      body: Stack(
        children: <Widget>[
//          Hero(
//            tag: 'category + ${widget.index.toString()}',
//            child: Container(
//              decoration: BoxDecoration(
//                image: DecorationImage(
//                  image: AssetImage(
//                    widget.imgPath,
//                  ),
//                  fit: BoxFit.cover,
//                ),
//              ),
//              child: BackdropFilter(
//                filter: ImageFilter.blur(
//                  sigmaX: 5.0,
//                  sigmaY: 5.0,
//                ),
//                child: Container(
//                  color: Colors.black.withOpacity(0.5),
//                ),
//              ),
//            ),
//          ),
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
                Expanded(
//                  height: 400,
                  child: GridView.builder(
                    itemCount: facilitiesList.facilities.length == null
                        ? 0
                        : facilitiesList.facilities.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Text(facilitiesList.facilities[index].code),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
