class Type {
  String roomTypeName;
  String roomTypeCapacity;
  int roomTypePrice;
  String type;
  String roomTypePic;
  Type(this.roomTypeName, this.roomTypeCapacity, this.roomTypePrice,
      this.type, this.roomTypePic);

  // named constructor
  Type.fromJson(Map<String, dynamic> json)
      : roomTypeName = json['name'],
        roomTypeCapacity = json['capacity'],
        roomTypePrice = json['price'];
  // type = json['type'],
  // roomTypePic = json['roomTypePic'];

  // method
  Map<String, dynamic> toJson() {
    return {
      'roomTypeName': roomTypeName,
      'roomCapacity': roomTypeCapacity,
      'roomPrice': roomTypePrice,
      // 'type': type,
    };
  }
}
