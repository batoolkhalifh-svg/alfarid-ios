class SearchModel {
  Data? data;
  String? message;
  bool? success;

  SearchModel({this.data, this.message, this.success});

  SearchModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
    success = json['success'];
  }

}

class Data {
  Courses? courses;
  Teachers? teachers;

  Data({this.courses, this.teachers});

  Data.fromJson(Map<String, dynamic> json) {
    courses = json['courses'] != null ? Courses.fromJson(json['courses']) : null;
    teachers = json['teachers'] != null ? Teachers.fromJson(json['teachers']) : null;
  }

}

class Courses {
  List<CourseItem>? items;
  Paginate? paginate;
  dynamic extra;

  Courses({this.items, this.paginate, this.extra});

  Courses.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <CourseItem>[];
      json['items'].forEach((v) {
        items!.add(CourseItem.fromJson(v));
      });
    }
    paginate = json['paginate'] != null ? Paginate.fromJson(json['paginate']) : null;
    extra = json['extra'];
  }

}

class CourseItem {
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

  CourseItem({
    this.id,
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
    this.totalLessons,
  });

  CourseItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    desc = json['desc'];
    image = json['image'];
    price = json['price'];
    status = json['status'];
    subject = json['subject'];
    teacher = json['teacher'] != null ? Teacher.fromJson(json['teacher']) : null;
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
  dynamic subject;

  Teacher({this.id, this.name, this.image, this.subject});

  Teacher.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    subject = json['subject'];
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

  Paginate({
    this.total,
    this.count,
    this.perPage,
    this.nextPageUrl,
    this.prevPageUrl,
    this.currentPage,
    this.totalPages,
  });

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

class Teachers {
  List<TeacherItem>? items;
  Paginate? paginate;
  dynamic extra;

  Teachers({this.items, this.paginate, this.extra});

  Teachers.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <TeacherItem>[];
      json['items'].forEach((v) {
        items!.add(TeacherItem.fromJson(v));
      });
    }
    paginate = json['paginate'] != null ? Paginate.fromJson(json['paginate']) : null;
    extra = json['extra'];
  }

}

class TeacherItem {
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
  dynamic rates;
  dynamic courses;

  TeacherItem({
    this.id,
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
    this.courses,
  });

  TeacherItem.fromJson(Map<String, dynamic> json) {
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
    rates = json['rates'];
    courses=json['courses'];
    // if (json['courses'] != null) {
    //   courses = <CourseItem>[];
    //   json['courses'].forEach((v) {
    //     courses!.add(CourseItem.fromJson(v));
    //   });
    // }
  }

}
