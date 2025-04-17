class CoursesModel {
  Data? data;
  String? message;
  bool? success;

  CoursesModel({this.data, this.message, this.success});

  CoursesModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
    message = json['message'];
    success = json['success'];
  }

}

class Data {
  List<Items>? items;
  Paginate? paginate;
  dynamic extra;

  Data({this.items, this.paginate, this.extra});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add( Items.fromJson(v));
      });
    }
    paginate = json['paginate'] != null
        ? Paginate.fromJson(json['paginate'])
        : null;
    extra = json['extra'];
  }
}

class Items {
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
  bool? isFavourite;
  int? totalLessons;

  Items(
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
        this.isFavourite,
        this.totalLessons});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    desc = json['desc'];
    image = json['image'];
    price = json['price'];
    status = json['status'];
    subject = json['subject'];
    teacher =
    json['teacher'] != null ?  Teacher.fromJson(json['teacher']) : null;
    duration = json['duration'];
    isSubscribed = json['is_subscribed'];
    isFavourite=json['is_favorite'];
    totalLessons=json['total_lessons'];
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
