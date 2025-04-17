class TeacherModel {
  Data? data;
  String? message;
  bool? success;

  TeacherModel({this.data, this.message, this.success});

  TeacherModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
    success = json['success'];
  }

}

class Data {
  List<ItemsT>? items;
  Paginate? paginate;
  dynamic extra;

  Data({this.items, this.paginate, this.extra});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <ItemsT>[];
      json['items'].forEach((v) {
        items!.add(ItemsT.fromJson(v));
      });
    }
    paginate = json['paginate'] != null
        ? Paginate.fromJson(json['paginate'])
        : null;
    extra = json['extra'];
  }

}

class ItemsT {
  int? id;
  String? name;
  String? email;
  String? phoneKey;
  String? phone;
  String? image;
  bool? isVerified;
  bool? isNotified;
  String? rate;
  int? rateCount;
  int? coursesCount;
  List<ItemsRate>? rates;
  List<ItemsCourses>? courses;

  ItemsT(
      {this.id,
        this.name,
        this.email,
        this.phoneKey,
        this.phone,
        this.image,
        this.isVerified,
        this.isNotified,
        this.rate,
        this.rateCount,
        this.coursesCount,
        this.rates,
        this.courses});

  ItemsT.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneKey = json['phone_key'];
    phone = json['phone'];
    image = json['image'];
    isVerified = json['isVerified'];
    isNotified = json['isNotified'];
    rate = json['rate'];
    rateCount = json['rate_count'];
    coursesCount = json['courses_count'];
    if (json['rates'] != null && json['rates']['items'] != null) {
      rates = <ItemsRate>[];
      json['rates']['items'].forEach((v) {
        rates!.add(ItemsRate.fromJson(v));
      });
    } else {
      rates = [];
    }
    if (json['courses'] != null && json['courses']['items'] != null) {
      courses = <ItemsCourses>[];
      json['courses']['items'].forEach((v) {
        courses!.add(ItemsCourses.fromJson(v));
      });
    } else {
      courses = [];
    }

  }

}

class ItemsRate {
  int? id;
  Student? student;
  String? rate;
  String? comment;
  String? createdAt;

  ItemsRate({this.id, this.student, this.rate, this.comment, this.createdAt});

  ItemsRate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    student =
    json['student'] != null ? Student.fromJson(json['student']) : null;
    rate = json['rate'];
    comment = json['comment'];
    createdAt = json['created_at'];
  }

}

class Student {
  String? name;
  String? image;

  Student({this.name, this.image});

  Student.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
  }

}

class Paginate {
  int? total;
  int? count;
  int? perPage;
  String? nextPageUrl;
  String? prevPageUrl;
  int? currentPage;
  int? totalPages;

  Paginate(
      {this.total,
        this.count,
        this.perPage,
        this.nextPageUrl,
        this.prevPageUrl,
        this.currentPage,
        this.totalPages});

  Paginate.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    count = json['count'];
    perPage = json['per_page'];
    nextPageUrl = json['next_page_url'];
    prevPageUrl = json['prev_page_url'];
    currentPage = json['current_page'];
    totalPages = json['total_pages'];
  }
}

class ItemsCourses {
  int? id;
  String? name;
  String? desc;
  String? image;
  int? price;
  String? status;
  String? subject;
  Teacher? teacher;
  String? duration;
  bool? isSubscribed;
  bool? isFavorite;
  int? totalLessons;

  ItemsCourses(
      {this.id,
        this.name,
        this.desc,
        this.image,
        this.price,
        this.status,
        this.subject,
        this.teacher,
        this.duration,
        this.isSubscribed,
        this.isFavorite,
        this.totalLessons});

  ItemsCourses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    desc = json['desc'];
    image = json['image'];
    price = json['price'];
    status = json['status'];
    subject = json['subject'];
    teacher =
    json['teacher'] != null ? Teacher.fromJson(json['teacher']) : null;
    duration = json['duration'];
    isSubscribed = json['is_subscribed'];
    isFavorite = json['is_favorite'];
    totalLessons = json['total_lessons'];
  }

}

class Teacher {
  int? id;
  String? name;
  String? image;
  String? subject;

  Teacher({this.id, this.name, this.image, this.subject});

  Teacher.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    subject = json['subject'];
  }
}
