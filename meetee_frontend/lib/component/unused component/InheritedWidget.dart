import 'package:flutter/material.dart';
import 'package:meetee_frontend/model/Reservation.dart';

class InheritedDataProvider extends InheritedWidget {
  final Reservation reservation;

  InheritedDataProvider({
    Widget child,
    this.reservation,
  }) : super(child: child);

  @override
  bool updateShouldNotify(InheritedDataProvider oldWidget) =>
      reservation != oldWidget.reservation;
  static InheritedDataProvider of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(InheritedDataProvider);
}
