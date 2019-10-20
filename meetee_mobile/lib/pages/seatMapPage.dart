import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

class SeatMapPage extends StatefulWidget {
//  final int type;
  final int index;
  final String imgPath;
  final String categoryName;
  final int cateId;
  final int secondaryColor;
  final DateTime startDate;
  final DateTime startTime;
  final DateTime endTime;

  SeatMapPage({
    Key key,
//        this.type,
    this.index,
    this.imgPath,
    this.categoryName,
    this.cateId,
    this.secondaryColor,
    this.startDate,
    this.startTime,
    this.endTime,
  }) : super(key: key);
  @override
  _SeatMapPageState createState() => _SeatMapPageState();
}

class _SeatMapPageState extends State<SeatMapPage> {
  @override
  void initState() {
//    getSeatByCategory();

    super.initState();
  }

//  FacilitiesList facilitiesList;
  final String getSeatsByCateURL =
      'http://18.139.12.132:9000/facility/cate/status/av';
  List _seatsList;

  FutureBuilder _buildGridView() {
    return FutureBuilder(
        future: http.post(
          getSeatsByCateURL,
          body: {
            "cateId": widget.cateId.toString(),
            "startDate": DateFormat("yyyy-MM-dd").format(widget.startDate),
            "startTime": DateFormat("HH:00:00").format(widget.startTime),
            "endTime": DateFormat("HH:00").format(widget.endTime),
            "endDate": DateFormat("yyyy-MM-dd").format(widget.startDate),
          },
        ),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('none...');
            case ConnectionState.active:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              print('getSeat: ${json.decode(snapshot.data.body)}');
              _seatsList = json.decode(snapshot.data.body);
              print(_seatsList);
              return GridView.count(
                  shrinkWrap: true,
                  primary: false,
                  crossAxisCount: 3,
                  childAspectRatio: 1.5,
//                itemCount: _seatsList.length,
//                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                    crossAxisCount: 3),
//                itemBuilder: (BuildContext context, int index) {
//                  return Container(
//                    margin: EdgeInsets.all(8.0),
//                    decoration: BoxDecoration(
//                      color: Colors.white,
//                      borderRadius: BorderRadius.circular(16.0),
//                    ),
//                    child: Center(
//                      child: Text(_seatsList[index]["code"]),
//                    ),
//                  );
//                },
                  children: List.generate(
                    _seatsList.length,
                    (index) {
                      return Container(
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(_seatsList[index]["code"]),
                        ),
                      );
                    },
                  ));
          }
          return null;
        });
  }

  @override
  Widget build(BuildContext context) {
    String startDateFormatted = DateFormat("dd MMMM").format(widget.startDate);
    String startTimeFormatted = DateFormat("HH:00").format(widget.startTime);
    String endTimeFormatted = DateFormat("HH:00").format(widget.endTime);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: 'category + ${widget.index.toString()}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.network(
                widget.imgPath,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 5.0,
              ),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          SafeArea(
            child: Container(
              padding: EdgeInsets.only(left: 16.0),
              child: FloatingActionButton(
                elevation: 0.0,
//                backgroundColor: Color(
//                  widget.secondaryColor,
//                ).withOpacity(0.9),
                backgroundColor: Colors.transparent,
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SafeArea(
              child: Container(
                height: 56.0,
                child: Center(
                  child: Text(
                    'Choose seats',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 22.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 56,
                ),
                Container(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(48.0, 8.0, 0.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.categoryName,
                          style: TextStyle(
                            color: Color(
                              widget.secondaryColor,
                            ),
                            fontSize: 32.0,
                          ),
                        ),
                        Text(
                          '$startTimeFormatted - $endTimeFormatted, $startDateFormatted',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
//                  height: 400,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[200],
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    margin: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
                    padding: EdgeInsets.all(8.0),
                    child: _buildGridView(),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Image(
                    image: AssetImage('images/map.jpg'),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
