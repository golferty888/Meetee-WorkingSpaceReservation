import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import 'package:meetee_mobile/components/fadeRoute.dart';
import 'package:meetee_mobile/pages/selectFacility.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final userNameController = TextEditingController();
  final passWordController = TextEditingController();
  final String logInUrl = 'http://18.139.12.132:9000/login';
  Map<String, String> headers = {"Content-type": "application/json"};

  Future<dynamic> logIn() async {
    String body = '{'
        '"username": ${userNameController.text}, '
        '"password": ${passWordController.text}'
        '}';
    print('body: ' + body);
    final response = await http.post(
      logInUrl,
      body: body,
      headers: headers,
    );
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print(response.body);
    }
  }

  @override
  void dispose() {
    userNameController.dispose();
    passWordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
//        width: MediaQuery.of(context).size.width,
        child: SafeArea(
          right: false,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 64.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: 24.0,
                      ),
                      Material(
                        color: Colors.transparent,
                        child: Hero(
                          tag: 'meeteeLogo',
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 160.0,
                                width: 160.0,
                                child: SvgPicture.asset(
                                  'images/meetee_logo.svg',
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: Text(
                                  'Meetee',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 32.0,
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Material(
                                color: Colors.transparent,
                                child: Text(
                                  'Just a coworking space.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

//                      Flexible(
//                        flex: 2,
//                        child: Container(),
//                      ),
//                      SvgPicture.asset(
//                        'images/facilityType/meeting.svg',
//                      ),
//                      Image.asset(
//                        'images/coworking.jpg',
//                      ),
//                      Flexible(
//                        flex: 1,
//                        child: Container(),
//                      ),
                      SizedBox(
                        height: 56,
                      ),
                      Text(
                        'Login',
                        style: TextStyle(
//                              color: Colors.black,
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          textCapitalization: TextCapitalization.none,
                          controller: userNameController,
                          style: TextStyle(
                            letterSpacing: 2.0,
                          ),
                          decoration: InputDecoration(
//                            border: OutlineInputBorder(),
                            hintText: 'username',
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          style: TextStyle(
                            letterSpacing: 2.0,
                          ),
                          obscureText: true,
                          controller: passWordController,
                          decoration: InputDecoration(
//                            border: OutlineInputBorder(),
                            hintText: 'password',
                            prefixIcon: Icon(Icons.lock),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        'Forgot password?',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(
                        height: 64.0,
                      ),
                      Container(
                        height: 48,
                        child: RaisedButton(
//                          color: Color(0xFFFAD74E),
                          color: Colors.black,
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(
//                              color: Colors.black,
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  logIn();
                                  return SelectFacilityType();
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: Container(),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Do not have an accout? ',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18.0,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    'Sign up',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 24.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
