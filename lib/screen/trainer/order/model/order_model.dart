class OrdersModel {
  List<Data>? data;
  String? message;
  bool? success;

  OrdersModel({this.data, this.message, this.success});

  /// تحويل JSON بطريقة آمنة
  factory OrdersModel.fromJsonSafe(Map<String, dynamic> json) {
    List<Data> tempData = [];
    try {
      if (json['data'] != null && json['data']['items'] != null) {
        for (var v in json['data']['items']) {
          tempData.add(Data.fromJsonSafe(Map<String, dynamic>.from(v)));
        }
      }
    } catch (e) {
      // لو صار خطأ في تحويل البيانات، نترك القائمة فاضية
      tempData = [];
    }
    return OrdersModel(
      data: tempData,
      message: json['message'],
      success: json['success'] ?? false,
    );
  }
}

class Data {
  int? id;
  Student? student;
  String? date;
  String? paymentStatus;
  double? price;
  String? status;
  List<Slot>? slots;

  Data({this.id, this.student, this.date, this.paymentStatus, this.price, this.status, this.slots});

  factory Data.fromJsonSafe(Map<String, dynamic> json) {
    List<Slot> tempSlots = [];
    try {
      if (json['slots'] != null) {
        for (var s in json['slots']) {
          tempSlots.add(Slot.fromJsonSafe(Map<String, dynamic>.from(s)));
        }
      }
    } catch (e) {
      tempSlots = [];
    }
    return Data(
      id: json['id'],
      student: json['student'] != null ? Student.fromJsonSafe(Map<String, dynamic>.from(json['student'])) : null,
      date: json['date'],
      paymentStatus: json['payment_status'],
      price: json['price'] != null ? (json['price'] is int ? (json['price'] as int).toDouble() : json['price']) : null,
      status: json['status'],
      slots: tempSlots,
    );
  }
}

class Student {
  String? name;
  String? image;
  String? classroom;

  Student({this.name, this.image, this.classroom});

  factory Student.fromJsonSafe(Map<String, dynamic> json) {
    return Student(
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      classroom: json['classroom'] ?? '',
    );
  }
}

class Slot {
  int? id;
  String? timeFrom;
  String? timeTo;
  String? day;

  Slot({this.id, this.timeFrom, this.timeTo, this.day});

  factory Slot.fromJsonSafe(Map<String, dynamic> json) {
    return Slot(
      id: json['id'],
      timeFrom: json['time_from'] ?? '',
      timeTo: json['time_to'] ?? '',
      day: json['day'] ?? '',
    );
  }
}
