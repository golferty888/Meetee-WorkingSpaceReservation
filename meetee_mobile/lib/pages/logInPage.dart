import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:vector_math/vector_math_64.dart' as vector_math;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:meetee_mobile/components/colorLoader.dart';
import 'package:meetee_mobile/pages/homePage.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage>
    with SingleTickerProviderStateMixin {
  final userNameController = TextEditingController();
  final passWordController = TextEditingController();
  final userNameSignUpController = TextEditingController();
  final passWordSignUpController = TextEditingController();

  final String logInUrl = 'http://18.139.12.132:9000/login';
  final String signUpUrl = 'http://18.139.12.132:9000/signup';
  Map<String, String> headers = {"Content-type": "application/json"};

  AnimationController animationController;
  Animation<double> animation;

  PageController pageViewController;

  @override
  void initState() {
    _loadUser();

    _isLogInFailed = false;

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    animation = Tween<double>(
      begin: 50.0,
      end: 120.0,
    ).animate(animationController);

    pageViewController = PageController();

    super.initState();
  }

  String _userName;

  _navigateToHomePage() {
    print(_userName);
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return HomePage(
            userName: _userName,
          );
        },
      ),
    );
  }

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('pref: ${prefs.getString('userName')} '
        '${prefs.getString('passWord')}');
    setState(() {
      _userName = prefs.getString('userName');
    });
    if (prefs.getString('userName') != null &&
        prefs.getString('passWord') != null) {
      pageViewController.jumpToPage(2);
      autoLogIn(prefs);
    }
  }

  Future<dynamic> autoLogIn(SharedPreferences prefs) async {
    String body = '{'
        '"username": "${prefs.getString('userName')}", '
        '"password": "${prefs.getString('passWord')}"'
        '}';
    print('body: ' + body);
    final response = await http.post(
      logInUrl,
      body: body,
      headers: headers,
    );
    Future.delayed(
      Duration(milliseconds: 3000),
      () {
        if (response.statusCode == 200) {
          print('auto login success ${response.body}');
          setState(
            () {
              _promptLoadingText = 'Logging in ...';
            },
          );
          Future.delayed(
            Duration(milliseconds: 3000),
            () {
              _navigateToHomePage();
            },
          );
        } else {
          print('failed');
        }
      },
    );
  }

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
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userName', userNameController.text);
      prefs.setString('passWord', passWordController.text);
      setState(() {
        _userName = userNameController.text;
      });
      Future.delayed(
        Duration(milliseconds: 1500),
        () {
          _navigateToHomePage();
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

  Future<dynamic> signUp() async {
    setState(() {
      _isLoading = true;
    });
    String body = '{'
        '"username": "${userNameSignUpController.text}", '
        '"password": "${passWordSignUpController.text}"'
        '}';
    print('body: ' + body);
    final response = await http.post(
      signUpUrl,
      body: body,
      headers: headers,
    );
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        _userName = userNameSignUpController.text;
      });
      Future.delayed(
        Duration(milliseconds: 1500),
        () {
          setState(
            () {
              _isLoading = false;
            },
          );
          _navigateToHomePage();
        },
      );
    } else {
      print(response.body);
      String responseMessage = json.decode(response.body)["message"];
      Future.delayed(
        Duration(milliseconds: 1000),
        () {
          setState(
            () {
              _isLoading = false;
            },
          );
          if (responseMessage == "That username is taken. Try another.") {
            _errorUserNameMessage = 'Username is already taken.';
          }
        },
      );
    }
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
    userNameSignUpController.dispose();
    passWordSignUpController.dispose();

    animationController.dispose();

    pageViewController.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  bool _isLogInFailed = false;
  bool _isLogInView = true;

  final FocusNode _userNameFocus = FocusNode();
  final FocusNode _passWordFocus = FocusNode();
  final FocusNode _userNameSignUpFocus = FocusNode();
  final FocusNode _passWordSignUpFocus = FocusNode();
  final FocusNode _rePassWordSignUpFocus = FocusNode();

  _textFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');
  String _errorUserNameMessage;
  String _errorPassWordMessage;
  bool _isMasked = true;

  checkUserNameField() {
    if (userNameSignUpController.text.length > 0) {
      if (userNameSignUpController.text.length < 4) {
        if (!validCharacters.hasMatch(userNameSignUpController.text)) {
          setState(() {
            _errorUserNameMessage = 'Special character is not allowed.';
          });
        } else {
          setState(() {
            _errorUserNameMessage =
                'Username must contains 4 or more characters.';
          });
        }
      } else if (!validCharacters.hasMatch(userNameSignUpController.text)) {
        setState(() {
          _errorUserNameMessage = 'Special character is not allowed.';
        });
      } else {
        setState(() {
          _errorUserNameMessage = null;
        });
      }
    } else {
      setState(() {
        _errorUserNameMessage = 'Username must contains 4 or more characters.';
      });
    }
  }

  checkPassWordField() {
    if (passWordSignUpController.text.length < 4) {
      setState(() {
        _errorPassWordMessage = 'Password must contains 4 or more characters.';
      });
    } else {
      setState(() {
        _errorPassWordMessage = null;
      });
    }
  }

  Container _buildLoginView() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 64.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
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
                _textFocusChange(context, _userNameFocus, _passWordFocus);
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
              _navigateToHomePage();
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
                      ),
                    )
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
        ],
      ),
    );
  }

  Container _buildSignUpView() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 64.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Create an account',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.normal,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            height: 116,
//            color: Colors.green,
            padding: EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 0.0),
            child: TextField(
              textCapitalization: TextCapitalization.none,
              controller: userNameSignUpController,
              textInputAction: TextInputAction.next,
              focusNode: _userNameSignUpFocus,
              cursorColor: Colors.black,
              autocorrect: false,
              onSubmitted: (term) {
                _textFocusChange(
                    context, _userNameSignUpFocus, _passWordSignUpFocus);
              },
              onChanged: (input) {
                checkUserNameField();
              },
              style: TextStyle(
                letterSpacing: 2.0,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'username',
                errorText: _errorUserNameMessage,
                prefixIcon: Icon(
                  Icons.person,
                ),
              ),
            ),
          ),
          Container(
            child: TextField(
              style: TextStyle(
                letterSpacing: 2.0,
              ),
              controller: passWordSignUpController,
              focusNode: _passWordSignUpFocus,
              textInputAction: TextInputAction.done,
              obscureText: _isMasked ? true : false,
              autocorrect: false,
              onChanged: (input) {
                checkPassWordField();
              },
//              onSubmitted: (term) {
//                _textFocusChange(
//                    context, _passWordSignUpFocus, _rePassWordSignUpFocus);
//              },
              onSubmitted: (term) {
                checkUserNameField();
                checkPassWordField();
                signUp();
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'password',
                errorText: _errorPassWordMessage,
                prefixIcon: Icon(Icons.lock),
                suffixIcon: _isMasked
                    ? IconButton(
                        icon: Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _isMasked = false;
                          });
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isMasked = true;
                          });
                        },
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 52.0,
          ),
          Container(
            height: 48,
            child: RaisedButton(
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
                      'Sign up',
                      style: TextStyle(
//                              color: Colors.black,
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
              onPressed: () {
                checkUserNameField();
                checkPassWordField();
                signUp();
              },
            ),
          ),
        ],
      ),
    );
  }

  String _promptLoadingText = 'Loading data ...';

  Container _buildLoadView() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ColorLoader4(
            dotOneColor: Colors.yellow[700],
            dotTwoColor: Colors.pink[400],
            dotThreeColor: Colors.blue[400],
            duration: Duration(milliseconds: 1000),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: Text(
              '$_promptLoadingText',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black54,
                letterSpacing: 1.0,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
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
                    child: Column(
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
                        Expanded(
                          child: PageView(
                            controller: pageViewController,
                            physics: NeverScrollableScrollPhysics(),
                            children: <Widget>[
                              _buildLoginView(),
                              _buildSignUpView(),
                              _buildLoadView(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _isLogInView
                      ? Row(
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
                                pageViewController.animateToPage(
                                  1,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.ease,
                                );
                                setState(() {
                                  _isLogInView = false;
                                });
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
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Already have an accout? ',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18.0,
                                fontWeight: FontWeight.normal,
                                letterSpacing: 1.5,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                pageViewController.animateToPage(
                                  0,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.ease,
                                );
                                setState(() {
                                  _isLogInView = true;
                                  userNameSignUpController.clear();
                                  passWordSignUpController.clear();
                                  _errorUserNameMessage = null;
                                  _errorPassWordMessage = null;
                                });
                              },
                              child: Text(
                                'Login',
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
      ),
    );
  }
}
