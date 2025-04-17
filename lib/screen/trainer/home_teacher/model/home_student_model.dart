class StudentsHomeModel {
  Data? data;
  String? message;
  bool? success;

  StudentsHomeModel({this.data, this.message, this.success});

  StudentsHomeModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
    success = json['success'];
  }

}

class Data {
  List<Reservations>? reservations;
  int? reservationsCount;
  int? courses;

  Data({this.reservations, this.reservationsCount, this.courses});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['reservations'] != null) {
      reservations = <Reservations>[];
      json['reservations'].forEach((v) {
        reservations!.add(Reservations.fromJson(v));
      });
    }
    reservationsCount = json['reservations_count'];
    courses = json['courses'];
  }
}

class Reservations {
  int? id;
  Student? student;
  String? date;
  String? status;

  Reservations({this.id, this.student, this.date, this.status});

  Reservations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    student =
    json['student'] != null ? Student.fromJson(json['student']) : null;
    date = json['date'];
    status = json['status'];
  }

}

class Student {
  String? name;
  String? image;
  String? classroom;

  Student({this.name, this.image, this.classroom});

  Student.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    classroom = json['classroom'];
  }

}
