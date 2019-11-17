import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:meetee_mobile/components/css.dart';
import 'package:meetee_mobile/components/fadeRoute.dart';

import 'package:meetee_mobile/model/facilityType.dart';
import 'package:meetee_mobile/pages/customerDemandPage.dart';

class SelectFacilityType extends StatefulWidget {
  final int userId;
  final bool isLargeScreen;

  SelectFacilityType({
    Key key,
    this.userId,
    this.isLargeScreen,
  }) : super(key: key);
  @override
  _SelectFacilityTypeState createState() => _SelectFacilityTypeState();
}

class _SelectFacilityTypeState extends State<SelectFacilityType> {
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
          'Select facility type'.toUpperCase(),
          style: TextStyle(
            color: Colors.black54,
            fontSize: widget.isLargeScreen ? fontSizeH3[0] : fontSizeH3[1],
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  settings: RouteSettings(name: '/customerDemand'),
                  builder: (context) {
                    return CustomerDemandPage(
                      userId: widget.userId,
                      facilityType: facilityTypeList[index],
                      index: index,
                      subType: index == 0 ? 'Seat' : 'Room',
                      isLargeScreen: widget.isLargeScreen,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
