import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:meetee_mobile/model/facilityType.dart';
import 'package:meetee_mobile/model/reservation.dart';

import 'package:meetee_mobile/components/datePicker.dart';
import 'package:meetee_mobile/components/timePicker.dart';

class CustomerDemand extends StatefulWidget {
  final FacilityType facilityType;
  final int index;

  CustomerDemand({Key key, @required this.facilityType, this.index})
      : super(key: key);
  @override
  _CustomerDemandState createState() => _CustomerDemandState();
}

class _CustomerDemandState extends State<CustomerDemand> {
  String unavailableSeatURL = 'http://18.139.12.132:9000/check/unavailable/all';

  String startDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String startTime = DateFormat("HH:00:00").format(DateTime.now());
  String endTime = DateFormat("HH:00:00").format(
    DateTime.now().add(
      Duration(hours: 1),
    ),
  );

  _updateStartDate(DateTime startDate) {
    String formatted = DateFormat("yyyy-MM-dd").format(startDate);
    setState(() {
      this.startDate = formatted;
    });
  }

  _updateStartTime(int startTime) {
    String formatted = TimeOfDay(hour: startTime, minute: 0)
            .toString()
            .split('(')[1]
            .split(')')[0] +
        ':00';
    setState(() {
      this.startTime = formatted;
    });
  }

  _updateEndTime(int endTime) {
    String formatted = TimeOfDay(hour: endTime, minute: 0)
            .toString()
            .split('(')[1]
            .split(')')[0] +
        ':00';
    setState(() {
      this.endTime = formatted;
    });
  }

  Future<dynamic> getAllSeat() async {
    final response = await http.post(
      'http://18.139.12.132:9000/check/unavailable/all',
      body: {
        "startDate": startDate,
        "startTime": startTime,
        "endTime": endTime,
        "endDate": startDate,
      },
//      body: {
//        "startDate": "November 11, 2019",
//        "startTime": "08:00:00",
//        "endTime": "09:00:00",
//        "endDate": "November 11, 2019"
//      },
    );
    if (response.statusCode == 200) {
      return print(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
//        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Reserve seat',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
//              color: Colors.black,
                height: 88.0,
                width: 272.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Color(
                    widget.facilityType.secondaryColorCode,
                  ),
                  image: DecorationImage(
                    image: AssetImage(
                      'images/noise.png',
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
                margin: EdgeInsets.fromLTRB(
                  24.0,
                  0.0,
                  24.0,
                  16.0,
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
            DatePicker(
              primaryColor: widget.facilityType.secondaryColorCode,
              returnDate: _updateStartDate,
            ),
            TimePicker(
              primaryColor: widget.facilityType.primaryColor,
              secondaryColor: widget.facilityType.secondaryColorCode,
              returnStartTime: _updateStartTime,
              returnEndTime: _updateEndTime,
            ),
//            SizedBox(
//              height: 80.0,
//            ),
            Text(
              startDate.toString(),
            ),
            Text(
              startTime,
            ),
            Text(
              endTime,
            ),
            RaisedButton(
              color: Colors.black,
              splashColor: Colors.white,
              elevation: 0.0,
              highlightElevation: 0.0,
              child: Text(
                'Reserve',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                getAllSeat();
              },
            ),
            SizedBox(),
          ],
        ),
      ),
    );
  }
}
