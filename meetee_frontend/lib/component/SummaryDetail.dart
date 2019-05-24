import 'dart:convert';

import "package:flutter/material.dart";
import 'package:meetee_frontend/model/Reservation.dart';
import 'package:meetee_frontend/model/Room.dart';
import 'package:http/http.dart' as http;

class SummaryDetail extends StatefulWidget {
  final room;
  final reservation;

  SummaryDetail(this.room, this.reservation);

  @override
  _SummaryDetail createState() => _SummaryDetail();
}

class _SummaryDetail extends State<SummaryDetail> {
  // List rooms = new List<Room>();
  // final room_detail;
  // SummaryDetail(this.room_detail);
 String urlReserve = 'http://18.139.5.203:9000/reserve';
 
  Future<Null> reserve(Room room) async {
    final body = {
      'userId': '1',
      'roomId': room.roomId.toString(),
      'startDate': (widget.reservation.toMap())['startDate'],
      'endDate': (widget.reservation.toMap())['startDate'],
      'startTime': (widget.reservation.toMap())['startTime'],
      'endTime': (widget.reservation.toMap())['endTime'],
    };
    print(body);
    http.Response response = await http.post(urlReserve, body: body);
    if (response.statusCode == 200) {
      print('reserve success');
      print(jsonEncode(response.body));
      // this.setState(() {
      //   List list = json.decode(response.body);
      //   rooms = list.map((model) => Room.fromJson(model)).toList();
      // });
    } else {
      print('reserve fail');
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('detail page'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: Hero(
                  tag: "picture_" + widget.room.roomId.toString(),
                  // child: Text(room_detail.roomName),
                  // child: CircleAvatar(
                  //   radius: 100,
                  //   backgroundImage: NetworkImage(_user.avatar),
                  // ),
                  child: Icon(
                    IconData(58418, fontFamily: 'MaterialIcons'),
                    size: 60.0,
                  )),
            ),
            Text(
              'Name: ' +
                  widget.room.roomName +
                  '\n' +
                  'Date: ' +
                  (widget.reservation.toMap())['startDate'].substring(0, 10) +
                  '\nTime: ' +
                  (widget.reservation.toMap())['startTime'] +
                  '00 - ' +
                  (widget.reservation.toMap())['endTime'] +
                  '\nPrice: ' + widget.room.roomPrice.toString(),
              style: TextStyle(fontSize: 22),
            ),
            RaisedButton(
              elevation: 10,
              onPressed: () => reserve(widget.room),
              child: Text('Please press me'),
            )
          ],
        ),
      ),
    );
  }
}
