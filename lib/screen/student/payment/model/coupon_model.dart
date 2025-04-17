class CouponModel {
  Data? data;
  String? message;
  bool? success;

  CouponModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
    success = json['success'];
  }
}

class Data {
  String? moyasarKey;
  dynamic couponValue;
  dynamic price;
  dynamic tax;
  dynamic totalPrice;
  dynamic deliveryPrice;

  Data.fromJson(Map<String, dynamic> json) {
    moyasarKey = json['moyasar_key'];
    couponValue = json['coupon_value'];
    price = json['price'];
    tax = json['tax'];
    totalPrice = json['total_price'];
    deliveryPrice = json['delivery_price'];
  }
}
