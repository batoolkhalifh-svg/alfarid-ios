  class PriceModel {
  Data? data;
  String? message;
  bool? success;

  PriceModel({this.data, this.message, this.success});

  PriceModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
    message = json['message'];
    success = json['success'];
  }

}

class Data {
  dynamic couponValue;
  dynamic price;
  dynamic tax;
  dynamic totalPrice;
  dynamic deliveryPrice;
  String? moyasarKey;

  Data.fromJson(Map<String, dynamic> json) {
    couponValue = json['coupon_value'];
    price = json['price'];
    tax = json['tax'];
    totalPrice = json['total_price'];
    deliveryPrice = json['delivery_price'];
    moyasarKey=json['moyasar_key'];
  }
}
