class AllLieutenantModel {
  Data? data;
  String? message;
  bool? success;

  AllLieutenantModel({this.data, this.message, this.success});

  AllLieutenantModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
    success = json['success'];
  }

}

class Data {
  List<Items>? items;
  Paginate? paginate;
  String? extra;

  Data({this.items, this.paginate, this.extra});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
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
  String? unitName;
  String? file;
  String? image;
  int? price;
  Classroom? classroom;
  Classroom? subject;

  Items(
      {this.id,
        this.name,
        this.unitName,
        this.file,
        this.image,
        this.price,
        this.classroom,
        this.subject});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    unitName = json['unit_name'];
    file = json['file'];
    image = json['image'];
    price = json['price'];
    classroom = json['classroom'] != null
        ? Classroom.fromJson(json['classroom'])
        : null;
    subject = json['subject'] != null
        ? Classroom.fromJson(json['subject'])
        : null;
  }

}

class Classroom {
  int? id;
  String? name;

  Classroom({this.id, this.name});

  Classroom.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
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
