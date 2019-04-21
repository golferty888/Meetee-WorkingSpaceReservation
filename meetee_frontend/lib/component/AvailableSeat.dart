import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert'; // JSON

import 'package:meetee_frontend/model/Room.dart';

String url = 'http://localhost:9000/type/seat';

class Available extends StatefulWidget {
  final String room;
  final String date;
  final String status;

  Available({Key key, this.room, this.date, this.status}) : super(key: key);

  @override
  _AvailableState createState() => _AvailableState();
}

class _AvailableState extends State<Available> {
  List rooms = new List<Room>();

  Future<String> getAvailable() async {
    http.Response response = await http
        .post('http://localhost:9000/check/available', body: {
      "startDate": "April 14, 2019",
      "startTime": "15:00:00",
      "endTime": "17:00:00"
    });
    if (response.statusCode == 200) {
      print(jsonEncode(response.body));
      this.setState(() {
        List list = json.decode(response.body);
        rooms = list.map((model) => Room.fromJson(model)).toList();
      });
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState() {
    this.getAvailable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Seat'),
      ),
      body: Container(
          child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true, // container stick with top bar
        itemCount: rooms.length,
        itemBuilder: (BuildContext context, int index) {
          if (context != null) {
            return makeListTile(rooms[index]);
          }
          // return CircularProgressIndicator();
        },
      )),
    );
  }
}

ListTile makeListTile(Room room) {
  return ListTile(
    // contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
        // padding: EdgeInsets.only(right: 12.0), // ข้างรูปซ้าย
        // decoration: BoxDecoration(
        //     border: Border(
        //         right: new BorderSide(width: 1.0, color: Colors.black87))),
        child: Icon(
      IconData(58418, fontFamily: 'MaterialIcons'),
      size: 60.0,
      //     Image.network(
      //   room.roomTypePic,
    )),
    title: Text(
      room.roomName,
      // style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),
    // subtitle: Text("Meeting Room A", style: TextStyle(color: Colors.black38)),
    // subtitle: Row(
    //   children: <Widget>[
    //     Icon(
    //       Icons.person,
    //       color: Colors.grey,
    //       size: 16,
    //     ),
    //     Text(
    //       room.roomCapacity + ' | ฿' + room.roomPrice.toString() + '/hr',
    //     )
    //     // style: TextStyle(color: Colors.green))
    //   ],
    // ),
    trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0),
  );
}
