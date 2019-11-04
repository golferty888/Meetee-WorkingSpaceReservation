import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

class PeriodPicker extends StatefulWidget {
  final ValueChanged<DateTime> returnStartTime;
  final ValueChanged<DateTime> returnEndTime;

  PeriodPicker({
    Key key,
    this.returnStartTime,
    this.returnEndTime,
  }) : super(key: key);
  @override
  _PeriodPickerState createState() => _PeriodPickerState();
}

class _PeriodPickerState extends State<PeriodPicker> {
  int hourNow = DateTime.now().hour;
  int startTime = DateTime.now().hour + 1;
  int endTime = DateTime.now().hour + 2;

  showPickerNumber(BuildContext context) {
    Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: hourNow + 1, end: 21),
          NumberPickerColumn(begin: hourNow + 2, end: 22),
        ]),
        delimiter: [
          PickerDelimiter(
            child: Container(
              width: 30.0,
              alignment: Alignment.center,
              child: Text('to'),
            ),
          )
        ],
        changeToFirst: false,
        hideHeader: true,
        title: new Text("Please Select"),
        onConfirm: (Picker picker, List value) {
          setState(() {
            startTime = picker.getSelectedValues()[0];
            endTime = picker.getSelectedValues()[1];
          });
          print(picker.getSelectedValues());
          print(startTime);
          print(endTime);
        }).showDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(4.0, 8.0, 24.0, 8.0),
//      margin: EdgeInsets.all(8.0),
//      height: 72.0,
      child: GestureDetector(
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Time',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
              Text(
                '${startTime.toString()}:00 - ${endTime.toString()}:00',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
        onTap: () => showPickerNumber(context),
      ),
    );
  }
}
