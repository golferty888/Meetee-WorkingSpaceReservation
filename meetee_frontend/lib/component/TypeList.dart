import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert'; // JSON

import 'package:meetee_frontend/model/Type.dart';
import 'package:meetee_frontend/component/AvailableSeat.dart';

class SeatType extends StatefulWidget {
  final String type;

  SeatType({this.type});

  @override
  _SeatTypeState createState() => _SeatTypeState(type);
}

class _SeatTypeState extends State<SeatType> {
  String type;
  _SeatTypeState(this.type);

  List roomTypes = new List<Type>();

  @override
  void initState() {
    this.getSeatType(this.type);
    super.initState();
  }

  Future<String> getSeatType(String type) async {
    String url = 'http://localhost:9500/type/' + type;
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      print(jsonEncode(response.body));
      this.setState(() {
        List list = json.decode(response.body);
        roomTypes = list.map((model) => Type.fromJson(model)).toList();
      });
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true, // container stick with top bar
      itemCount: roomTypes.length,
      itemBuilder: (BuildContext context, int index) {
        if (context != null) {
          return makeListTile(context, roomTypes[index]);
        }
        // return CircularProgressIndicator();
      },
    ));
  }
}

ListTile makeListTile(BuildContext context, Type room) {
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
      room.roomTypeName,
      // style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),
    // subtitle: Text("Meeting Room A", style: TextStyle(color: Colors.black38)),
    subtitle: Row(
      children: <Widget>[
        Icon(
          Icons.person,
          color: Colors.grey,
          size: 16,
        ),
        Text(
          room.roomTypeCapacity +
              ' | ฿' +
              room.roomTypePrice.toString() +
              '/hr',
        )
        // style: TextStyle(color: Colors.green))
      ],
    ),
    trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Available(),
        ),
      );
    },
  );
}
