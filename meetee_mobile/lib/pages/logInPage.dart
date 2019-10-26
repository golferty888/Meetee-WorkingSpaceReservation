import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:meetee_mobile/pages/signUpPage.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;

import 'package:meetee_mobile/components/colorLoader.dart';
import 'package:meetee_mobile/components/fadeRoute.dart';
import 'package:meetee_mobile/pages/selectFacility.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage>
    with SingleTickerProviderStateMixin {
  final userNameController = TextEditingController();
  final passWordController = TextEditingController();
  final String logInUrl = 'http://18.139.12.132:9000/login';
  Map<String, String> headers = {"Content-type": "application/json"};

  Future<dynamic> logIn() async {
    setState(() {
      _isLoading = true;
    });
    String body = '{'
        '"username": "${userNameController.text}", '
        '"password": "${passWordController.text}"'
        '}';
    print('body: ' + body);
    final response = await http.post(
      logInUrl,
      body: body,
      headers: headers,
    );
    if (response.statusCode == 200) {
      print(response.body);
      Future.delayed(
        Duration(milliseconds: 1500),
        () {
          setState(
            () {
              _isLogInFailed = false;
              _isLoading = false;
            },
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return SelectFacilityType();
              },
            ),
          );
        },
      );
    } else {
      print(response.body);
      Future.delayed(
        Duration(milliseconds: 1000),
        () {
          setState(
            () {
              _isLogInFailed = true;
              _isLoading = false;
              if (_isLogInFailed) {
                animationController.forward(from: 0.0);
              }
            },
          );
        },
      );
    }
  }

  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    _isLogInFailed = false;

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
//      ..addListener(() => setState(() {}));

    animation = Tween<double>(
      begin: 50.0,
      end: 120.0,
    ).animate(animationController);

    super.initState();
  }

  vector_math.Vector3 _shake() {
    double progress = animationController.value;
    double offset = sin(progress * pi * 10.0);
    return vector_math.Vector3(offset * 4, 0.0, 0.0);
  }

  @override
  void dispose() {
    userNameController.dispose();
    passWordController.dispose();
    animationController.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  bool _isLogInFailed = false;

  final FocusNode _userNameFocus = FocusNode();
  final FocusNode _passWordFocus = FocusNode();

  _textFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Container(
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
                        SizedBox(
                          height: 56,
                        ),
                        _isLogInFailed
                            ? AnimatedBuilder(
                                animation: animationController,
                                builder: (_, child) {
                                  return Transform(
                                    transform: Matrix4.translation(
                                      _shake(),
                                    ),
                                    child: Text(
                                      'Login failed, try again',
                                      style: TextStyle(
//                              color: Colors.black,
                                        color: Colors.red,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.normal,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Text(
                                'Login',
                                style: TextStyle(
//                              color: Colors.black,
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.normal,
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
                            textInputAction: TextInputAction.next,
                            focusNode: _userNameFocus,
                            cursorColor: Colors.black,
                            autocorrect: false,
                            onSubmitted: (term) {
                              _textFocusChange(
                                  context, _userNameFocus, _passWordFocus);
                            },
                            style: TextStyle(
                              letterSpacing: 2.0,
                            ),
                            decoration: InputDecoration(
//                            border: OutlineInputBorder(),
                              hintText: 'username',
                              prefixIcon: Icon(
                                Icons.person,
                              ),
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
                            textInputAction: TextInputAction.done,
                            focusNode: _passWordFocus,
                            onSubmitted: (term) {
                              logIn();
                              Future.delayed(
                                Duration(milliseconds: 2000),
                                () {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                },
                              );
                            },
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
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return SelectFacilityType();
                                },
                              ),
                            );
                          },
                          child: Text(
                            'Forgot password?',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
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

                            child: _isLoading
                                ? Padding(
                                    padding: EdgeInsets.only(top: 6),
                                    child: ColorLoader4(
                                      dotOneColor: Colors.yellow[700],
                                      dotTwoColor: Colors.pink[400],
                                      dotThreeColor: Colors.blue[400],
                                      duration: Duration(milliseconds: 1000),
                                    ))
                                : Text(
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
                              logIn();
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SignUpPage();
                            },
                          ),
                        );
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
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
      ),
    );
  }
}
