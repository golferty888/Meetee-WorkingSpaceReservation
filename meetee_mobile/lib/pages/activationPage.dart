import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:meetee_mobile/config.dart';
import 'package:meetee_mobile/main.dart';

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
        "userId": '3',
      },
      headers: {HttpHeaders.authorizationHeader: fakeToken},
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
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.network(
              'https://storage.googleapis.com/meetee-file-storage/img/fac/bar-chair.jpg',
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 5.0,
              ),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          Center(
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
                onPressed: () {
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                      builder: (context) => MyHomePage(),
//                    ),
//                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
