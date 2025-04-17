class FileModel {
  Data? data;
  String? message;
  bool? success;

  FileModel({this.data, this.message, this.success});

  FileModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
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
        items!.add( Items.fromJson(v));
      });
    }
    paginate = json['paginate'] != null
        ?  Paginate.fromJson(json['paginate'])
        : null;
    extra = json['extra'];
  }
}

class Items {
  int? id;
  String? name;
  String? type;
  String? path;
  String? createdAt;

  Items({this.id, this.name, this.type, this.path, this.createdAt});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    path = json['path'];
    createdAt = json['created_at'];
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
