import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  final String userName;
  final int userId;

  MenuPage({
    Key key,
    this.userName,
    this.userId,
  }) : super(key: key);
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 80.0,
//                  color: Colors.white,
              padding: EdgeInsets.fromLTRB(
                16.0,
                16.0,
                16.0,
                16.0,
              ),
              child: OutlineButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'LOG OUT'.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
