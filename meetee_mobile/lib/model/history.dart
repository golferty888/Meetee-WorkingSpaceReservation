class HistoriesList {
  final List<History> histories;

  HistoriesList({
    this.histories,
  });

  factory HistoriesList.fromJson(List<dynamic> parsedJson) {
    List<History> histories = List<History>();
    histories = parsedJson.map((i) => History.fromJson(i)).toList();

    return HistoriesList(histories: histories);
  }
}

class History {
  int id;
  int facId;
  String startTime;
  String endTime;
  String status;

  History({this.id, this.facId, this.startTime, this.endTime, this.status});

  factory History.fromJson(Map<dynamic, dynamic> json) => History(
        id: json['id'],
        facId: json['facility_id'],
        startTime: json['start_time'],
        endTime: json['end_time'],
        status: json['status'],
      );
}
