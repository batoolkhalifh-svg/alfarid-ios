class NotificationModel {
  Data? data;
  String? message;
  bool? success;

  NotificationModel({this.data, this.message, this.success});

  NotificationModel.fromJson(Map<dynamic, dynamic> json) {
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
  String? id;
  String? title;
  String? body,type;
  String? icon;

  Items({this.id, this.title, this.body, this.icon});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    type = json['type'];
    icon = json['icon'];
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
