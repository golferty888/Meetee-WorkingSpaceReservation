import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:meetee_mobile/components/scaleRoute.dart';

import 'package:meetee_mobile/model/facilityType.dart';
import 'package:meetee_mobile/pages/bookingPage.dart';
import 'package:meetee_mobile/pages/customerDemand.dart';
import 'package:meetee_mobile/pages/facilityDetail.dart';

class SelectFacilityType extends StatefulWidget {
  @override
  _SelectFacilityTypeState createState() => _SelectFacilityTypeState();
}

class _SelectFacilityTypeState extends State<SelectFacilityType> {
  List<FacilityType> facilityTypeList = [
    FacilityType(
      '2',
      'Chill\nRelax\nPrivate',
      'images/facilityType/person.svg',
      'Private seat',
      Colors.yellow[900],
      0xFFFAD74E,
      {
        'Single chair': {
          'cateImage': 'images/category/seat/single_chair.jpg',
          'cateId': '4',
          'capacity': 1,
          'price': 30,
        },
        'Bar chair': {
          'cateImage': 'images/category/seat/bar_chair.jpg',
          'cateId': '5',
          'capacity': 1,
          'price': 30,
        },
        'Single sofa': {
          'cateImage': 'images/category/seat/single_sofa.jpg',
          'cateId': '6',
          'capacity': 1,
          'price': 40,
        },
        'Twin sofa': {
          'cateImage': 'images/category/seat/twin_sofa.jpg',
          'cateId': '7',
          'capacity': 2,
          'price': 60,
        },
      },
      [
        '1-2 PERSONS',
        'Wi-Fi',
        'Power bar',
      ],
    ),
    FacilityType(
      '1',
      'Mate\nTeamwork\nCollaboration',
      'images/facilityType/meeting.svg',
      'Meeting room',
      Colors.red[800],
      0xFFFF8989,
      {
        'Small room': {
          'cateImage': 'images/category/room/room_s.jpg',
          'cateId': '1',
          'capacity': 4,
          'price': 120,
        },
        'Medium room': {
          'cateImage': 'images/category/room/room_m.jpg',
          'cateId': '2',
          'capacity': 8,
          'price': 250,
        },
        'Large room': {
          'cateImage': 'images/category/room/room_l.jpg',
          'cateId': '3',
          'capacity': 12,
          'price': 400,
        },
      },
      [
        '4-12 PERSONS',
        'Wi-Fi',
        'Apple TV',
      ],
    ),
    FacilityType(
      '3',
      'Strategy\nDiscussion\nCooperation',
      'images/facilityType/strategy.svg',
      'Seminar room',
      Colors.deepPurple,
      0xFF92D2FC,
      {
        'Hall room': {
          'cateImage': 'images/category/seminar/seminar.jpg',
          'cateId': '8',
          'capacity': 30,
          'price': 950,
        },
      },
      [
        '30 PERSONS',
        'Wi-Fi',
        'Whiteboard & Pen',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: Padding(
          padding: EdgeInsets.only(left: 24.0),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          'Select facility type',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22.0,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: 16.0,
        ),
        child: SafeArea(
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 384.0,
                width: 256.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Color(
                    facilityTypeList[index].secondaryColorCode,
                  ),
                ),
                margin: EdgeInsets.fromLTRB(
                  0,
                  0,
                  0,
                  48.0,
                ),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          facilityTypeList[index].words,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontStyle: FontStyle.italic,
                            letterSpacing: 1.0,
                          ),
                        ),
                        InkWell(
                          child: Icon(
                            Icons.info_outline,
                            size: 24.0,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                ScaleRoute(
                                  page: FacilityDetail(),
                                ));
                          },
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: <Widget>[
                          Hero(
                            tag: 'facilityType' + index.toString(),
                            child: SvgPicture.asset(
                              facilityTypeList[index].imagePath,
                            ),
                          ),
                          SizedBox(
                            height: 32.0,
                          ),
                          Text(
                            facilityTypeList[index].typeName,
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 26.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: facilityTypeList[index].equipment.length,
                        itemBuilder: (BuildContext context, int index2) {
                          return Container(
                            padding: EdgeInsets.fromLTRB(
                              8.0,
                              6.5,
                              8.0,
                              6.0,
                            ),
                            margin: EdgeInsets.only(
                              right: 8.0,
                            ),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(
                                255,
                                255,
                                255,
                                0.5,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
//                              border: Border.all(color: Colors.black),
                            ),
                            child: Text(
                              facilityTypeList[index]
                                  .equipment[index2]
                                  .toString()
                                  .toUpperCase(),
                              style: TextStyle(
                                fontSize: 10.0,
                                color: Colors.grey[700],
                                letterSpacing: 1.5,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: facilityTypeList.length,
            viewportFraction: 0.85,
            scale: 0.9,
            pagination: SwiperPagination(
              margin: EdgeInsets.fromLTRB(0.0, 0, 0.0, 16.0),
            ),
            onTap: (index) {
              Navigator.of(context).push(_createRoute(index));
            },
          ),
        ),
      ),
    );
  }

  Route _createRoute(index) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => BookingPage(
        facilityType: facilityTypeList[index],
        index: index,
        subType: index == 0 ? 'Seat' : 'Room',
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset(0.0, 0.0);
        var curve = Curves.easeIn;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
