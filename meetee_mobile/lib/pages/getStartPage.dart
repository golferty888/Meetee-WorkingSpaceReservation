import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GetStartPage extends StatefulWidget {
  @override
  _GetStartPageState createState() => _GetStartPageState();
}

class _GetStartPageState extends State<GetStartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Hero(
          tag: 'meeteeLogo',
          child: Container(
            height: 320,
            child: SvgPicture.asset(
              'images/meetee_logo.svg',
            ),
          ),
        ),
      ),
    );
  }
}
