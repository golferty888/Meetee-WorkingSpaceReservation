import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:meetee_mobile/model/facilityType.dart';
import 'package:meetee_mobile/model/facility.dart';

import 'package:meetee_mobile/components/datePicker.dart';
import 'package:meetee_mobile/components/timePicker.dart';

class CustomerDemand extends StatefulWidget {
  final FacilityType facilityType;
  final int index;

  CustomerDemand({
    Key key,
    @required this.facilityType,
    this.index,
  }) : super(key: key);
  @override
  _CustomerDemandState createState() => _CustomerDemandState();
}

class _CustomerDemandState extends State<CustomerDemand> {
  String getSeatByClassURL = 'http://18.139.12.132:9000/facility/class/status';

  @override
  void initState() {
    print('init');
    getSeatByClass();
    super.initState();
  }

  FacilitiesList facilitiesList;

  Future<dynamic> getSeatByClass() async {
    final response = await http.post(
      'http://18.139.12.132:9000/facility/class/status',
      body: {
        "classId": widget.facilityType.classId,
        "startDate": startDate,
        "startTime": startTime,
        "endTime": endTime,
        "endDate": startDate,
      },
//      body: {
//        "classId": '1',
//        "startDate": "November 11, 2019",
//        "startTime": "08:00:00",
//        "endDate": "November 11, 2019",
//        "endTime": "10:00:00"
//      },
    );
    print('{\n'
        'classId: ${widget.facilityType.classId},\n'
        'startDate: $startDate,\n'
        'endDate: $startDate,\n'
        'startTime: $startTime,\n'
        'endTime: $endTime,\n'
        '}');
    if (response.statusCode == 200) {
      print('200');
      final jsonData = json.decode(response.body);
      setState(() {
        facilitiesList = FacilitiesList.fromJson(jsonData);
      });
      print(jsonData);
//      print(facilitiesList.facilities);
//      print(facilitiesList.facilities.length);
    } else {
      print('400');
      throw Exception('Failed to load post');
    }
  }

  String startDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String startTime = DateFormat("HH:00:00").format(
    DateTime.now().add(
      Duration(hours: 1),
    ),
  );
  String endTime = DateFormat("HH:00:00").format(
    DateTime.now().add(
      Duration(hours: 2),
    ),
  );

  _updateStartDate(DateTime startDate) {
    String formatted = DateFormat("yyyy-MM-dd").format(startDate);
    setState(() {
      this.startDate = formatted;
    });
    getSeatByClass();
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
    getSeatByClass();
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
    getSeatByClass();
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
          'Reserve ${widget.facilityType.typeName.toLowerCase()}',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Container(
              margin: EdgeInsets.fromLTRB(
                24.0,
                0.0,
                24.0,
                16.0,
              ),
              child: Text(
                'Select seat',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                16.0,
                0.0,
                0.0,
                0.0,
              ),
              height: 32.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: facilitiesList == null
                    ? 0
                    : facilitiesList.facilities.length,
                itemBuilder: (BuildContext context, int index) {
                  if (facilitiesList.facilities[index].status == 'available') {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      padding: EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
                      decoration: BoxDecoration(
                        color: Color(widget.facilityType.secondaryColorCode),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Text(
                        facilitiesList.facilities[index] == null
                            ? 'null'
                            : facilitiesList.facilities[index].code.toString(),
                      ),
                    );
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          height: 48.0,
          decoration: BoxDecoration(
            color: Color(widget.facilityType.secondaryColorCode),
            image: DecorationImage(
              image: AssetImage(
                'images/noise.png',
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: InkWell(
            child: Text(
              'Reserve',
//              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            onTap: () {
              getSeatByClass();
            },
          ),
        ),
      ),
    );
  }
}
