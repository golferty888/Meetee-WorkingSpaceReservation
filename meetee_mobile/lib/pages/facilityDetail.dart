import 'package:flutter/material.dart';

class FacilityDetail extends StatefulWidget {
  @override
  FacilityDetailState createState() => FacilityDetailState();
}

class FacilityDetailState extends State<FacilityDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Facility detail',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
