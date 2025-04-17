class HelpAndSupportModel {
  Data? data;
  String? message;
  bool? success;

  HelpAndSupportModel({this.data, this.message, this.success});

  HelpAndSupportModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
    message = json['message'];
    success = json['success'];
  }
}

class Data {
  String? phone;
  String? email;
  String? whatsapp;

  Data({this.phone, this.email, this.whatsapp});

  Data.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    email = json['email'];
    whatsapp = json['whatsapp'];
  }

}
