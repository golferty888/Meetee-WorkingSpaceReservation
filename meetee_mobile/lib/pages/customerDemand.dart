import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:meetee_mobile/model/facilityType.dart';
import 'package:meetee_mobile/model/facility.dart';

import 'package:meetee_mobile/components/datePicker.dart';
import 'package:meetee_mobile/components/timePicker.dart';

class CustomerDemand extends StatefulWidget {
  final FacilityType facilityType;
  final int index;

  CustomerDemand({
    Key key,
    @required this.facilityType,
    this.index,
  }) : super(key: key);
  @override
  _CustomerDemandState createState() => _CustomerDemandState();
}

class _CustomerDemandState extends State<CustomerDemand> {
  String getSeatByCateURL = 'http://18.139.12.132:9000/facility/cate/status';

  @override
  void initState() {
    print('init');
    getSeatByClass();
    super.initState();
  }

  FacilitiesList facilitiesList;

  Future<dynamic> getSeatByCategory() async {
    print('getSeatByClass');
    print(this._selectedCateId);
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
    print('{\n'
        'classId: ${widget.facilityType.classId},\n'
        'startDate: $startDate,\n'
        'endDate: $startDate,\n'
        'startTime: $startTime,\n'
        'endTime: $endTime,\n'
        '}');
    if (response.statusCode == 200) {
      print('200');
      final jsonData = json.decode(response.body);
      setState(() {
        facilitiesList = FacilitiesList.fromJson(jsonData);
      });
      print(jsonData);
    } else {
      print('400');
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
    getSeatByCategory();
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
  }

  List categoryNameList;
  List categoryIdList;
  String _selectedCateId;
  String _selectedCateName;

  List<Widget> _buildCateList() {
    List<Widget> cateBox = [];

    widget.facilityType.categories.forEach((cateName, cateId) {
      cateBox.add(
        _buildCate(cateName),
      );
    });

    return cateBox;
  }

  _onSelectedCate(String selectedCate) {
    setState(() {
      this._selectedCateName = selectedCate;
      this._selectedCateId =
          widget.facilityType.categories[selectedCate].toString();
      getSeatByCategory();
      _selectedFacility = 0;
    });
    print('cateName: ' + this._selectedCateName);
    print('cateId: ' + this._selectedCateId);
  }

  Widget _buildCate(String cate) {
    return GestureDetector(
      onTap: () => _onSelectedCate(cate),
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(
          right: 16.0,
        ),
        decoration: BoxDecoration(
          color: _selectedCateName != null && _selectedCateName == cate
              ? Color(widget.facilityType.secondaryColorCode)
              : Colors.grey[300],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 11),
          child: Text(
            cate.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: _selectedCateName == cate
                  ? FontWeight.bold
                  : FontWeight.normal,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  int _selectedFacility = 0;

  _onSelectedFac(int index) {
    setState(() {
      this._selectedFacility = index;
    });
    print(this._selectedFacility);
  }

  Widget _buildSelectedFacility(selectedFacility) {
//    if (widget.facilityType
//            .categories[facilitiesList.facilities[index].cateId - 1] ==
//        selectedCate) {
    return GestureDetector(
      onTap: () => _onSelectedFac(selectedFacility),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        padding: EdgeInsets.fromLTRB(
          16.0,
          8.0,
          16.0,
          8.0,
        ),
        decoration: BoxDecoration(
          color:
              _selectedFacility != null && _selectedFacility == selectedFacility
                  ? Color(widget.facilityType.secondaryColorCode)
                  : Colors.grey[300],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Text(
          facilitiesList.facilities[selectedFacility] == null
              ? 'null'
              : facilitiesList.facilities[selectedFacility].code.toString(),
          style: TextStyle(
            fontWeight: _selectedFacility == selectedFacility
                ? FontWeight.bold
                : FontWeight.normal,
            fontSize: 16.0,
          ),
        ),
      ),
    );
//    } else {
//      return null;
//    }
  }

  double _bottomButtonHeight = 48.0;
  bool _isSubmit = false;

  onSubmit() {
    setState(() {
      _bottomButtonHeight =
          MediaQuery.of(context).size.height - AppBar().preferredSize.height;
      _isSubmit = true;
    });
  }

  _buildSubmit() {
    if (_isSubmit) {
      return Center(
        child: Column(
          children: <Widget>[
            Center(
              child: Text('eieieieeiie'),
            ),
            Center(
              child: Text('eieieieeiie'),
            ),
            Center(
              child: Text('eieieieeiie'),
            ),
            Center(
              child: Text('eieieieeiie'),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        height: 48,
        child: Text(
          'Reserve',
          textAlign: TextAlign.center,
        ),
      );
    }
  }

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
          'Reserve ${widget.facilityType.typeName.toLowerCase()}',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DatePicker(
                  primaryColor: widget.facilityType.secondaryColorCode,
                  returnDate: _updateStartDate,
                ),
                TimePicker(
                  primaryColor: widget.facilityType.primaryColor,
                  secondaryColor: widget.facilityType.secondaryColorCode,
                  returnStartTime: _updateStartTime,
                  returnEndTime: _updateEndTime,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                      24.0,
                      0.0,
                      24.0,
                      0.0,
                    ),
//                  padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Select type',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                      24.0,
                      0.0,
                      24.0,
                      16.0,
                    ),
//                  padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: _buildCateList(),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(
                    24.0,
                    0.0,
                    24.0,
                    16.0,
                  ),
                  child: Text(
                    'Select facility',
                    style: TextStyle(
                      fontSize: 20.0,
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
                    itemCount: facilitiesList == null
                        ? 0
                        : facilitiesList.facilities.length,
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
              ],
            ),
            Positioned(
              bottom: 0.0,
              right: 0.0,
              left: 0.0,
              child: AnimatedContainer(
                height: _bottomButtonHeight,
                duration: Duration(milliseconds: 600),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(0.0),
                  ),
                  color: Color(widget.facilityType.secondaryColorCode),
                  onPressed: () {
                    onSubmit();
                  },
                  child: _buildSubmit(),
                ),
              ),
            ),
          ],
        ),
      ),
//      bottomNavigationBar: BottomAppBar(
//        child: Container(
//          padding: EdgeInsets.symmetric(vertical: 16.0),
//          height: 48.0,
//          decoration: BoxDecoration(
//            color: Color(widget.facilityType.secondaryColorCode),
//            image: DecorationImage(
//              image: AssetImage(
//                'images/noise.png',
//              ),
//              fit: BoxFit.fill,
//            ),
//          ),
//          child: InkWell(
//            child: Text(
//              'Reserve',
//              textAlign: TextAlign.center,
//            ),
//            onTap: () {
//            },
//          ),
//        ),
//      ),
    );
  }
}
