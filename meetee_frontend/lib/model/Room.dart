class Room {
  String roomName;
  String roomCapacity;
  int roomPrice;
  String type;
  String roomPic;
  Room(this.roomName, this.roomCapacity, this.roomPrice, this.type,
      this.roomPic);

  // named constructor
  Room.fromJson(Map<String, dynamic> json) : roomName = json['code'];
  // roomCapacity = json['capacity'],
  // roomPrice = json['price'];
  // type = json['type'],
  // roomPic = json['roomTypePic'];

  // method
  // Map<String, dynamic> toJson() {
  //   return {
  //     'roomTypeName': roomName,
  //     'roomCapacity': roomCapacity,
  //     'roomPrice': roomPrice,
  //     'type': type,
  //   };
  // }
}
