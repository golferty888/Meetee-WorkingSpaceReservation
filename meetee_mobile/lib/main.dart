import 'package:flutter/material.dart';

import 'package:meetee_mobile/pages/activationPage.dart';
import 'package:meetee_mobile/pages/historyPage.dart';
import 'package:meetee_mobile/pages/homePage.dart';
import 'package:meetee_mobile/pages/logInPage.dart';
import 'package:meetee_mobile/pages/selectFacility.dart';
import 'package:meetee_mobile/pages/splashPage.dart';

const bool debugEnableDeviceSimulator = true;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meetee Coworking space',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => SplashPage(),
        '/login': (BuildContext context) => LogInPage(),
        '/homePage': (BuildContext context) => HomePage(),
      },
      theme: ThemeData(
        primaryColor: Color(0xFF292b66),
//        primaryColor: Color(0xFF361FB2),
        scaffoldBackgroundColor: Colors.grey[300],
        fontFamily: 'productSans',
      ),
//      home: SplashPage(),
    );
  }
}
