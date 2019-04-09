import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // date form
import 'package:http/http.dart' as http;
// import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'dart:async';
import 'dart:convert'; // JSON
import 'package:flutter_calendar/flutter_calendar.dart';

// import 'package:meetee_frontend/component/SeatSelection.dart';
import 'package:meetee_frontend/component/RoomSelectionPanels.dart';
import 'package:meetee_frontend/component/AvailableSeat.dart';
import 'package:meetee_frontend/component/SeatSelectionPanels.dart';

import 'package:meetee_frontend/model/Person.dart';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
// import 'package:meetee_frontend/component/Vote.dart';

void main() => runApp(MaterialApp(
      home: MeeteeApp(),
    ));

class MeeteeApp extends StatefulWidget {
  @override
  _MeeteeAppState createState() => _MeeteeAppState();
}

class _MeeteeAppState extends State with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 100), value: 1.0);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  bool get isPanelVisible {
    final AnimationStatus status = controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.purple[700]),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            leading: IconButton(
              onPressed: () {
                controller.fling(velocity: isPanelVisible ? -1.0 : 1.0);
              },
              icon: AnimatedIcon(
                icon: AnimatedIcons.close_menu, // can change to arrow menu
                progress: controller.view,
              ),
            ),
            title: Container(
              color: Colors.purple[700],
              height: 60.0,
              alignment: Alignment.center,
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BubbleTabIndicator(
                  indicatorHeight: 30.0,
                  indicatorColor: Colors.red,
                  tabBarIndicatorSize: TabBarIndicatorSize.tab,
                ),
                tabs: [
                  Text('Seat'),
                  Text('Room'),
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              SeatSelection(
                controller: controller,
              ),
              RoomSelection(
                controller: controller,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
