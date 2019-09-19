import 'package:flutter/material.dart';

class SeatSelection extends StatefulWidget {
  @override
  _SeatSelectionState createState() => _SeatSelectionState();
}

class _SeatSelectionState extends State<SeatSelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Seat selection'),
      ),
    );
  }
}
