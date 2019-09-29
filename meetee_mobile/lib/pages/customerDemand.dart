import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:meetee_mobile/pages/summary.dart';
import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

import 'package:meetee_mobile/model/facilityType.dart';
import 'package:meetee_mobile/model/facility.dart';

import 'package:meetee_mobile/components/datePicker.dart';
import 'package:meetee_mobile/components/timePicker.dart';

class CustomerDemand extends StatefulWidget {
  final FacilityType facilityType;
  final int index;
  final String subType;

  CustomerDemand({
    Key key,
    @required this.facilityType,
    this.index,
    this.subType,
  }) : super(key: key);
  @override
  _CustomerDemandState createState() => _CustomerDemandState();
}

class _CustomerDemandState extends State<CustomerDemand> {
  final double titleFontSize = 18.0;
  final double valueFontSize = 14.0;
  final String getSeatByCateURL =
      'http://18.139.12.132:9000/facility/cate/status';

  @override
  void initState() {
    categoryNameList = widget.facilityType.categories.keys.toList();
    categoryIdList = widget.facilityType.categories.values.toList();
    _selectedCateName = categoryNameList[0];
    _selectedCateId = categoryIdList[0]["cateId"];
    _selectedCapacity = categoryIdList[0]["capacity"];
    _selectedPrice = categoryIdList[0]["price"];
    _totalPrice = categoryIdList[0]["price"];
    getSeatByCategory();
    super.initState();
  }

  _connectSocket01() async {
    final channel =
        await IOWebSocketChannel.connect('ws://18.139.12.132:9999/');
    print('connect');
    channel.sink.add("Hello, this is Meetee");
    channel.stream.listen((message) {
      print(message);
    });
    channel.sink.add("Prepare to say goodbye.");
    channel.sink.close(status.goingAway);
  }

  FacilitiesList facilitiesList;

  Future<dynamic> getSeatByCategory() async {
    final response = await http.post(
      getSeatByCateURL,
      body: {
        "cateId": _selectedCateId,
        "startDate": startDate,
        "startTime": startTime,
        "endTime": endTime,
        "endDate": startDate,
      },
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        facilitiesList = FacilitiesList.fromJson(jsonData);
        if (facilitiesList.facilities.length == 0) {
          _firstRow = 0;
        } else if (facilitiesList.facilities.length <= 5) {
          _firstRow = facilitiesList.facilities.length;
        } else {
          _firstRow = 5;
          _isNeedSecondRow = true;
        }
      });
    } else {
      throw Exception('Failed to load post');
    }
  }

  String startDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String startTime = DateFormat("HH:00:00").format(
    DateTime.now().add(
      Duration(hours: 1),
    ),
  );
  String endTime = DateFormat("HH:00:00").format(
    DateTime.now().add(
      Duration(hours: 2),
    ),
  );

  _updateStartDate(DateTime startDate) {
    String formatted = DateFormat("yyyy-MM-dd").format(startDate);
    setState(() {
      this.startDate = formatted;
    });
    _checkIsToday();
    getSeatByCategory();
    _isChangeCate = false;
    _calculateTotalPrice();
  }

  bool _isToday = true;
  _checkIsToday() {
    if (this.startDate == DateFormat("yyyy-MM-dd").format(DateTime.now())) {
      setState(() {
        _isToday = true;
        print('isToday: _isToday = ' + _isToday.toString());
      });
    } else {
      setState(() {
        _isToday = false;
        print('isNotToday: _isToday = ' + _isToday.toString());
      });
    }
  }

  _updateStartTime(int startTime) {
    String formatted = TimeOfDay(hour: startTime, minute: 0)
            .toString()
            .split('(')[1]
            .split(')')[0] +
        ':00';
    setState(() {
      this.startTime = formatted;
    });
    getSeatByCategory();
    _isChangeCate = false;
    _calculateTotalPrice();
  }

  _updateEndTime(int endTime) {
    String formatted = TimeOfDay(hour: endTime, minute: 0)
            .toString()
            .split('(')[1]
            .split(')')[0] +
        ':00';
    setState(() {
      this.endTime = formatted;
    });
    getSeatByCategory();
    _isChangeCate = false;
    _calculateTotalPrice();
  }

  List categoryNameList;
  List categoryIdList;
  String _selectedCateId;
  String _selectedCateName;
  int _selectedCapacity;
  int _selectedPrice;

  List<Widget> _buildCateList(int row) {
    List<Widget> cateBox = [];

    widget.facilityType.categories.forEach((cateName, cateId) {
      cateBox.add(
        _buildCate(cateName),
      );
    });
    if (cateBox.length >= 4) {
      if (row == 1) {
        cateBox.removeRange(3, 4);
        return cateBox;
      } else {
        cateBox.removeRange(0, 3);
        cateBox.add(
          Expanded(
            flex: 1,
            child: Container(),
          ),
        );
        cateBox.add(
          Expanded(
            flex: 1,
            child: Container(),
          ),
        );
        return cateBox;
      }
    } else if (cateBox.length == 2) {
      if (row == 1) {
        cateBox.add(
          Expanded(
            flex: 1,
            child: Container(),
          ),
        );
        return cateBox;
      } else {
        return [Container()];
      }
    } else if (cateBox.length == 1) {
      if (row == 1) {
        cateBox.add(
          Expanded(
            flex: 1,
            child: Container(),
          ),
        );
        return cateBox;
      } else {
        return [Container()];
      }
    } else {
      if (row == 1) {
        return cateBox;
      } else {
        return [Container()];
      }
    }
  }

  _onSelectedCate(String selectedCate) {
    setState(() {
      this._isChangeCate = true;
      this._selectedCateName = selectedCate;
      this._selectedCateId =
          widget.facilityType.categories[selectedCate]["cateId"].toString();
      getSeatByCategory();
      this._selectedPrice =
          widget.facilityType.categories[selectedCate]["price"];
      this._selectedCapacity =
          widget.facilityType.categories[selectedCate]["capacity"];
      _selectedFacility = 0;
    });
    _calculateTotalPrice();
    print('cateId: ' + this._selectedCateId);
    print('cateName: ' + this._selectedCateName);
    print('catePrice: ' + this._selectedPrice.toString());
    print('cateCap: ' + this._selectedCapacity.toString());
    print('Price: ' + this._totalPrice.toString());
  }

  Widget _buildCate(String cate) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () => _onSelectedCate(cate),
        child: Container(
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.fromLTRB(
            0.0,
            0.0,
            16.0,
            8.0,
          ),
          decoration: BoxDecoration(
            color: _selectedCateName != null && _selectedCateName == cate
                ? Color(widget.facilityType.secondaryColorCode)
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            cate.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: _selectedCateName == cate
                  ? FontWeight.bold
                  : FontWeight.normal,
              fontSize: valueFontSize,
            ),
          ),
        ),
      ),
    );
  }

  int _selectedFacility = 0;
  bool _isChangeCate = false;

  _onSelectedFac(int index) {
    setState(() {
      this._selectedFacility = index;
      _isChangeCate = false;
    });
  }

  _delayData() async {
    await Future.delayed(
      Duration(milliseconds: 200),
    );
    return 'done';
  }

  Widget _buildSelectedFacility(selectedFacility) {
    return _isChangeCate
        ? FutureBuilder(
            future: _delayData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Container();
                case ConnectionState.waiting:
                  return Container();
                case ConnectionState.done:
                  return GestureDetector(
                    onTap: () => _onSelectedFac(selectedFacility),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 6.0),
                      padding: EdgeInsets.fromLTRB(
                        11.0,
                        8.0,
                        11.0,
                        8.0,
                      ),
                      decoration: BoxDecoration(
                        color: _selectedFacility != null &&
                                _selectedFacility == selectedFacility
                            ? Color(widget.facilityType.secondaryColorCode)
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Text(
                        facilitiesList.facilities[selectedFacility] == null
                            ? 'null'
                            : facilitiesList.facilities[selectedFacility].code
                                .toString(),
                        style: TextStyle(
                          fontWeight: _selectedFacility == selectedFacility
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: valueFontSize,
                        ),
                      ),
                    ),
                  );
                default:
                  return Container();
              }
            },
          )
        : GestureDetector(
            onTap: () => _onSelectedFac(selectedFacility),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 6.0),
              padding: EdgeInsets.fromLTRB(
                11.0,
                8.0,
                11.0,
                8.0,
              ),
              decoration: BoxDecoration(
                color: _selectedFacility != null &&
                        _selectedFacility == selectedFacility
                    ? Color(widget.facilityType.secondaryColorCode)
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Text(
                facilitiesList.facilities[selectedFacility] == null
                    ? 'null'
                    : facilitiesList.facilities[selectedFacility].code
                        .toString(),
                style: TextStyle(
                  fontWeight: _selectedFacility == selectedFacility
                      ? FontWeight.bold
                      : FontWeight.normal,
                  fontSize: valueFontSize,
                ),
              ),
            ),
          );
  }

  bool _isNeedSecondRow = false;
  int _firstRow;
  int _totalPrice;

  _calculateTotalPrice() {
    int totalHour;
    int endTimeHour = int.parse(endTime.split(':')[0]);
    int startTimeHour = int.parse(startTime.split(':')[0]);
    if (endTimeHour - startTimeHour < 0) {
      totalHour = endTimeHour - startTimeHour + 24;
    } else {
      totalHour = endTimeHour - startTimeHour;
    }
    setState(() {
      _totalPrice = _selectedPrice * totalHour;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2.5,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Reserve ${widget.facilityType.typeName.toLowerCase()}',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22.0,
          ),
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey[100],
                  ),
                ),
                child: DatePicker(
                  primaryColor: widget.facilityType.secondaryColorCode,
                  returnDate: _updateStartDate,
                  titleFontSize: titleFontSize,
                  valueFontSize: valueFontSize,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey[100],
                  ),
                ),
                child: _isToday
                    ? TimePicker(
                        primaryColor: widget.facilityType.primaryColor,
                        secondaryColor: widget.facilityType.secondaryColorCode,
                        returnStartTime: _updateStartTime,
                        returnEndTime: _updateEndTime,
                        titleFontSize: titleFontSize,
                        valueFontSize: valueFontSize,
                        isToday: true,
                      )
                    : TimePicker(
                        primaryColor: widget.facilityType.primaryColor,
                        secondaryColor: widget.facilityType.secondaryColorCode,
                        returnStartTime: _updateStartTime,
                        returnEndTime: _updateEndTime,
                        titleFontSize: titleFontSize,
                        valueFontSize: valueFontSize,
                        isToday: false,
                      ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey[100],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(
                        0.0,
                        8,
                        0.0,
                        8.0,
                      ),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                          24.0,
                          0.0,
                          24.0,
                          0.0,
                        ),
                        child: Text(
                          'Select type',
                          style: TextStyle(
                            fontSize: titleFontSize,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                          24.0,
                          0.0,
                          24.0,
                          0.0,
                        ),
                        child: Row(
                          children: _buildCateList(1),
                        ),
                      ),
                    ),
                    Container(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                          24.0,
                          0.0,
                          24.0,
                          4.0,
                        ),
                        child: Row(
                          children: _buildCateList(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey[100],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(
                        24.0,
                        8.0,
                        24.0,
                        8.0,
                      ),
                      child: Text(
                        '${widget.subType} number',
                        style: TextStyle(
                          fontSize: titleFontSize,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                        16.0,
                        0.0,
                        0.0,
                        0.0,
                      ),
                      height: 32.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: facilitiesList == null ? 0 : _firstRow,
                        itemBuilder: (BuildContext context, int index) {
                          if (facilitiesList.facilities[index].status ==
                              'available') {
                            return _buildSelectedFacility(index);
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    _isNeedSecondRow
                        ? Container(
                            margin: EdgeInsets.fromLTRB(
                              16.0,
                              8.0,
                              0.0,
                              12.0,
                            ),
                            height: 32.0,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: facilitiesList == null
                                  ? 0
                                  : facilitiesList.facilities.length -
                                      _firstRow,
                              itemBuilder: (BuildContext context, int index) {
                                if (facilitiesList
                                        .facilities[index + 5].status ==
                                    'available') {
                                  return _buildSelectedFacility(index + 5);
                                } else {
                                  return null;
                                }
                              },
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.fromLTRB(
                              16.0,
                              0.0,
                              0.0,
                              12.0,
                            ),
                          ),
                  ],
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Expanded(
                flex: 180,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey[100],
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(
                            24.0,
                            8.0,
                            0.0,
                            8.0,
                          ),
                          child: _isChangeCate
                              ? FutureBuilder(
                                  future: _delayData(),
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.none:
                                        return Container();
                                      case ConnectionState.waiting:
                                        return Container();
                                      case ConnectionState.active:
                                        return Container();
                                      case ConnectionState.done:
                                        return Container(
                                          margin: EdgeInsets.symmetric(
                                            vertical: 0.0,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16.0,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey[200],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: SvgPicture.asset(
                                            'images/facility/${_selectedCateName.toLowerCase()}.svg',
                                          ),
                                        );
                                      default:
                                        return Container();
                                    }
                                  },
                                )
                              : Container(
                                  margin: EdgeInsets.symmetric(
                                    vertical: 0.0,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey[200],
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: SvgPicture.asset(
                                    'images/facility/${_selectedCateName.toLowerCase()}.svg',
                                  ),
                                ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: _isChangeCate
                              ? FutureBuilder(
                                  future: _delayData(),
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.none:
                                        return Container();
                                      case ConnectionState.waiting:
                                        return Container();
                                      case ConnectionState.active:
                                        return Container();
                                      case ConnectionState.done:
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Capacity:',
                                              style: TextStyle(
                                                fontSize: valueFontSize,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                16.0,
                                                2.0,
                                                0.0,
                                                8.0,
                                              ),
                                              child: Text(
                                                '$_selectedCapacity person' +
                                                    '${_selectedCapacity > 1 ? 's' : ''}',
                                                style: TextStyle(
                                                  fontSize: titleFontSize,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'Cost:',
                                              style: TextStyle(
                                                fontSize: valueFontSize,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                16.0,
                                                2.0,
                                                0.0,
                                                0.0,
                                              ),
                                              child: Text(
                                                '$_selectedPrice Baht/hour',
                                                style: TextStyle(
                                                  fontSize: titleFontSize,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      default:
                                        return Container();
                                    }
                                  },
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Capacity:',
                                      style: TextStyle(
                                        fontSize: valueFontSize,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        16.0,
                                        2.0,
                                        0.0,
                                        8.0,
                                      ),
                                      child: Text(
                                        '$_selectedCapacity person' +
                                            '${_selectedCapacity > 1 ? 's' : ''}',
                                        style: TextStyle(
                                          fontSize: titleFontSize,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Cost:',
                                      style: TextStyle(
                                        fontSize: valueFontSize,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        16.0,
                                        2.0,
                                        0.0,
                                        0.0,
                                      ),
                                      child: Text(
                                        '$_selectedPrice Baht/hour',
                                        style: TextStyle(
                                          fontSize: titleFontSize,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Container(
                height: 48.0,
                margin: EdgeInsets.fromLTRB(
                  24.0,
                  0.0,
                  24.0,
                  24.0,
                ),
                child: RaisedButton(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  color: Color(widget.facilityType.secondaryColorCode),
                  onPressed: () {
                    Navigator.of(context).push(_createRoute());
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'BOOK ($_totalPrice Baht)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Summary(
        colorCode: widget.facilityType.secondaryColorCode,
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
