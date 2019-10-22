import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:meetee_mobile/config.dart';

class Summary extends StatefulWidget {
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
    this.startDate,
    this.startTime,
    this.endTime,
    this.facId,
    this.type,
    this.code,
    this.totalPrice,
    this.imgPath,
    this.index,
  }) : super(key: key);
  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  final String userId = '1';
  final String reserveURL = 'http://18.139.12.132:9000/reserve';

  String startDateFormatted;
  String startTimeFormatted;
  String endTimeFormatted;

  @override
  void initState() {
    super.initState();
    startDateFormatted = DateFormat("dd MMMM yyy").format(widget.startDate);
    startTimeFormatted = DateFormat("HH:00").format(widget.startTime);
    endTimeFormatted = DateFormat("HH:00").format(widget.endTime);

    //    _initSquarePayment();

//    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  Future<dynamic> reserveSeat() async {
    final response = await http.post(
      reserveURL,
      body: {
        "userId": userId,
        "facId": widget.facId,
        "startDate": widget.startDate,
        "startTime": widget.startTime,
        "endTime": widget.endTime,
      },
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(jsonData);
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.5,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Confirm booking',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(),
              ),
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.network(
                    widget.imgPath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
//                  width: 240.0,
//                  height: 224.0,

                child: Container(
                  margin: EdgeInsets.fromLTRB(72.0, 24.0, 32.0, 0.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          16.0,
                          8.0,
                          16.0,
                          8.0,
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Text(
                                'Date',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text(
                                '$startDateFormatted',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16.0,
                          8.0,
                          16.0,
                          8.0,
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Text(
                                'Time',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text(
                                '$startTimeFormatted - $endTimeFormatted',
                                style: TextStyle(
                                  fontSize: 16.00,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16.0,
                          8.0,
                          16.0,
                          8.0,
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Text(
                                'Type',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text(
                                '${widget.type}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16.0,
                          8.0,
                          16.0,
                          8.0,
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Text(
                                'Code',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text(
                                '${widget.code}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16.0,
                          8.0,
                          16.0,
                          8.0,
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Text(
                                'Quantity',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text(
                                '${widget.code.length}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16.0,
                          8.0,
                          16.0,
                          8.0,
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Text(
                                'Price',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text(
                                '${widget.totalPrice} Baht',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              RaisedButton(
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                color: Color(widget.colorCode),
                onPressed: () {
//                  reserveSeat();
//                  showDialog(
//                    context: context,
//                    builder: (BuildContext context) => CustomDialog(
//                      colorCode: widget.colorCode,
//                      title: "Book",
//                      buttonTextLeft: "Keep booking",
//                      buttonTextRight: "Done",
//                    ),
//                  );
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                      builder: (context) => PaymentPage(),
//                    ),
//                  );

                  _onStartCardEntryFlow();
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
              Expanded(
                child: Container(),
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
//    await InAppPayments.setSquareApplicationId(squareApplicationId);
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
      InAppPayments.completeCardEntry(
          onCardEntryComplete: _onCardEntryComplete);
    } on Exception catch (ex) {
      InAppPayments.showCardNonceProcessingError(ex.toString());
    }
  }

  void _onCardEntryComplete() {
    print('_onCardEntryComplete');
  }
}
