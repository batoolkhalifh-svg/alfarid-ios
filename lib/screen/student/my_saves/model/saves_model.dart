class SavedModel {
  Data? data;
  String? message;
  bool? success;

  SavedModel({this.data, this.message, this.success});

  SavedModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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
  Course? course;

  Items({this.id, this.course});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    course =
    json['course'] != null ? Course.fromJson(json['course']) : null;
  }
}


class Course {
  int? id;
  String? name;
  String? classroom;
  String? image;
  int? price;

  Course({this.id, this.name, this.classroom, this.image, this.price});

  Course.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    classroom = json['classroom'];
    image = json['image'];
    price = json['price'];
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
