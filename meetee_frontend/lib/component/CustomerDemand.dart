import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'dart:async';
import 'dart:convert'; // JSON
import 'package:flutter_calendar/flutter_calendar.dart';

import 'package:meetee_frontend/model/Room.dart';
import 'package:meetee_frontend/component/AvailableSeat.dart';

class CustomerDemand extends StatefulWidget {
  @override
  _CustomerDemandState createState() => _CustomerDemandState();
}

class _CustomerDemandState extends State<CustomerDemand> {
  String startDate;
  String roomTypeSelected;
  String user = 'Mister A';
  String room = 'room39';
  // List roomType = ['Room A', 'Room B', 'Room C'];
  List roomType = new List<Room>();

  Future<String> getRoomType() async {
    http.Response response = await http
        .get('https://us-central1-meetee-api.cloudfunctions.net/api/roomtypes');
    if (response.statusCode == 200) {
      print(jsonEncode(response.body));
      this.setState(() {
        List list = json.decode(response.body);
        roomType = list.map((model) => Room.fromJson(model)).toList();
      });
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState() {
    this.getRoomType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Customer Demand',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      backgroundColor: Colors.cyanAccent,
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Calendar(onDateSelected: (date) => handleNewDate(date)
                // isExpandable: true,
                ),
          ),
          roomTypeCard(context),
        ],
      ),
      bottomNavigationBar: RaisedButton(
        color: Colors.greenAccent,
        child: Text('Reserve !'),
        onPressed: () {
          onlineReserve(user, room, roomTypeSelected, startDate, startDate);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AvailableSeat(
                        roomType: '$roomType',
                      )));
        },
      ),
    );
  }

  void handleNewDate(DateTime date) {
    startDate = date.toString() + ' UTC+7';
    print(date);
  }

  Widget roomTypeCard(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(vertical: 16.0),
      itemBuilder: (BuildContext context, int index) {
        if (index % 2 == 0) {
          return makeRoomTypeCard(context, index ~/ 2);
        }
      },
    );
  }

  Widget makeRoomTypeCard(BuildContext context, int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 150.0,
          child: PageView.builder(
            itemCount: roomType.length,
            onPageChanged: (value) {
              print('name: ' +
                  roomType[value].roomTypeName); // สำหรับเลือก Card นี้
              print(roomType[value].roomPrice);
              print(roomType[value].roomCapacity);
              roomTypeSelected = roomType[value].roomTypeName;
            },
            controller: PageController(viewportFraction: 0.7),
            itemBuilder: (BuildContext context, int itemIndex) {
              return makeRoomTypeCardItem(context, index, itemIndex);
            },
          ),
        )
      ],
    );
  }

  Widget makeRoomTypeCardItem(BuildContext context, int index, int itemIndex) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Card(
        child: Container(
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // Icon(cardsList[position].icon, color: appColors[position],),
                    Icon(
                      Icons.more_vert,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Text(
                        roomType[itemIndex].roomCapacity.toString() +
                            ' Persons',
                        style: TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Text(
                        roomType[itemIndex].roomPrice.toString() + ' Baht/Hour',
                        style: TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Text(
                        roomType[itemIndex].roomTypeName,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: LinearProgressIndicator(value: cardsList[position].taskCompletion,),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<http.Response> onlineReserve(String user, String room, String roomType,
      String startDate, String endDate) async {
    var url =
        'https://us-central1-meetee-api.cloudfunctions.net/api/reservation';
    var body = jsonEncode({
      'user': user,
      'room': room,
      'roomType': roomType,
      'startDate': startDate,
      'endDate': endDate
    });

    print("Body: " + body);

    http
        .post(url, headers: {"Content-Type": "application/json"}, body: body)
        .then((http.Response response) {
      print(response.body);
    });
  }
}
