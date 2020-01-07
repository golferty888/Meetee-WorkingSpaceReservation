import 'package:flutter/material.dart';
import 'package:meetee_mobile/pages/accountPage.dart';

import 'package:meetee_mobile/pages/activationPage.dart';
import 'package:meetee_mobile/pages/customerDemandPage.dart';
import 'package:meetee_mobile/pages/historyPage.dart';
import 'package:meetee_mobile/pages/homePage.dart';
import 'package:meetee_mobile/pages/schedulePage.dart';
import 'package:meetee_mobile/pages/logInPage.dart';
import 'package:meetee_mobile/pages/selectFacility.dart';
import 'package:meetee_mobile/pages/splashPage.dart';
import 'package:meetee_mobile/pages/navigationPage.dart';

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
        '/navigationPage': (BuildContext context) => NavigationPage(),
        '/homePage': (BuildContext context) => HomePage(),
        '/schedulePage': (BuildContext context) => SchedulePage(),
        '/accountPage': (BuildContext context) => AccountPage(),
        '/activationPage': (BuildContext context) => ActivationPage(),
        '/facilityType': (BuildContext context) => SelectFacilityType(),
        '/customerDemand': (BuildContext context) => CustomerDemandPage(),
      },
      theme: ThemeData(
//        primaryColor: Color(0xFF292b66),
        primaryColor: Color(0xFF361FB2),
//        scaffoldBackgroundColor: Colors.grey[300],
        fontFamily: 'productSans',
      ),
//      home: SplashPage(),
    );
  }
}
