import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert'; // JSON

import 'package:meetee_frontend/model/Person.dart';

class AvailableSeat extends StatefulWidget {
  final String roomType;
  final String date;
  final String status;

  AvailableSeat({Key key, this.roomType, this.date, this.status})
      : super(key: key);

  @override
  _AvailableSeatState createState() => _AvailableSeatState();
}

class _AvailableSeatState extends State<AvailableSeat> {
  var persons = new List<Person>(); // from person.dart

  Future<String> getAvailableRoom() async {
    http.Response response =
        await http.get('https://jsonplaceholder.typicode.com/users');
    if (response.statusCode == 200) {
      print(jsonEncode(response.body));
      this.setState(() {
        List list = json.decode(response.body);
        persons = list.map((model) => Person.fromJson(model)).toList();
      });
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState() {
    this.getAvailableRoom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true, // container stick with top bar
      itemCount: persons.length,
      itemBuilder: (BuildContext context, int index) {
        if (context != null) {
          return makeCard(persons[index]);
        }
        // return CircularProgressIndicator();
      },
    ));
  }
}

Card makeCard(Person person) => Card(
      elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(),
        child: makeListTile(person),
      ),
    );

ListTile makeListTile(Person person) {
  return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: BoxDecoration(
            border: Border(
                right: new BorderSide(width: 1.0, color: Colors.black87))),
        child: Icon(
          IconData(58935, fontFamily: 'MaterialIcons'),
          size: 40.0,
        ),
      ),
      title: Text(
        person.name,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      // subtitle: Text("Meeting Room A", style: TextStyle(color: Colors.black38)),
      subtitle: Row(
        children: <Widget>[
          Icon(Icons.linear_scale, color: Colors.green),
          Text(person.email, style: TextStyle(color: Colors.green))
        ],
      ),
      trailing:
          Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0));
}
