import 'package:flutter/material.dart';
import 'package:meetee_mobile/pages/customerDemand.dart';

import 'package:meetee_mobile/pages/historyPage.dart';
import 'package:meetee_mobile/pages/selectFacility.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.grey,
        fontFamily: 'Product Sans',
      ),
      home: MyHomePage(),
      routes: <String, WidgetBuilder>{
        '/customerDemand': (BuildContext context) => CustomerDemand(),
        '/selectFacility': (BuildContext context) => SelectFacilityType(),
      },
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
                height: 320.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/meetee_logo.png'),
//                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Text(
                'Meetee',
                style: TextStyle(
                  fontSize: 56.0,
                  letterSpacing: 2.0,
                ),
              ),
              Text(
                'A place for relaxing.',
                style: TextStyle(
                  fontSize: 24.0,
                  letterSpacing: 2.0,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 36.0,
              ),
              OutlineButton(
                splashColor: Colors.black,
                highlightElevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                borderSide: BorderSide(
                  width: 1.5,
                  color: Colors.grey[700],
                ),
                color: Colors.transparent,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoryPage(),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 24.0,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  width: 120.0,
                  child: Text(
                    'HISTORY',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: 2.0,
//                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              RaisedButton(
                elevation: 0.0,
                splashColor: Colors.white,
                highlightElevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                color: Colors.black,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectFacilityType(),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 24.0,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  width: 120.0,
                  child: Text(
                    'TAKE A SEAT',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
