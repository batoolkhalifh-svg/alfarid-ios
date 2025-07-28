
class TimeTableModel {
  int? id;
  List<String>? days;
  String? timeFrom;
  String? timeTo;

  TimeTableModel({this.id, this.days, this.timeFrom, this.timeTo});

  TimeTableModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    days = json['days'].cast<String>();
    timeFrom = json['time_from'];
    timeTo = json['time_to'];
  }
}
