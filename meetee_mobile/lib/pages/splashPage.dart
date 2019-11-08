import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meetee_mobile/components/css.dart';
import 'package:meetee_mobile/components/fadeRouteDelayed.dart';
import 'package:meetee_mobile/pages/logInPage.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  bool isLargeScreen = false;

  AnimationController controller;
  Animation animation;
  @override
  void initState() {
    controller = AnimationController(
        duration: Duration(
          milliseconds: 2000,
        ),
        vsync: this);

    animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(controller);

    delayFadedText();
    loadData();
    super.initState();
  }

  Future<Timer> delayFadedText() async {
    return new Timer(Duration(seconds: 1), onDoneDelay);
  }

  onDoneDelay() async {
    controller.forward();
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 4), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.pushAndRemoveUntil(
      context,
      FadeRouteDelayed(
        page: LogInPage(),
      ),
      ModalRoute.withName('/login'),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    if (MediaQuery.of(context).size.height > 600) {
      setState(() {
        isLargeScreen = true;
      });
    } else {
      setState(() {
        isLargeScreen = false;
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Hero(
                tag: 'meeteeLogo',
                child: Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height / 5,
                      child: SvgPicture.asset(
                        'images/meetee_logo.svg',
                      ),
                    ),
                    FadeTransition(
                      opacity: animation,
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          'Meetee',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize:
                                isLargeScreen ? fontSizeH1[0] : fontSizeH1[1],
                            fontWeight: FontWeight.normal,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    FadeTransition(
                      opacity: animation,
                      child: Material(
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
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
