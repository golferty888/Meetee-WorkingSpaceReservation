import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class ActivationPage extends StatefulWidget {
  @override
  _ActivationPageState createState() => _ActivationPageState();
}

String activateUrl = 'http://18.139.12.132:9000/activate';

class _ActivationPageState extends State<ActivationPage> {
  Future<dynamic> activateNow() async {
    final response = await http.post(
      activateUrl,
      body: {
        "username": "gulf",
      },
      headers: {
        HttpHeaders.authorizationHeader:
            "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJndWxmIiwiaWF0IjoxNTcxODI5MjE3MTAyfQ.CfVR45S-EiEHaT2wexRDc7DkJ2ZhdzAjtoR64TZeEvk",
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
//      final jsonData = (json.decode(response.body));
      setState(() {});
    } else {
      print('400');
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            color: Color(0xFFFAD74E),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  activateNow();
                },
                child: ClipOval(
                  child: Container(
                    width: 200,
                    height: 200,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: FloatingActionButton(
                elevation: 0.0,
//                backgroundColor: Color(
//                  widget.secondaryColor,
//                ).withOpacity(0.9),
                backgroundColor: Color(0xFFFAD74E),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
