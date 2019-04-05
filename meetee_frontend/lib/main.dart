import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // date form
import 'package:http/http.dart' as http;
// import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'dart:async';
import 'dart:convert'; // JSON
import 'package:flutter_calendar/flutter_calendar.dart';

import 'package:meetee_frontend/component/CustomerDemand.dart';

import 'package:meetee_frontend/model/Person.dart';

// import 'package:meetee_frontend/component/Vote.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meetee',
      home: CustomerDemand(),
    );
  }
}
