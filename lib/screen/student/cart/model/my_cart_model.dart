class MyCartModel {
  dynamic data;
  String? message;
  bool? success;

  MyCartModel({this.data, this.message, this.success});

  MyCartModel.fromJson(Map<dynamic, dynamic> json) {
    if (json['data'] is Map<String, dynamic>) {
      data = Data.fromJson(json['data']);
    } else {
      data = null;
    }
    message = json['message'];
    success = json['success'];
  }
}

class Data {
  int? id;
  int? total;
  int? totalAfterDiscount;
  int? discount;
  List<Items>? items;

  Data(
      {this.id,
        this.total,
        this.totalAfterDiscount,
        this.discount,
        this.items});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    total = json['total'];
    totalAfterDiscount = json['total_after_discount'];
    discount = json['discount'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }


}

class Items {
  int? id;
  String? name;
  String? image;
  int? price;

  Items({this.id, this.name, this.image, this.price});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    price = json['price'];
  }

}
