class HelpAndSupportModel {
  Data? data;
  String? message;
  bool? success;

  HelpAndSupportModel({
    this.data,
    this.message,
    this.success,
  });

  HelpAndSupportModel.fromJson(
      Map<dynamic, dynamic> json) {
    data = json['data'] != null
        ? Data.fromJson(json['data'])
        : null;
    message = json['message'];
    success = json['success'];
  }
}

class Data {
  String? phone, phone1, phone2;
  String? email;
  String? whatsapp;

  Data({
    this.phone,
    this.phone1,
    this.phone2,
    this.email,
    this.whatsapp,
  });

  Data.fromJson(Map<String, dynamic> json) {
    if (json['phone'] != null &&
        json['phone'] is List) {
      final phones = json['phone'] as List;

      final normalPhones = phones
          .where((e) => e['type'] == 'phone')
          .toList();

      final whatsappPhones = phones
          .where((e) => e['type'] == 'whatsapp')
          .toList();

      phone = normalPhones.isNotEmpty
          ? normalPhones[0]['phone']
          : null;

      phone1 = normalPhones.length > 1
          ? normalPhones[1]['phone']
          : null;

      whatsapp = whatsappPhones.isNotEmpty
          ? whatsappPhones[0]['phone']
          : null;

      phone2 = whatsappPhones.length > 1
          ? whatsappPhones[1]['phone']
          : null;
    }

    email = json['email'];
  }
}