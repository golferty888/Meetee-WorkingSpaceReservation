class FacilitiesList {
  final List<Facility> facilities;

  FacilitiesList({
    this.facilities,
  });

  factory FacilitiesList.fromJson(List<dynamic> parsedJson) {
    List<Facility> facilities = List<Facility>();
    facilities = parsedJson.map((i) => Facility.fromJson(i)).toList();

    return FacilitiesList(facilities: facilities);
  }
}

class Facility {
  int facId = 0;
  String code = '';
  String floor = '';
  int cateId = 0;
  String status = '';

  Facility({
    this.facId,
    this.code,
    this.floor,
    this.cateId,
    this.status,
  });

  factory Facility.fromJson(Map<dynamic, dynamic> json) => Facility(
      facId: json['facId'],
      code: json['code'],
      floor: json['floor'],
      cateId: json['cateId'],
      status: json['status']);

//  @override
//  String toString() {
//    return 'facId: $facId\nfacCode: $facCode'
//        '\nfloor: $floor'
//        '\nfacilityCategoryId: $facilityCategoryId'
//        '\nstatus: $status';
//  }
}
