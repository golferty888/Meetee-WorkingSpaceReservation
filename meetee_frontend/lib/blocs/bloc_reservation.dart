import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meetee_frontend/blocs/bloc_provider.dart';
import 'package:meetee_frontend/model/Reservation.dart';

class BlocReservation implements BlocBase {
  Reservation reservation = Reservation('4', DateTime.now(), TimeOfDay.now(), TimeOfDay.now());
  // Reservation reservation;

  StreamController<Reservation> dateStreamController =
      StreamController<Reservation>.broadcast();

  BlocReservation() {
    // reservation.startDate = DateTime.now();
    dateStreamController.stream.listen(printDate);
  }

  @override
  void dispose() {
    dateStreamController.close();
  }


  reserveType(String type) {
    reservation.type = type;
    dateStreamController.sink.add(reservation);
  }

  reserveDate(DateTime date) {
    reservation.startDate = date;
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
