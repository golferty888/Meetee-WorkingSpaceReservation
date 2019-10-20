import 'package:flutter/material.dart';

class FacilityType {
  String typeId;
  String words;
  String imagePath;
  String typeName;
  Color primaryColor;
  int secondaryColorCode;
  Map categories;
  List equipment;

  FacilityType(
    this.typeId,
    this.words,
    this.imagePath,
    this.typeName,
    this.primaryColor,
    this.secondaryColorCode,
    this.categories,
    this.equipment,
  );
}
