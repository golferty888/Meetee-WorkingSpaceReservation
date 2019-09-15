import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:meetee_frontend/model/History.dart';

class history extends StatefulWidget {
  @override
  _historyState createState() => _historyState();
}

class _historyState extends State<history> {
  List historyLists = new List<History>();
  String id = '1';
  String urlHistory = 'http://18.139.12.132:9000/user/history';

  Future<Null> getHistory() async {
    final body = {'userId': id};
    print('post avail body: $body');
    http.Response response = await http.post(urlHistory, body: body);
    if (response.statusCode == 200) {
      print('get history success');
      print(response.body);
      this.setState(() {
        List list = json.decode(response.body)["results"];
        historyLists = list.map((model) => History.fromJson(model)).toList();
      });
    } else {
      print('fail to get available seat');
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState() {
    this.getHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: Container(
          child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true, // container stick with top bar
        itemCount: historyLists.length,
        itemBuilder: (BuildContext context, int index) {
          if (context != null) {
            return ListTile(
              // contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              // leading: Container(
              //     // padding: EdgeInsets.only(right: 12.0), // ข้างรูปซ้าย
              //     // decoration: BoxDecoration(
              //     //     border: Border(
              //     //         right: new BorderSide(width: 1.0, color: Colors.black87))),
              //     child: Icon(
              //   IconData(58418, fontFamily: 'MaterialIcons'),
              //   size: 60.0,
              //   //     Image.network(
              //   //   room.roomTypePic,
              // )),
              // leading: Container(
              //   child: Image.network(roomTypes[index].roomTypePic),
              // ),
              title: Text(historyLists[index].room_id.toString()
                  // style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
              // subtitle: Text("Meeting Room A", style: TextStyle(color: Colors.black38)),
              subtitle: Column(
                children: <Widget>[
                  Text(
                    historyLists[index].start_date +
                        ' - ' +
                    historyLists[index].end_date,
                  ),
                  Text(
                    historyLists[index].start_time +
                        ' - ' +
                    historyLists[index].end_time,
                  )
                ],
              ),
              // trailing: Icon(Icons.keyboard_arrow_right,
              //     color: Colors.black, size: 30.0),
            );
          }
          return CircularProgressIndicator();
        },
      )),
    );
  }
}
