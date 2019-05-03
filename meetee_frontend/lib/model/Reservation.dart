import 'package:flutter/material.dart';

class Reservation {
  String type;
  DateTime startDate = DateTime.now();
  TimeOfDay timeStart;
  TimeOfDay timeEnd;

  // Reservation({this.type, this.startDate, this.timeStart, this.timeEnd});

  // Reservation.fromJson(Map<String, dynamic> json) :
  //   type = json['code'];
  DateTime getDate() {
    print(this.startDate);
    return this.startDate;
  }
}
