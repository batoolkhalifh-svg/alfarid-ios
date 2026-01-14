class OrdersDetailsModel {
  Data? data;
  String? message;
  bool? success;

  OrdersDetailsModel({this.data, this.message, this.success});

  OrdersDetailsModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
    success = json['success'];
  }
}

class Data {
  int? id;
  Student? student;
  String? date;
  List<Slot> slots = [];  // قائمة slots بدل timeFrom/timeTo مباشرة
  String? paymentStatus;
  int? price;
  String? status;
  Map<String, List<String>> uploadedFiles = {}; // تم تهيئتها فارغة بدل nullable

  Data({
    this.id,
    this.student,
    this.date,
    this.slots = const [],
    this.paymentStatus,
    this.price,
    this.status,
    this.uploadedFiles = const {},
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    student = json['student'] != null ? Student.fromJson(json['student']) : null;
    date = json['date'];

    if (json['slots'] != null) {
      slots = (json['slots'] as List).map((e) => Slot.fromJson(e)).toList();
    }

    paymentStatus = json['payment_status'];
    price = json['price'];
    status = json['status'];

    // 🔹 تحويل uploaded_files بشكل آمن
    uploadedFiles = json['uploaded_files'] != null
        ? (json['uploaded_files'] as Map<String, dynamic>)
        .map((key, value) => MapEntry(key, List<String>.from(value)))
        : {};
  }

  // Getter للوصول السهل لأول slot
  String? get firstTimeFrom => slots.isNotEmpty ? slots[0].timeFrom : null;
  String? get firstTimeTo   => slots.isNotEmpty ? slots[0].timeTo : null;
  String? get firstDay      => slots.isNotEmpty ? slots[0].day : null;
}

class Slot {
  int? id;
  String? timeFrom;
  String? timeTo;
  String? day;

  Slot({this.id, this.timeFrom, this.timeTo, this.day});

  Slot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timeFrom = json['time_from'];
    timeTo = json['time_to'];
    day = json['day'];
  }
}

class Student {
  String? name;
  String? image;
  String? classroom;

  Student({this.name, this.image, this.classroom});

  Student.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    classroom = json['classroom'];
  }
}
