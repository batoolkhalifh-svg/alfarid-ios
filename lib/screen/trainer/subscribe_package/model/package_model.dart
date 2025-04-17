class PackagesModel {
  List<Data>? data;
  String? message;
  bool? success;

  PackagesModel({this.data, this.message, this.success});

  PackagesModel.fromJson(Map<dynamic, dynamic> json) {
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
  String? name;
  double? price;
  List<String>? features;
  int? durationInMonths;

  Data({this.id, this.name, this.price, this.features, this.durationInMonths});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    features = json['features'].cast<String>();
    durationInMonths = json['duration_in_months'];
  }
}
