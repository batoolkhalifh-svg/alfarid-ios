class BannersModel {
  Data? data;
  String? message;
  bool? success;

  BannersModel({this.data, this.message, this.success});

  BannersModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
    success = json['success'];
  }
}

class Data {
  List<Banners>? banners;
  int? notificationsCount;

  Data({this.banners, this.notificationsCount});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners!.add(new Banners.fromJson(v));
      });
    }
    notificationsCount = json['notifications_count']??0;
  }
}

class Banners {
  int? id;
  String? image;

  Banners({this.id, this.image});

  Banners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }
}
