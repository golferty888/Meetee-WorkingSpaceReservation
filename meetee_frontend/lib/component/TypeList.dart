import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert'; // JSON

import 'package:meetee_frontend/model/Type.dart';
import 'package:meetee_frontend/component/AvailableSeat.dart';

class SeatType extends StatefulWidget {
  final String type;
  final DateTime dateStart;

  SeatType({this.type, this.dateStart});

  @override
  _SeatTypeState createState() => _SeatTypeState(type, dateStart);
}

class _SeatTypeState extends State<SeatType> {
  String type;
  DateTime dateStart;
  _SeatTypeState(this.type, this.dateStart);

  List roomTypes = new List<Type>();

  @override
  void initState() {
    this.getSeatType(this.type);
    super.initState();
  }

  Future<String> getSeatType(String type) async {
    // print('get' + dateStart.toString());
    String url = 'http://localhost:9500/type/' + type;
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      print('success ' + jsonEncode(response.body));
      this.setState(() {
        List list = json.decode(response.body);
        roomTypes = list.map((model) => Type.fromJson(model)).toList();
      });
    } else {
      print('fail to load type');
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
          // print(dateStart);
          return makeListTile(context, roomTypes[index], dateStart);
        }
        // return CircularProgressIndicator();
      },
    ));
  }
}

ListTile makeListTile(BuildContext context, Type room, DateTime dateStart) {
  // print('ml: ' + dateStart.toString());
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
      room.roomTypeName + room.roomTypeId.toString(),
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
        // Text(
        //   room.roomTypeCapacity +
        //       ' | ฿' +
        //       room.roomTypePrice.toString() +
        //       '/hr',
        // )
        Text(DateFormat('yyyy-MM-dd').format(dateStart).toString())
        // style: TextStyle(color: Colors.green))
      ],
    ),
    trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Available(
                dateStart: dateStart,
              ),
        ),
      );
    },
  );
}
