class OrdersDetailsModel {
  Data? data;
  String? message;
  bool? success;

  OrdersDetailsModel({this.data, this.message, this.success});

  OrdersDetailsModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
    success = json['success'];
  }

}

class Data {
  int? id;
  Student? student;
  String? date;
  String? status;

  Data({this.id, this.student, this.date, this.status});

  Data.fromJson(Map<String, dynamic> json) {
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
