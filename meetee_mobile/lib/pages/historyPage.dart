import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:meetee_mobile/main.dart';
import 'package:meetee_mobile/model/history.dart';
import 'package:meetee_mobile/pages/activationPage.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final String historyUrl = 'http://18.139.12.132:9000/user/history';

  @override
  void initState() {
    getHistoryByUserId();
    super.initState();
  }

  List historiesList;
//  List historiesList;

  Future<dynamic> getHistoryByUserId() async {
    final response = await http.post(
      historyUrl,
      body: {
        "userId": '2',
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
//      final jsonData = (json.decode(response.body));
      setState(() {
//        historiesList = HistoriesList.fromJson(jsonData);
        historiesList = (json.decode(response.body));
      });

      print(historiesList[0]["catename"]);
    } else {
      print('400');
      throw Exception('Failed to load post');
    }
  }

  Widget _buildHistory(int index) {
    return Container(
      margin: EdgeInsets.only(
        top: 8.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey[300],
        ),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActivationPage(),
            ),
          );
        },
        child: ListTile(
          isThreeLine: true,
          leading: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 16.0,
            ),
            child: Text('${historiesList[index]["reservid"].toString()}'),
          ),
          title: Text('facId: ${historiesList[index]["faclist"]}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${historiesList[index]["date"]}'),
              Text('${historiesList[index]["period"]}'),
            ],
          ),
          trailing: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 16.0,
            ),
//          child: Text(
//            historiesList[index]["status"],
//            style: TextStyle(
//                color: historiesList[index]["status"] == 'Booked'
//                    ? Colors.green
//                    : Colors.red),
//          ),
            child: Text('฿${historiesList[index]["total_price"]}'),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.5,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
//            Navigator.push(
//              context,
//              MaterialPageRoute(
//                builder: (context) => MyHomePage(),
//              ),
//            );
          },
        ),
        title: Text(
          'History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22.0,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
//          color: Color(widget.colorCode),
          color: Colors.white,
        ),
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: historiesList == null ? 0 : historiesList.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildHistory(index);
              },
            ),
          ),
        ),
      ),
    );
  }
}
