import 'package:flutter/material.dart';
import 'package:meetee_frontend/component/AvailableSeat.dart';
import 'package:meetee_frontend/component/TimePicker.dart';
import 'package:meetee_frontend/main.dart';
import 'package:meetee_frontend/model/Reservation.dart';
import 'package:meetee_frontend/component/DatePicker.dart';

class AvailablePanels extends StatefulWidget {
  final Reservation reservation;
  final String type;
  final String typeName;

  AvailablePanels(this.reservation, this.type, this.typeName);

  @override
  _AvailablePanelsState createState() => _AvailablePanelsState();
}

class _AvailablePanelsState extends State<AvailablePanels> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        // title: DatePicker(),
        title: Row(
          children: <Widget>[
            // DatePicker(),
            // DatePicker(),
            Expanded(
              child: Container(
                  // decoration: BoxDecoration(
                  //     border: Border(
                  //         right: new BorderSide(
                  //             width: 0.5, color: Colors.black87))),
                  child: DatePicker(
                    format: 'tab',
                  )),
            ),
            Expanded(
              child: TimePicker(
                type: 'start',
                format: 'tab',
              ),
            ),
            Flexible(
              child: Text('  -  '),
            ),
            Expanded(
              child: TimePicker(
                type: 'end',
                format: 'tab',
              ),
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      // Available(snapshot.data, widget.type),
                      MeeteeApp()),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: LayoutBuilder(
        builder: _frontPanel,
      ),
    );
  }

  static const _PANEL_HEADER_HEIGHT = 64.0;
  final int roomCount = 50;

  Widget _frontPanel(BuildContext context, BoxConstraints constraints) {
    String name = widget.type;
    if (roomCount > 1) {
      name = name + 's';
    }
    final ThemeData theme = Theme.of(context);
    return Container(
      color: theme.primaryColor,
      child: Stack(
        children: <Widget>[
          //  Center(
          //   child:  Text("base"),
          // ),
          Material(
            borderRadius: const BorderRadius.only(
                topLeft: const Radius.circular(16.0),
                topRight: const Radius.circular(16.0)),
            elevation: 0.0,
            child: Column(children: <Widget>[
              Container(
                child: ListTile(
                  title: Text(
                    widget.typeName,
                  ),
                  subtitle: Text('50 ' + name + ' available'),
                  // contentPadding: EdgeInsets.all(0),
                  onTap: () {},
                ),
                height: _PANEL_HEADER_HEIGHT,
              ),
              //  Container(
              //   height: _PANEL_HEADER_HEIGHT,
              //   child:  Center(child:  Text(widget.type)),
              // ),
              Expanded(child: Available(widget.reservation, widget.type))
            ]),
          ),
        ],
      ),
    );
  }
}
