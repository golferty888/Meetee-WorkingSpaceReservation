class Room {
  String roomTypeName;
  int roomTypeCapacity;
  int roomTypePrice;
  String type;
  String roomTypePic;
  Room(this.roomTypeName, this.roomTypeCapacity, this.roomTypePrice, this.type,
      this.roomTypePic);

  // named constructor
  Room.fromJson(Map<String, dynamic> json)
      : roomTypeName = json['roomTypeName'],
        roomTypeCapacity = json['roomTypeCapacity'],
        roomTypePrice = json['roomTypePrice'],
        type = json['type'],
        roomTypePic = json['roomTypePic'];

  String show() {
    print(roomTypePic);
  }

  // method
  Map<String, dynamic> toJson() {
    return {
      'roomTypeName': roomTypeName,
      'roomCapacity': roomTypeCapacity,
      'roomPrice': roomTypePrice,
      'type': type,
    };
  }
}
