import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:meetee_mobile/module/facilityType.dart';

import 'package:meetee_mobile/components/datePicker.dart';
import 'package:meetee_mobile/components/timePicker.dart';

class CustomerDemand extends StatefulWidget {
  final FacilityType facilityType;
  final int index;

  CustomerDemand({Key key, @required this.facilityType, this.index})
      : super(key: key);
  @override
  _CustomerDemandState createState() => _CustomerDemandState();
}

class _CustomerDemandState extends State<CustomerDemand> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
//        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Reserve seat',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
//              color: Colors.black,
                height: 88.0,
                width: 272.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Color(
                    widget.facilityType.secondaryColorCode,
                  ),
                ),
                margin: EdgeInsets.fromLTRB(
                  24.0,
                  0.0,
                  24.0,
                  16.0,
                ),
                padding: EdgeInsets.all(16.0),
                child: Hero(
                  tag: 'facilityType' + widget.index.toString(),
                  child: SvgPicture.asset(
                    widget.facilityType.imagePath,
                  ),
                ),
              ),
            ),
            DatePicker(
              primaryColor: widget.facilityType.secondaryColorCode,
            ),
            TimePicker(
              primaryColor: widget.facilityType.primaryColor,
              secondaryColor: widget.facilityType.secondaryColorCode,
            )
          ],
        ),
      ),
    );
  }
}
