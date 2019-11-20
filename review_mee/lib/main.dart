import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:review_mee/commentPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Review_mee',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, String> headers = {"Content-type": "application/json"};
  String _badComment = '';

  Future postReviewScore(int score, String comment) async {
    String body = '{'
        '"score": $score, '
        '"comment": "$comment"'
        '}';
    final response = await http.post(
      'http://34.87.101.81:9010/score',
      body: body,
      headers: headers,
    );
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      print('yay');
    } else {
      print('ereer');
    }
  }

  _buildStar(Color color, String text, int score, String comment) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          print(score);
          postReviewScore(score, comment);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Icon(
                Icons.stars,
                color: color,
                size: 200,
              ),
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 60),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            GestureDetector(
              onTap: () async {
//                print(score);
//                postReviewScore(score, comment);
                _badComment = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return CommentPage();
                    },
                  ),
                );
                print(_badComment);
                postReviewScore(2, _badComment);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Icon(
                      Icons.stars,
                      color: Colors.orange,
                      size: 200,
                    ),
                  ),
                  Text(
                    'Not satisfied',
                    style: TextStyle(
                      fontSize: 32,
                    ),
                  ),
                ],
              ),
            ),
            _buildStar(Colors.lime, 'Meh', 2, 'Meh'),
            _buildStar(Colors.lightGreen, 'Good', 3, 'Good'),
            _buildStar(Colors.green[700], 'Exellent', 4, 'Exellent'),
          ],
        ),
      ),
    );
  }
}
