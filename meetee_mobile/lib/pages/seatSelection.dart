import 'package:flutter/material.dart';

class seatSelection extends StatefulWidget {
  @override
  _seatSelectionState createState() => _seatSelectionState();
}

class _seatSelectionState extends State<seatSelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seat selection'),
      ),
    );
  }
}
