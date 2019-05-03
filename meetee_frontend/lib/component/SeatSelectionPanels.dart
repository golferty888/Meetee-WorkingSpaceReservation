import 'package:flutter/material.dart';
import 'package:meetee_frontend/component/DatePicker.dart';
import 'package:meetee_frontend/component/TypeList.dart';
import 'package:meetee_frontend/component/TimePicker.dart';

import 'package:meetee_frontend/model/Reservation.dart';

class SeatSelection extends StatefulWidget {
  final AnimationController controller;
  // final DateTime dateStart;
  // Reservation reservation;

  SeatSelection({this.controller,});
  // SeatSelection({this.controller, this.dateStart});

  @override
  _SeatSelectionState createState() => _SeatSelectionState();
}

class _SeatSelectionState extends State<SeatSelection> {
  static const header_height = 32.0;
  DateTime dateStart;
  // DatePicker datePicker;

  @override
  void initState() {
    super.initState();
    dateStart = DateTime.now();
  }

  callback(newDateStart) {
    print('sdf' + newDateStart.toString());
    setState(() {
      dateStart = newDateStart;
      print('dateStart: ' + dateStart.toString());
    });
  }

  // final reservation = Reservation();

  Animation<RelativeRect> getPanelAnimation(BoxConstraints constraints) {
    final height = constraints.biggest.height;
    // final backPanelHeight = 400.0;
    final backPanelHeight = height - header_height;
    final frontPanelHeight = -header_height;

    return new RelativeRectTween(
            begin: RelativeRect.fromLTRB(
                0.0, backPanelHeight, 0.0, frontPanelHeight),
            end: RelativeRect.fromLTRB(0.0, 192.0, 0.0, 0.0))
        .animate(
            CurvedAnimation(parent: widget.controller, curve: Curves.linear));
  }

  Widget bothPanels(BuildContext context, BoxConstraints constraints) {
    final ThemeData theme = Theme.of(context);

    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            color: theme.primaryColor,
            child: ListView(
              children: <Widget>[
                // Card(
                //   child: ListTile(
                //     leading: Icon(IconData(59389, fontFamily: 'MaterialIcons')),
                //     title: TextField(keyboardType: TextInputType.number),
                //   ),
                //   elevation: 0.0,
                //   margin: EdgeInsets.only(left: 16, right: 16),
                // ),
                Card(
                  child: ListTile(
                      leading:
                          Icon(IconData(59670, fontFamily: 'MaterialIcons')),
                      title: DatePicker(dateStart, callback)),
                  elevation: 0.0,
                  margin: EdgeInsets.only(left: 16, right: 16),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(IconData(58402, fontFamily: 'MaterialIcons')),
                    title: TimePicker(type: 'start'),
                  ),
                  elevation: 0.0,
                  margin: EdgeInsets.only(left: 16, right: 16, top: 8),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(IconData(58402, fontFamily: 'MaterialIcons')),
                    title: TimePicker(type: 'end'),
                  ),
                  elevation: 0.0,
                  margin: EdgeInsets.only(left: 16, right: 16, top: 8),
                ),
              ],
            ),
          ),
          PositionedTransition(
            rect: getPanelAnimation(constraints),
            child: Material(
              color: Colors.white,
              // elevation: 12.0,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    height: header_height,
                    child: Center(
                      child: Text('Select Seat Type',
                          style: Theme.of(context).textTheme.button),
                    ),
                  ),
                  Container(
                    child: Text(dateStart.toString()),
                  ),
                  Expanded(
                      child: SeatType(
                    type: 'seat',
                    dateStart: dateStart,
                  ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: bothPanels,
    );
  }
}
