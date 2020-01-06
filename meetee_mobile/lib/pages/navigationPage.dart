import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:meetee_mobile/pages/homePage.dart';
import 'schedulePage.dart';

class NavigationPage extends StatefulWidget {
  final String userName;
  final int userId;

  NavigationPage({
    Key key,
    this.userName,
    this.userId,
  }) : super(key: key);
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> _menuList = [
      HomePage(
        userName: widget.userName,
        userId: widget.userId,
      ),
      SchedulePage(
        userName: widget.userName,
        userId: widget.userId,
      ),
    ];

    return Scaffold(
//      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: _menuList[_currentIndex],
              ),
              Container(
                height: 0.1,
                color: Colors.black45,
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(16.0),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5.0,
                  sigmaY: 5.0,
                ),
                child: BottomNavigationBar(
                  backgroundColor: Colors.white.withOpacity(0.9),
                  elevation: 0.0,
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      title: Text('Home'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.schedule),
                      title: Text('Schedule'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.menu),
                      title: Text('Menu'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
