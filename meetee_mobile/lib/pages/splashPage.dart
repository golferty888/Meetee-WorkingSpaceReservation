import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meetee_mobile/components/colorLoader.dart';
import 'package:meetee_mobile/components/fadeRoute.dart';
import 'package:meetee_mobile/pages/getStartPage.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 4), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.push(
      context,
      FadeRoute(
        page: GetStartPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(),
          ),
          Hero(
            tag: 'meeteeLogo',
            child: Container(
              height: 240,
              child: SvgPicture.asset(
                'images/meetee_logo.svg',
              ),
            ),
          ),
//          Container(
//            height: 320,
//            child: SvgPicture.asset(
//              'images/meetee_logo.svg',
//            ),
//          ),
          Expanded(
            flex: 2,
            child: Container(),
          ),
          Center(
            child: ColorLoader4(
//              dotOneColor: Color(0xFFFAD74E),
//              dotTwoColor: Color(0xFFFF8989),
//              dotThreeColor: Color(0xFF92D2FC),
              dotOneColor: Colors.yellow[800],
              dotTwoColor: Colors.pink[400],
              dotThreeColor: Colors.purple,
              duration: Duration(milliseconds: 1000),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(),
          ),
        ],
      ),
    );
  }
}
