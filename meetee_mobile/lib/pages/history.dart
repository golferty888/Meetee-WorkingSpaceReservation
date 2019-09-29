import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:meetee_mobile/main.dart';

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

  Future<dynamic> getHistoryByUserId() async {
    final response = await http.post(
      historyUrl,
      body: {
        "userId": '1',
      },
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(jsonData);
    } else {
      throw Exception('Failed to load post');
    }
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage(),
              ),
            );
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
        child: SafeArea(
          child: Column(
            children: <Widget>[],
          ),
        ),
      ),
    );
  }
}
