import 'package:flutter/material.dart';

import 'package:meetee_mobile/pages/history.dart';
import 'package:meetee_mobile/pages/selectFacility.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
      appBar: AppBar(
        title: Text('Home page'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: AlignmentDirectional.center,
              color: Colors.amber[200],
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectFacilityType(),
                    ),
                  );
                },
                child: Text(
                  'Reserve',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36.0,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: AlignmentDirectional.center,
              color: Colors.teal[200],
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoryPage(),
                    ),
                  );
                },
                child: Text(
                  'History',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36.0,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
