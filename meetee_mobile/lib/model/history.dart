import 'package:flutter/material.dart';

class FacilityType {
  String classId;
  String words;
  String imagePath;
  String typeName;
  Color primaryColor;
  int secondaryColorCode;
  Map categories;
  List equipment;

  FacilityType(
    this.classId,
    this.words,
    this.imagePath,
    this.typeName,
    this.primaryColor,
    this.secondaryColorCode,
    this.categories,
    this.equipment,
  );
}
