import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:meetee_mobile/components/css.dart';
import 'package:meetee_mobile/main.dart';
import 'package:meetee_mobile/pages/activationPage.dart';
import 'package:meetee_mobile/pages/bookingCompletePage.dart';
import 'package:meetee_mobile/pages/homePage.dart';

import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:meetee_mobile/config.dart';

class Summary extends StatefulWidget {
  final int userId;
  final bool isLargeScreen;
  final int colorCode;
  final DateTime startDate;
  final DateTime startTime;
  final DateTime endTime;
  final List facId;
  final String type;
  final List code;
  final String totalPrice;
  final String imgPath;
  final int index;

  Summary({
    Key key,
    @required this.colorCode,
    @required this.userId,
    @required this.isLargeScreen,
    @required this.startDate,
    @required this.startTime,
    @required this.endTime,
    @required this.facId,
    @required this.type,
    @required this.code,
    @required this.totalPrice,
    @required this.imgPath,
    @required this.index,
  }) : super(key: key);
  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
//  final String userId = '2';
  final String reserveSeatUrl = 'http://18.139.12.132:9000/reserve';

  String startDateFormattedForApi;
  String startDateFormatted;
  String startTimeFormatted;
  String endTimeFormatted;

  Map<String, String> headers = {"Content-type": "application/json"};

  @override
  void initState() {
    super.initState();

    startDateFormattedForApi =
        DateFormat("yyyy-MM-dd").format(widget.startDate);
    startDateFormatted = DateFormat("dd MMMM yyy").format(widget.startDate);
    startTimeFormatted = DateFormat("HH:00").format(widget.startTime);
    endTimeFormatted = DateFormat("HH:00").format(widget.endTime);
  }

  Future<dynamic> reserveSeat() async {
    String body = '{'
        '"userId": ${widget.userId}, '
        '"startDate": "$startDateFormattedForApi", '
        '"startTime": "$startTimeFormatted", '
        '"endTime": "$endTimeFormatted", '
        '"facId": ${widget.facId}, '
        '"totalPrice": ${widget.totalPrice}'
        '}';
//    String body = '{'
//        '"userId": $userId, '
//        '"startDate": "$startDateFormattedForApi", '
//        '"startTime": "19:00:00", '
//        '"endTime": "20:00:00", '
//        '"facId": ${widget.facId}, '
//        '"totalPrice": ${widget.totalPrice}'
//        '}';
    print(body);
    final response = await http.post(
      reserveSeatUrl,
//      body: {
//        "userId": 1.toString(),
//        "startDate": "2019-11-17",
//        "startTime": "08:00:00",
//        "endTime": "09:00:00",
//        "facId": [10, 11].toString()
//      },
      headers: headers,
      body: body,
    );
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print(response.body);
    }
  }

  _buildAlertDialog(
      String title, String content, String actionLeft, String actionRight) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        FlatButton(
          onPressed: () {},
          child: Text(
            actionLeft,
          ),
        ),
        FlatButton(
          onPressed: () {},
          child: Text(
            actionRight,
          ),
        ),
      ],
    );
  }

  _buildCupertinoAlertDialog(
      String title, String content, String actionLeft, String actionRight) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        CupertinoDialogAction(
          onPressed: () {},
          child: Text(
            actionLeft,
          ),
        ),
        CupertinoDialogAction(
          onPressed: () {},
          child: Text(
            actionRight,
          ),
        ),
      ],
    );
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
          'Confirm booking'.toUpperCase(),
          style: TextStyle(
            color: Colors.black54,
            fontSize: widget.isLargeScreen ? fontSizeH3[0] : fontSizeH3[1],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      widget.imgPath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      widget.type,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Date: ',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          startDateFormatted,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Schedule: ',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '$startTimeFormatted - $endTimeFormatted',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Expanded(
                      child: GridView.count(
                        childAspectRatio: 2.5,
                        crossAxisCount: 3,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        physics: ClampingScrollPhysics(),
                        children: List.generate(widget.code.length, (index) {
                          return Container(
//                            margin: EdgeInsets.fromLTRB(0.0, 4.0, 8.0, 4.0),
                            padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                            decoration: BoxDecoration(
                              color: Color(widget.colorCode),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: Text(
                                widget.code[index],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total price',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '${widget.totalPrice} Baht',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
//              SizedBox(
//                height: 2.0,
//              ),
              Divider(
                color: Colors.grey[700],
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.content_copy,
                        color: Colors.grey[700],
                      ),
                      iconSize: 16,
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(
                            text: fakeCardId,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Expanded(
                    child: RaisedButton(
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      color: Color(widget.colorCode),
                      onPressed: () {
                        _onStartCardEntryFlow();
//                  _onCardEntryComplete();
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 24.0,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        width: MediaQuery.of(context).size.width / 3,
                        child: Text(
                          'CHECK OUT',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 32.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isLoading = true;
  bool applePayEnabled = false;
  bool googlePayEnabled = false;

  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  Future<void> _onStartCardEntryFlow() async {
    print('_onStartCardEntryFlow');
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await InAppPayments.setSquareApplicationId(squareApplicationId);
    print('afterStartCardEntryFlow');
    await InAppPayments.startCardEntryFlow(
        onCardNonceRequestSuccess: _onCardEntryCardNonceRequestSuccess,
        onCardEntryCancel: _onCancelCardEntryFlow);
  }

  void _onCancelCardEntryFlow() {
    print('_onCancelCardEntryFlow');
  }

  void _onCardEntryCardNonceRequestSuccess(CardDetails result) async {
    try {
      print('success $result');
      reserveSeat();
      InAppPayments.completeCardEntry(
          onCardEntryComplete: _onCardEntryComplete);
    } on Exception catch (ex) {
      InAppPayments.showCardNonceProcessingError(ex.toString());
    }
  }

  void _onCardEntryComplete() {
    print('_onCardEntryComplete');
//    Navigator.push(
//      context,
//      MaterialPageRoute(
//        builder: (context) => HomePage(),
//      ),
//    );

//    showDialog(
//      context: context,
//      builder: (_) => _buildCupertinoAlertDialog(
//        'Booked complete',
//        '',
//        'No',
//        'Yes',
//      ),
//    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) {
//          return HomePage(
//            userName: 'eiei',
//            upComingBookingJson: _upComingBookingJson,
//            userId: _userId,
//          );
          return BookingCompletePage(
            userId: widget.userId,
            isLargeScreen: widget.isLargeScreen,
          );
        },
      ),
      ModalRoute.withName('/homePage'),
    );
//    Navigator.popUntil(
//      context,
//      ModalRoute.withName('/homePage'),
//    );
//    showDialog(
//      context: context,
//      builder: (_) => FlareGiffyDialog(
//        key: Key('success'),
//        flarePath: 'images/success_end.flr',
//        flareAnimation: 'Wait',
//        title: Text(
//          'Booking completed!'.toUpperCase(),
//          style: TextStyle(
//            fontSize: 22.0,
//            fontWeight: FontWeight.bold,
//          ),
//        ),
//        description: Text(
//          'Thank you.\n  Please remind that you must activate  \n  the room to use the facilities privided.',
//          textAlign: TextAlign.center,
//          style: TextStyle(
//            fontSize: 16.0,
//          ),
//        ),
//        buttonOkColor: Color(widget.colorCode),
//        buttonOkText: Text(
//          'Activate now'.toUpperCase(),
//          textAlign: TextAlign.center,
//          style: TextStyle(
//            letterSpacing: 1.5,
//            fontSize: 16.0,
//          ),
//        ),
//        buttonCancelText: Text(
//          'Done'.toUpperCase(),
//          textAlign: TextAlign.center,
//          style: TextStyle(
//            fontSize: 16.0,
//          ),
//        ),
//        onOkButtonPressed: () {
//          Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => ActivationPage()),
//          );
//        },
//      ),
//    );
  }
}
