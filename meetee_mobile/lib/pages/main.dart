import 'package:flutter/material.dart';

import 'package:meetee_mobile/pages/history.dart';
import 'package:meetee_mobile/pages/selectFacility.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        accentColor: Color(0xFF49c5b6),
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.grey,
        fontFamily: 'Product Sans',
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'images/noise.png',
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 160.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/meetee_logo.png'),
                  ),
                ),
              ),
              Text(
                'Meetee,',
                style: TextStyle(fontSize: 48.0),
              ),
              Text(
                'Just a reservation app.'
                '\nJust a reservation app.'
                '\nJust a reservation app.'
                '\nJust a reservation app.',
                style: TextStyle(fontSize: 24.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 48.0,
              ),
              RaisedButton(
                color: Colors.black,
                splashColor: Colors.white,
                elevation: 0.0,
                highlightElevation: 0.0,
                child: Text(
                  'Take a seat',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).push(_createRoute());
                },
              ),
              SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        SelectFacilityType(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset(0.0, 0.0);
      var curve = Curves.easeIn;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
