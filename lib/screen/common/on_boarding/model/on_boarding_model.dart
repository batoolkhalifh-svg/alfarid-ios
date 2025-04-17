class OnBoardingModel {
  List<Data>? data;
  String? message;
  bool? success;

  OnBoardingModel({this.data, this.message, this.success});

  OnBoardingModel.fromJson(Map<dynamic, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    message = json['message'];
    success = json['success'];
  }

 }

class Data {
  String? title;
  String? desc;
  String? image;

  Data({this.title, this.desc, this.image});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    desc = json['desc'];
    image = json['image'];
  }


}
