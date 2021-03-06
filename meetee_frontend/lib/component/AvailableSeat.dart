import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meetee_frontend/component/SummaryDetail.dart';
import 'dart:async';
import 'dart:convert'; // JSON

import 'package:meetee_frontend/model/Room.dart';
import 'package:meetee_frontend/model/Reservation.dart';

String urlAvail = 'http://18.139.12.132:9000/check/available';
String urlReserve = 'http://18.139.12.132:9000/reserve';

class Available extends StatefulWidget {
  final Reservation reservation;
  final String type;
  final int price;
  final String picUrl;

  Available(this.reservation, this.type, this.price, this.picUrl);

  @override
  _AvailableState createState() => _AvailableState();
}

class _AvailableState extends State<Available> {
  List rooms = new List<Room>();
  // final body = {
  //   'type': '4',
  //   'startDate': 'April 5, 2019',
  //   'startTime': '10:00:00',
  //   'endTime': '12:00:00'
  // };
  //  final body = {
  //   'type': '4',
  //   'startDate': DateTime.now().toString(),
  //   'startTime': TimeOfDay.now().toString(),
  //   'endTime': TimeOfDay.now().toString()
  // };
  // final body = {
  //   "type": "3",
  //   "startDate": "April 14, 2019",
  //   "startTime": "15:00:00",
  //   "endTime": "17:00:00"
  // };
  Future<String> getAvailable() async {
    final body = widget.reservation.toMap();
    print('post avail body: $body');
    http.Response response = await http.post(urlAvail, body: body);
    if (response.statusCode == 200) {
      print('get available seat success');
      print(response.body);
      this.setState(() {
        List list = json.decode(response.body)["availableList"];
        rooms = list.map((model) => Room.fromJson(model)).toList();
      });
    } else {
      print('fail to get available seat');
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
    // getAvailable();
    return Container(
        child: ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true, // container stick with top bar
      itemCount: rooms.length,
      itemBuilder: (BuildContext context, int index) {
        if (context != null) {
          return makeListTile(rooms[index], widget.price, widget.picUrl,
              widget.reservation, context);
        }
        return CircularProgressIndicator();
      },
    ));
  }

  // Future<Null> reserve(Room room) async {
  //   final body = {
  //     'userId': '1',
  //     'roomId': room.roomId.toString(),
  //     'startDate': (widget.reservation.toMap())['startDate'],
  //     'endDate': (widget.reservation.toMap())['startDate'],
  //     'startTime': (widget.reservation.toMap())['startTime'],
  //     'endTime': (widget.reservation.toMap())['endTime'],
  //   };
  //   print(body);
  //   // http.Response response = await http.post(urlReserve, body: body);
  //   // if (response.statusCode == 200) {
  //   //   print('reserve success');
  //   //   print(jsonEncode(response.body));
  //   //   // this.setState(() {
  //   //   //   List list = json.decode(response.body);
  //   //   //   rooms = list.map((model) => Room.fromJson(model)).toList();
  //   //   // });
  //   // } else {
  //   //   print('reserve fail');
  //   //   throw Exception('Failed to load post');
  //   // }
  // }
}

InkWell makeListTile(Room room, int price, String urlPic,
    Reservation reservation, BuildContext context) {
  // return ListTile(
  //   contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  //   leading: Container(
  //       child: Icon(
  //     IconData(58418, fontFamily: 'MaterialIcons'),
  //     size: 60.0,
  //   )),
  //   title: Text(
  //     room.roomName,
  //   ),
  //   trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0),
  //   onTap: () => reserve(room),
  // );
  return InkWell(
    onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SummaryDetail(room, price, urlPic, reservation))),
    // onTap: () {
    //   Navigator.of(context).push(SummaryPageRoute(room));
    // },
    child: Container(
      /// Give nice padding
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Hero(
              tag: "picture_" + room.roomId.toString(),
              // child: Icon(
              //   IconData(58418, fontFamily: 'MaterialIcons'),
              //   size: 60.0,
              // )),
              child: Container(
                width: 100,
                child: Image.network(urlPic),
              )
              ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(room.roomName),
          )
        ],
      ),
    ),
  );
}

// class SummaryPageRoute extends MaterialPageRoute {
//   SummaryPageRoute(room)
//       : super(
//             builder: (context) => SummaryDetail(
//                   room,
//                 ));

//   @override
//   Widget buildTransitions(BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation, Widget child) {
//     return FadeTransition(opacity: animation, child: child);
//   }
// }
