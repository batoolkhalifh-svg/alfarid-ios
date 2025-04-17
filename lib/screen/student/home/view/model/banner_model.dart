class BannersModel {
  List<Data>? data;
  String? message;
  bool? success;

  BannersModel({this.data, this.message, this.success});

  BannersModel.fromJson(Map<dynamic, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add( Data.fromJson(v));
      });
    }
    message = json['message'];
    success = json['success'];
  }

}

class Data {
  int? id;
  String? image;

  Data({this.id, this.image});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }

}
