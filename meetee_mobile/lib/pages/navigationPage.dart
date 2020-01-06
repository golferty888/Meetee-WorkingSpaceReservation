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

  final List<Widget> _menuList = [
    HomePage(
      userName: 'yoyo',
      userId: 2,
    ),
    SchedulePage(
      userName: 'yoyo',
      userId: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 8.0,
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
      body: _menuList[_currentIndex],
    );
  }
}
