import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meetee_frontend/blocs/bloc_provider.dart';
import 'package:meetee_frontend/model/Reservation.dart';

import 'package:http/http.dart' as http;

class BlocReservation implements BlocBase {
  Reservation reservation = Reservation(
      '4',
      DateTime.now(),
      TimeOfDay.now(),
      TimeOfDay(
          hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute));
  // Reservation reservation;

  StreamController<Reservation> dateStreamController =
      StreamController<Reservation>.broadcast();

  BlocReservation() {
    // reservation.startDate = DateTime.now();
    dateStreamController.stream.listen(printDate);
    // dateStreamController.stream.listen(getAvailable);
  }

  @override
  void dispose() {
    dateStreamController.close();
  }

  Future<Null> getAvailableFromBloc() async {
    String urlAvail = 'http://18.139.5.203:9000/check/available';
    // final body = widget.reservation.toMap();
    print('Bloc');
    http.Response response = await http.post(urlAvail, body: reservation.toMap());
    if (response.statusCode == 200) {
      print('get from Bloc: $response.body');
      // this.setState(() {
      //   List list = json.decode(response.body)["availableList"];
      //   rooms = list.map((model) => Room.fromJson(model)).toList();
      // });
      // dateStreamController.sink.add(reservation);
    } else {
      print('fail Bloc');
      throw Exception('Failed to load post in Bloc');
    }
  }

  reserveType(String type) {
    reservation.type = type;
    dateStreamController.sink.add(reservation);
  }

  reserveDate(DateTime date) {
    reservation.startDate = date;
    // print('reserve date');
    // getAvailable();
    dateStreamController.sink.add(reservation);
  }

  reserveTimeStart(TimeOfDay timeStart) {
    reservation.startTime = timeStart;
    dateStreamController.sink.add(reservation);
  }

  reserveTimeEnd(TimeOfDay timeEnd) {
    reservation.endTime = timeEnd;
    dateStreamController.sink.add(reservation);
  }

  printDate(Reservation reservation) {
    print('$reservation');
  }
}
