class UserModel {
  Data? data;
  String? message;
  bool? success;

  UserModel({this.data, this.message, this.success});

  UserModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
    success = json['success'];
  }
}

class Data {
  int? id;
  String? name;
  String? email;
  String? phoneKey;
  String? phone;
  String? image;
  bool? isVerified;
  bool? isNotified;
  Classroom? classroom;

  Data(
      {this.id,
        this.name,
        this.email,
        this.phoneKey,
        this.phone,
        this.image,
        this.isVerified,
        this.isNotified,
        this.classroom});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneKey = json['phone_key'];
    phone = json['phone'];
    image = json['image'];
    isVerified = json['isVerified'];
    isNotified = json['isNotified'];
    classroom = json['classroom'] != null
        ?  Classroom.fromJson(json['classroom'])
        : null;
  }

}

class Classroom {
  int? id;
  String? name;

  Classroom({this.id, this.name});

  Classroom.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}
