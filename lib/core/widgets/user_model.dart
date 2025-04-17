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
  String? token;
  User? user;

  Data({this.token, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

}

class User {
  int? id;
  String? name;
  String? email;
  String? phoneKey;
  String? phone;
  String? image;
  bool? isVerified;
  bool? isNotified;
  bool? isApple;

  User(
      {this.id,
        this.name,
        this.email,
        this.phoneKey,
        this.phone,
        this.image,
        this.isVerified,
        this.isNotified,
        this.isApple});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneKey = json['phone_key'];
    phone = json['phone'];
    image = json['image'];
    isVerified = json['isVerified'];
    isNotified = json['isNotified'];
    isApple = json['isApple'];
  }
}
