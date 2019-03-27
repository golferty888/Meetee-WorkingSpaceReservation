import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // date form
// import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
// import 'dart:async';
// import 'dart:convert';
import 'package:numberpicker/numberpicker.dart'; //number picker

void main() => runApp(MyApp());

final dummySnapshot = [
  {"name": "Filip", "votes": 15},
  {"name": "Abraham", "votes": 14},
  {"name": "Richard", "votes": 11},
  {"name": "Ike", "votes": 10},
  {"name": "Justin", "votes": 1},
];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baby Names',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Baby Name Votes')),
      body: _buildBody(context),
      bottomNavigationBar: RaisedButton(
          color: Colors.greenAccent,
          child: Text('Reserve !'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CustomerDemand()),
            );
          }),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('baby').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(record.name),
          trailing: Text(record.votes.toString()),
          onTap: () => record.reference.updateData({'votes': record.votes + 1}),
          // onTap: () => Firestore.instance.runTransaction((transaction) async {
          //       final freshSnapshot = await transaction.get(record.reference);
          //       final fresh = Record.fromSnapshot(freshSnapshot);

          //       await transaction
          //           .update(record.reference, {'votes': fresh.votes + 1});
          //     }),
        ),
      ),
    );
  }
}

class Record {
  final String name;
  final int votes;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['votes'] != null),
        name = map['name'],
        votes = map['votes'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$votes>";
}

class CustomerDemand extends StatefulWidget {
  @override
  _CustomerDemandState createState() => _CustomerDemandState();
}

class _CustomerDemandState extends State<CustomerDemand> {
  DateTime _date = DateTime.now();
  TimeOfDay _time_start = TimeOfDay.now();
  TimeOfDay _time_end = TimeOfDay.now();

  int _currentValue = 1;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime(2020));
    if (picked != null) {
      print('Selected date: ' + DateFormat('yyyy-MM-dd').format(_date));
      setState(() {
        _date = picked;
      });
    }
  }

  Future<Null> _selectTimeStart(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time_start,
    );
    if (picked != null) {
      print('Selected date: ${_time_start.toString()}');
      setState(() {
        _time_start = picked;
      });
    }
  }

  Future<Null> _selectTimeEnd(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time_end,
    );
    if (picked != null) {
      print('Selected date: ${_time_end.toString()}');
      setState(() {
        _time_end = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Demand'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title:
                Text('Date start: ' + DateFormat('yyyy-MM-dd').format(_date)),
            subtitle: RaisedButton(
              child: Text('Select date'),
              onPressed: () {
                _selectDate(context);
              },
            ),
          ),
          ListTile(
            title: Text('Time start: ${_time_start.toString()}'),
            subtitle: RaisedButton(
              child: Text('Select time'),
              onPressed: () {
                _selectTimeStart(context);
              },
            ),
          ),
          ListTile(),
          ListTile(
            title: Text('Date end: ' + DateFormat('yyyy-MM-dd').format(_date)),
            subtitle: RaisedButton(
              child: Text('Select date'),
              onPressed: () {
                _selectDate(context);
              },
            ),
          ),
          ListTile(
            title: Text('Time end: ${_time_end.toString()}'),
            subtitle: RaisedButton(
              child: Text('Select time'),
              onPressed: () {
                _selectTimeEnd(context);
              },
            ),
          ),
          ListTile(),
          ListTile(
              title: Text('Choose room type'),
              subtitle: Row(
                children: <Widget>[
                  NumberPicker.integer(
                      initialValue: _currentValue,
                      minValue: 0,
                      maxValue: 100,
                      onChanged: (newValue) =>
                          setState(() => _currentValue = newValue)),
                  new Text("Number of person: $_currentValue"),
                ],
              )),
          ListTile(),
          ListTile(
            title: Text('Choose seat type'),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  child: Text('Single Table'),
                  onPressed: () {},
                ),
                RaisedButton(
                  child: Text('Meeting Room'),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
      // bottomNavigationBar: RaisedButton(
      //   color: Colors.greenAccent,
      //   child: Text('Reserve !'),
      //   onPressed: () {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) => Summary(
      //                   seatType: '${widget.seatType}',
      //                   date: DateFormat('yyyy-MM-dd').format(_date),
      //                   time_start: '${_time_start.toString()}',
      //                   time_end: '${_time_end.toString()}',
      //                 )));
      //   },
      // ),
    );
  }
}
