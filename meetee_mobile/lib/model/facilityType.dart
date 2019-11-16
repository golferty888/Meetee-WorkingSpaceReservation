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

List<FacilityType> facilityTypeList = [
  FacilityType(
    '2',
    'Chill\nRelax\nPrivate',
    'images/facilityType/person.svg',
    'Private seat',
    Colors.yellow[900],
    0xFFFAD74E,
    {
      'Single chair': {
        'cateImage': 'images/category/seat/single_chair.jpg',
        'cateIcon': '',
        'cateId': '4',
        'capacity': 1,
        'price': 30,
      },
      'Bar chair': {
        'cateImage': 'images/category/seat/bar_chair.jpg',
        'cateId': '5',
        'capacity': 1,
        'price': 30,
      },
      'Single sofa': {
        'cateImage': 'images/category/seat/single_sofa.jpg',
        'cateId': '6',
        'capacity': 1,
        'price': 40,
      },
      'Twin sofa': {
        'cateImage': 'images/category/seat/twin_sofa.jpg',
        'cateIcon': 'images/categoryIcon/twin-sofa.svg',
        'cateId': '7',
        'capacity': 2,
        'price': 60,
      },
    },
    [
      '1-2 PERSONS',
      'Wi-Fi',
      'Power bar',
    ],
  ),
  FacilityType(
    '1',
    'Mate\nTeamwork\nCollaboration',
    'images/facilityType/meeting.svg',
    'Meeting room',
    Colors.red[800],
    0xFFFF8989,
    {
      'Small room': {
        'cateImage': 'images/category/room/room_s.jpg',
        'cateId': '1',
        'capacity': 4,
        'price': 120,
      },
      'Medium room': {
        'cateImage': 'images/category/room/room_m.jpg',
        'cateId': '2',
        'capacity': 8,
        'price': 250,
      },
      'Large room': {
        'cateImage': 'images/category/room/room_l.jpg',
        'cateId': '3',
        'capacity': 12,
        'price': 400,
      },
    },
    [
      '4-12 PERSONS',
      'Wi-Fi',
      'Apple TV',
    ],
  ),
  FacilityType(
    '3',
    'Strategy\nDiscussion\nCooperation',
    'images/facilityType/strategy.svg',
    'Seminar room',
    Colors.deepPurple,
    0xFF92D2FC,
    {
      'Hall room': {
        'cateImage': 'images/category/seminar/seminar.jpg',
        'cateId': '8',
        'capacity': 30,
        'price': 950,
      },
    },
    [
      '30 PERSONS',
      'Wi-Fi',
      'Whiteboard & Pen',
    ],
  ),
];
