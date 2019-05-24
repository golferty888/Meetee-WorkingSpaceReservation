import 'package:flutter/material.dart';

class Reservation {
  String type;
  DateTime startDate;
  TimeOfDay startTime;
  TimeOfDay endTime;

  Reservation(this.type, this.startDate, this.startTime, this.endTime);
  
  Map toMap() {
    // {
    //   // 'type': type,
    //   'startDate': startDate,
    //   'timeStart': timeStart,
    //   'timeEnd': timeEnd
    // };
    var map = new Map<String, dynamic>();
    map["type"] = type.toString();
    map["startDate"] = startDate.toString();
    // map["startTime"] = (int.parse(startTime.toString().substring(10, 12)) + 7).toString() + startTime.toString().substring(12, 15) + ':';
    map["startTime"] = startTime.toString().substring(10, 15) + ':';
    // map["endTime"] = (int.parse(endTime.toString().substring(10, 12)) + 7).toString() + endTime.toString().substring(12, 15) + ':';
    map["endTime"] = endTime.toString().substring(10, 15) + ':00';

    return map;
  }
  @override
  String toString() {
    return 'Type: $type\nDate: $startDate\nStart: $startTime\nEnd: $endTime';
  }
}