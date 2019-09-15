import 'package:flutter/material.dart';

class History {
  int user_id;
  int room_id;
  String start_date;
  String end_date;
  String start_time;
  String end_time;
  String created_date;
  History(this.user_id, this.room_id, this.start_date, this.end_date, 
  this.start_time, this.end_time, this.created_date);

  // named constructor
  History.fromJson(Map<dynamic, dynamic> json) : 
    user_id = json['user_id'],
    room_id = json['room_id'],
    start_date = json['start_date'].substring(0, 10),
    end_date = json['end_date'].substring(0, 10),
    start_time = json['start_time'],
    end_time = json['end_time'],
    created_date = json['created_date'];
}
