import 'package:flutter/material.dart';
import 'package:meetee_mobile/components/calendarPicker.dart';
import 'package:meetee_mobile/components/periodPicker.dart';
import 'package:meetee_mobile/model/facilityType.dart';

class BookingPage extends StatefulWidget {
  final FacilityType facilityType;
  final int index;
  final String subType;

  BookingPage({
    Key key,
    @required this.facilityType,
    this.index,
    this.subType,
  }) : super(key: key);
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Booking',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22.0,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: CalendarPicker(),
                  ),
                  Expanded(
                    flex: 1,
                    child: PeriodPicker(),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
