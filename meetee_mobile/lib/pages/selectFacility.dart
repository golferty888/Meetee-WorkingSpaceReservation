import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:meetee_mobile/components/scaleRoute.dart';

import 'package:meetee_mobile/module/facilityType.dart';
import 'package:meetee_mobile/pages/customerDemand.dart';
import 'package:meetee_mobile/pages/facilityDetail.dart';

class SelectFacilityType extends StatefulWidget {
  @override
  _SelectFacilityTypeState createState() => _SelectFacilityTypeState();
}

class _SelectFacilityTypeState extends State<SelectFacilityType> {
  List<FacilityType> facilityTypeList = [
    FacilityType(
      'Chill\nRelax\nPrivate',
      'images/person.svg',
      'Single seat',
      Colors.yellow[800],
      0xFFffdd94,
    ),
    FacilityType(
      'Mate\nTeamwork\nCollaboration',
      'images/meeting.svg',
      'Meeting room',
      Colors.red[800],
      0xFFffa0a0,
    ),
    FacilityType(
      'Strategy\nDiscussion\nCooperation',
      'images/strategy.svg',
      'Playground room',
      Colors.deepPurple,
      0xFFccabd8,
    ),
  ];

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
          'Select Facility Type',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return Container(
//              color: Colors.black,
              height: 384.0,
              width: 256.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Color(
                  facilityTypeList[index].secondaryColorCode,
                ),
                image: DecorationImage(
                  image: AssetImage('images/noise.png'),
                  fit: BoxFit.fill,
                ),
              ),
              margin: EdgeInsets.fromLTRB(0, 0, 0, 48.0),
              padding: EdgeInsets.all(16.0),
//                    height: 650.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // make text start LEFT
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
                                page: facilityDetail(),
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
                          height: 24.0,
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
                  SizedBox()
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomerDemand(
                  facilityType: facilityTypeList[index],
                  index: index,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
