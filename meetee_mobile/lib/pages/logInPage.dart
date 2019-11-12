import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:meetee_mobile/components/css.dart';
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
  final String countDownUrl = 'http://18.139.12.132:9000/activate/initial';
  Map<String, String> headers = {"Content-type": "application/json"};

  AnimationController animationController;
  Animation<double> animation;

  PageController pageViewController;

  bool isLargeScreen = false;

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
  int _userId;

  _navigateToHomePage() {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return HomePage(
            userName: _userName,
            upComingBookingJson: _upComingBookingJson,
            userId: _userId,
          );
        },
      ),
    );
  }

  var _upComingBookingJson;

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
    final response = await http.post(
      logInUrl,
      body: body,
      headers: headers,
    );
    Future.delayed(
      Duration(milliseconds: 1000),
      () {
        if (response.statusCode == 200) {
          print('auto login success ${response.body}');
          Map jsonData = json.decode(response.body);
          setState(
            () {
              _userId = jsonData["userId"];
              _promptLoadingText = 'Logging in ...';
            },
          );
          print(_userId);
          countDownToUnlock();
          Future.delayed(
            Duration(milliseconds: 1000),
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
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userName', userNameController.text);
      prefs.setString('passWord', passWordController.text);
      var jsonData = json.decode(response.body);
      setState(() {
        _userId = jsonData["userId"];
        _userName = userNameController.text;
      });
      countDownToUnlock();
      Future.delayed(
        Duration(milliseconds: 1500),
        () {
          _navigateToHomePage();
        },
      );
    } else {
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

  bool _isSignUpView = false;

  Future<dynamic> signUp() async {
    setState(() {
      _isLoading = true;
    });
    String body = '{'
        '"username": "${userNameSignUpController.text}", '
        '"password": "${passWordSignUpController.text}"'
        '}';
    final response = await http.post(
      signUpUrl,
      body: body,
      headers: headers,
    );
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        _userId = jsonData["userId"];
        _userName = userNameSignUpController.text;
      });
      countDownToUnlock();
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

//  DateTime _startTime;

  Future countDownToUnlock() async {
    String body = '{'
        '"userId": $_userId'
        '}';
    final response = await http.post(
      countDownUrl,
      body: body,
      headers: headers,
    );
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      setState(() {
        _upComingBookingJson = json.decode(response.body);
      });
    } else {
      print('ereer');
    }
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

  _buildLoginView() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: isLargeScreen
                ? MediaQuery.of(context).viewInsets.bottom > 0
                    ? MediaQuery.of(context).size.height / 1.62 -
                        MediaQuery.of(context).viewInsets.bottom
                    : MediaQuery.of(context).size.height / 3
                : MediaQuery.of(context).viewInsets.bottom > 0
                    ? MediaQuery.of(context).size.height / 1.92 -
                        MediaQuery.of(context).viewInsets.bottom
                    : MediaQuery.of(context).size.height / 3,
            child: Container(),
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
                          fontSize:
                              isLargeScreen ? fontSizeH2[0] : fontSizeH2[1],
                          fontWeight: FontWeight.normal,
                          letterSpacing: 1.0,
                        ),
                      ),
                    );
                  },
                )
              : Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: isLargeScreen ? fontSizeH2[0] : fontSizeH2[1],
                    fontWeight: FontWeight.normal,
                    letterSpacing: 1.0,
                  ),
                ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 80,
          ),
          Padding(
//            padding: EdgeInsets.symmetric(horizontal: 8.0),
            padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
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
                letterSpacing: 0.5,
              ),
              decoration: InputDecoration(
                labelText: 'username',
                alignLabelWithHint: true,
                contentPadding: EdgeInsets.all(0.0),
                prefixIcon: Icon(
                  Icons.person,
                ),
              ),
            ),
          ),
          Padding(
//            padding: EdgeInsets.symmetric(horizontal: 8.0),
            padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 0.0),
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
                contentPadding: EdgeInsets.all(0.0),
                labelText: 'password',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.lock),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 40,
          ),
          GestureDetector(
            onTap: () {
//              setState(() {
//                _userName = 'Guest';
//                _userId = 100;
//              });
//              countDownToUnlock();
//              _navigateToHomePage();
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
            height: MediaQuery.of(context).size.height / 40,
          ),
          Container(
            height: 48,
            child: RaisedButton(
//                          color: Color(0xFFFAD74E),
              color: Theme.of(context).primaryColor,
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
                      'Login'.toUpperCase(),
                      style: TextStyle(
//                              color: Colors.black,
                        color: Colors.white,
                        fontSize: isLargeScreen
                            ? fontSizeButton[0]
                            : fontSizeButton[1],
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
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: isLargeScreen
                ? MediaQuery.of(context).viewInsets.bottom > 0
                    ? MediaQuery.of(context).size.height / 1.60 -
                        MediaQuery.of(context).viewInsets.bottom
                    : MediaQuery.of(context).size.height / 3
                : MediaQuery.of(context).viewInsets.bottom > 0
                    ? MediaQuery.of(context).size.height / 1.95 -
                        MediaQuery.of(context).viewInsets.bottom
                    : MediaQuery.of(context).size.height / 3,
            child: Container(),
          ),
          Text(
            'Create an account',
            style: TextStyle(
              color: Colors.black,
              fontSize: isLargeScreen ? fontSizeH2[0] : fontSizeH2[1],
              fontWeight: FontWeight.normal,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            height: 88,
//            color: Colors.green,
            padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
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
                contentPadding: EdgeInsets.all(0.0),
                border: OutlineInputBorder(),
                labelText: 'username',
                alignLabelWithHint: true,
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
                contentPadding: EdgeInsets.all(0.0),
                border: OutlineInputBorder(),
                labelText: 'password',
                alignLabelWithHint: true,
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
            height: 32.0,
          ),
          Container(
            height: 48,
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
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
                      'Sign up'.toUpperCase(),
                      style: TextStyle(
//                              color: Colors.black,
                        color: Colors.white,
                        fontSize: isLargeScreen
                            ? fontSizeButton[0]
                            : fontSizeButton[1],
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
          SizedBox(
            height: MediaQuery.of(context).size.height / 8,
          ),
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
    if (MediaQuery.of(context).size.height > 700) {
      print('large');
      setState(() {
        isLargeScreen = true;
      });
    } else {
      print('small');
      setState(() {
        isLargeScreen = false;
      });
    }
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: SafeArea(
                  right: false,
                  child: Stack(
                    children: <Widget>[
                      PageView(
                        controller: pageViewController,
                        physics: NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          _buildLoginView(),
                          _buildSignUpView(),
                          _buildLoadView(),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 24,
                                ),
                                Material(
                                  color: Colors.transparent,
                                  child: Hero(
                                    tag: 'meeteeLogo',
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          height: MediaQuery.of(context)
                                                          .viewInsets
                                                          .bottom >
                                                      0 &&
                                                  !isLargeScreen
                                              ? 0
                                              : MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  8,
//                                  width: 160.0,
                                          child: SvgPicture.asset(
                                            'images/logo.svg',
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8.0,
                                        ),
                                        MediaQuery.of(context)
                                                        .viewInsets
                                                        .bottom >
                                                    0 &&
                                                !isLargeScreen
                                            ? Container()
                                            : Material(
                                                color: Colors.transparent,
                                                child: Text(
                                                  'Meetee',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: isLargeScreen
                                                        ? fontSizeH1[0]
                                                        : fontSizeH1[1],
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    letterSpacing: 2.0,
                                                  ),
                                                ),
                                              ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        MediaQuery.of(context)
                                                        .viewInsets
                                                        .bottom >
                                                    0 &&
                                                !isLargeScreen
                                            ? Container()
                                            : Material(
                                                color: Colors.transparent,
                                                child: Text(
                                                  'Just a coworking space.',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    letterSpacing: 1.5,
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 20,
                                ),
//                            Expanded(
//                              child: PageView(
//                                controller: pageViewController,
//                                physics: NeverScrollableScrollPhysics(),
//                                children: <Widget>[
//                                  _buildLoginView(),
//                                  _buildSignUpView(),
//                                  _buildLoadView(),
//                                ],
//                              ),
//                            ),
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
                                        fontSize: isLargeScreen
                                            ? fontSizeH3[0]
                                            : fontSizeH3[1],
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
                                          _isSignUpView = true;
                                          _isLogInView = false;
                                        });
                                      },
                                      child: Text(
                                        'Sign up',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: isLargeScreen
                                              ? fontSizeH3[0]
                                              : fontSizeH3[1],
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
                                        fontSize: isLargeScreen
                                            ? fontSizeH3[0]
                                            : fontSizeH3[1],
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
                                          _isSignUpView = false;
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
                                          fontSize: isLargeScreen
                                              ? fontSizeH3[0]
                                              : fontSizeH3[1],
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 24,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
