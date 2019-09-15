import 'package:flutter/material.dart';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:meetee_frontend/blocs/bloc_provider.dart';
import 'package:meetee_frontend/blocs/bloc_reservation.dart';

import 'package:meetee_frontend/component/RoomSelectionPanels.dart';
import 'package:meetee_frontend/component/SeatSelectionPanels.dart';
import 'package:meetee_frontend/component/History.dart';
// void main() => runApp(MaterialApp(
//       home: BlocProvider(
//           bloc: BlocReservation(),
//           child: MeeteeApp(),
//         )
//       // home: MeeteeApp(),
//     ));

void main() => runApp(BlocProvider(
      bloc: BlocReservation(),
      child: MaterialApp(
        home: MeeteeApp(),
      ),
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
      theme: ThemeData(primaryColor: Color(0xFF2979ff)),
      // theme: ThemeData(primaryColor: Colors.purple[900]),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            leading: IconButton(
              onPressed: () {
                // controller.fling(velocity: isPanelVisible ? -1.0 : 1.0);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => history(),
                    ));
              },
              icon: AnimatedIcon(
                icon: AnimatedIcons.close_menu, // can change to arrow menu
                progress: controller.view,
              ),
            ),
            title: Container(
              // color: Colors.purpleAccent[900],
              // color: Colors.purpleAccent[900],
              height: 60.0,
              alignment: Alignment.center,
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BubbleTabIndicator(
                  indicatorHeight: 30.0,
                  indicatorColor: Color(0xFFFF6F61),
                  // indicatorColor: Colors.red[700],
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
