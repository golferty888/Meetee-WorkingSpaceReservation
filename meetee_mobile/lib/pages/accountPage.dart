import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  final String userName;
  final int userId;

  AccountPage({
    Key key,
    this.userName,
    this.userId,
  }) : super(key: key);
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
            margin: EdgeInsets.only(top: 16),
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Container(
                  width: 64.0,
                  height: 64.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                        'images/placeholder_image.png',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                  widget.userName,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 80.0,
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
//            color: Colors.white,
            child: OutlineButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
//                  color: Colors.red,
              ),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.remove('userName');
                prefs.remove('passWord');
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login', (Route<dynamic> route) => false);
              },
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
    );
  }
}
