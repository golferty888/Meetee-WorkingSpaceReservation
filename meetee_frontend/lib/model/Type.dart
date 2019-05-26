class Type {
  String roomTypeName;
  String roomTypeCapacity;
  int roomTypePrice;
  int roomTypeId;
  String roomTypePic;
  Type(this.roomTypeName, this.roomTypeCapacity, this.roomTypePrice,
      this.roomTypeId, this.roomTypePic);

  // named constructor
  Type.fromJson(Map<String, dynamic> json)
      : roomTypeName = json['name'],
        roomTypeCapacity = json['capacity'],
        roomTypePrice = json['price'],
        roomTypeId = json['id'],
        roomTypePic = json['url'];

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
