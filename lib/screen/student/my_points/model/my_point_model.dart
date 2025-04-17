class MyPointModel {
  Data? data;
  String? message;
  bool? success;

  MyPointModel({this.data, this.message, this.success});

  MyPointModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
    success = json['success'];
  }
}

class Data {
  List<WeekPoints>? weekPoints;
  List<WeekPoints>? monthPoints;

  Data({this.weekPoints, this.monthPoints});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['week_points'] != null) {
      weekPoints = <WeekPoints>[];
      json['week_points'].forEach((v) {
        weekPoints!.add(WeekPoints.fromJson(v));
      });
    }
    if (json['month_points'] != null) {
      monthPoints = <WeekPoints>[];
      json['month_points'].forEach((v) {
        monthPoints!.add(WeekPoints.fromJson(v));
      });
    }
  }
}

class WeekPoints {
  String? score;
  Student? student;

  WeekPoints({this.score, this.student});

  WeekPoints.fromJson(Map<String, dynamic> json) {
    score = json['score'];
    student =
    json['student'] != null ? Student.fromJson(json['student']) : null;
  }

}

class Student {
  String? name;
  String? image;

  Student({this.name, this.image});

  Student.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
  }

}
