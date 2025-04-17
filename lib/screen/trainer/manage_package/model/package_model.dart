class MyPackageModel {
  Data? data;
  String? message;
  bool? success;

  MyPackageModel({this.data, this.message, this.success});

  MyPackageModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
    success = json['success'];
  }
}

class Data {
  int? id;
  Plan? plan;
  double? price;
  int? duration;
  double? total;
  String? startDate;
  String? endDate;
  int? remainingDays;

  Data(
      {this.id,
        this.plan,
        this.price,
        this.duration,
        this.total,
        this.startDate,
        this.endDate,
        this.remainingDays});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    plan = json['plan'] != null ? Plan.fromJson(json['plan']) : null;
    price = json['price'];
    duration = json['duration'];
    total = json['total'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    remainingDays = json['remaining_days'];
  }

}

class Plan {
  int? id;
  String? name;

  Plan({this.id, this.name});

  Plan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

}
