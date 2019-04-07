class Room {
  String roomTypeName;
  int roomCapacity;
  int roomPrice;
  Room(this.roomTypeName, this.roomCapacity, this.roomPrice);

  // named constructor
  Room.fromJson(Map<String, dynamic> json)
      : roomTypeName = json['roomTypeName'],
        roomCapacity = json['roomCapacity'],
        roomPrice = json['roomPrice'];

  String show() {
    print(roomCapacity);
  }

  // method
  Map<String, dynamic> toJson() {
    return {
      'roomTypeName': roomTypeName,
      'roomCapacity': roomCapacity,
      'roomPrice': roomPrice,
    };
  }
}
