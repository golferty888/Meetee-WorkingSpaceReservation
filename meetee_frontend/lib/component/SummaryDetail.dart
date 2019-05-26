import 'dart:convert';

import "package:flutter/material.dart";
import 'package:meetee_frontend/main.dart';
import 'package:meetee_frontend/model/Room.dart';
import 'package:http/http.dart' as http;

class SummaryDetail extends StatefulWidget {
  final room;
  final price;
  final reservation;

  SummaryDetail(this.room, this.price, this.reservation);

  @override
  _SummaryDetail createState() => _SummaryDetail();
}

class _SummaryDetail extends State<SummaryDetail> {
  // List rooms = new List<Room>();
  // final room_detail;
  // SummaryDetail(this.room_detail);
  String urlReserve = 'http://18.139.12.132:9000/reserve';

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

  void _showDialog() {
    reserve(widget.room);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(6.0)),
          title: new Text("Reserve complete!"),
          // content: new Text("Alert Dialog body"),
          actions: <Widget>[
            // new FlatButton(
            //   child: new Text("Close"),
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            // ),
            new FlatButton(
              // shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              child: new Text("Go to home page"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MeeteeApp()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.roomName),
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
              // 'Name: ' +
              //     widget.room.roomName +
              //     '\n' +
              'Date: ' +
                  (widget.reservation.toMap())['startDate'].substring(0, 10) +
                  '\nTime: ' +
                  (widget.reservation.toMap())['startTime'] +
                  '00 - ' +
                  (widget.reservation.toMap())['endTime'] +
                  '\nPrice: ' +
                  widget.price.toString() +
                  ' baht/hours',
              style: TextStyle(fontSize: 16),
            ),
            ButtonTheme(
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0)),
              minWidth: 300,
              child: RaisedButton(
                elevation: 10,
                onPressed: () => _showDialog(),
                // onPressed: () => reserve(widget.room),
                color: Color(0xFFFF6F61),
                textColor: Colors.white,
                child: Text('Reserve'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
