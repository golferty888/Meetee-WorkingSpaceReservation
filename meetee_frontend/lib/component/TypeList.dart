import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meetee_frontend/blocs/bloc_provider.dart';
import 'package:meetee_frontend/blocs/bloc_reservation.dart';
import 'package:meetee_frontend/model/Reservation.dart';
import 'dart:async';
import 'dart:convert'; // JSON

import 'package:meetee_frontend/model/Type.dart';
import 'package:meetee_frontend/component/AvailableSeat.dart';

class SeatType extends StatefulWidget {
  final String type;

  SeatType({this.type, Key key}) : super(key: key);

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

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> getSeatType(String type) async {
    String url = 'http://localhost:9500/type/' + type;
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      print('Get $type type:  ' + jsonEncode(response.body));
      this.setState(() {
        if (response.body != null) {
          List list = json.decode(response.body);
          roomTypes = list.map((model) => Type.fromJson(model)).toList();
        } else {
          print('$type type NULL body');
        }
      });
    } else {
      print('Fail to load $type type');
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    final BlocReservation dateReserveBloc =
        BlocProvider.of<BlocReservation>(context);

    return Container(
        // child: StreamBuilder<Reservation>(
        //     stream: dateReserveBloc.dateStreamController.stream,
        //     initialData: Reservation(
        //         '2', DateTime.now(), TimeOfDay.now(), TimeOfDay.now()),
        //     builder: (context, snapshot) {
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true, // container stick with top bar
            itemCount: roomTypes.length,
            itemBuilder: (BuildContext context, int index) {
              if (context != null) {
                return StreamBuilder<Reservation>(
                    stream: dateReserveBloc.dateStreamController.stream,
                    initialData: Reservation(
                        roomTypes[index].roomTypeId.toString(),
                        DateTime.now(),
                        TimeOfDay.now(),
                        TimeOfDay.now()),
                    builder: (context, snapshot) {
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
                          roomTypes[index].roomTypeName +
                              // snapshot.data.type.toString(),
                              roomTypes[index].roomTypeId.toString(),
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
                              roomTypes[index].roomTypeCapacity +
                                  ' | ฿' +
                                  roomTypes[index].roomTypePrice.toString() +
                                  '/hr',
                            )
                          ],
                        ),
                        trailing: Icon(Icons.keyboard_arrow_right,
                            color: Colors.black, size: 30.0),
                        onTap: () {
                          print('roomtype ' +
                              roomTypes[index].roomTypeId.toString());
                          dateReserveBloc.reserveType(
                              roomTypes[index].roomTypeId.toString());
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Available(snapshot.data),
                            ),
                          );
                        },
                      );
                    });
              }
            }));
    // return CircularProgressIndicator()       // }));
  }
}

// ListTile makeListTile(
//     BuildContext context, Type room, DateTime dateStart, BlocReservation dateReserveBloc) {
//   return ListTile(
//     // contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//     leading: Container(
//         // padding: EdgeInsets.only(right: 12.0), // ข้างรูปซ้าย
//         // decoration: BoxDecoration(
//         //     border: Border(
//         //         right: new BorderSide(width: 1.0, color: Colors.black87))),
//         child: Icon(
//       IconData(58418, fontFamily: 'MaterialIcons'),
//       size: 60.0,
//       //     Image.network(
//       //   room.roomTypePic,
//     )),
//     title: Text(
//       room.roomTypeName + room.roomTypeId.toString(),
//       // style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//     ),
//     // subtitle: Text("Meeting Room A", style: TextStyle(color: Colors.black38)),
//     subtitle: Row(
//       children: <Widget>[
//         Icon(
//           Icons.person,
//           color: Colors.grey,
//           size: 16,
//         ),
//         // Text(
//         //   room.roomTypeCapacity +
//         //       ' | ฿' +
//         //       room.roomTypePrice.toString() +
//         //       '/hr',
//         // )
//         Flexible(
//           child: StreamBuilder<int>(
//               stream: dateReserveBloc.dateStreamController.stream,
//               initialData: 0,
//               builder: (context, snapshot) {
//                 // return Text(DateFormat('yyyy-MM-dd').format(dateStart).toString());
//                 // Text(DateFormat('yyyy-MM-dd').format(snapshot.data).toString());
//                 Text('success');
//               }),
//         )
//         // style: TextStyle(color: Colors.green))
//       ],
//     ),
//     trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0),
//     onTap: () {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => Available(
//                 dateStart: dateStart,
//               ),
//         ),
//       );
//     },
//   );
// }
