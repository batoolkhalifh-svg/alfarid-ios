class BooksModel {
  Data? data;
  String? message;
  bool? success;

  BooksModel({this.data, this.message, this.success});

  BooksModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : Data(items: []);
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
    } else {
      items = [];
    }
    paginate = json['paginate'] != null ? Paginate.fromJson(json['paginate']) : null;
    extra = json['extra'];
  }
}

class Items {
  int? id;
  String? name;
  String? image;
  String? file;
  int? price;
  String? classroom;

  Items({this.id, this.name, this.image, this.file, this.price, this.classroom});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0');
    name = json['name']?.toString() ?? '';
    image = json['image']?.toString() ?? '';
    file = json['file']?.toString() ?? '';
    price = json['price'] is int ? json['price'] : int.tryParse(json['price']?.toString() ?? '0');
    classroom = json['classroom']?.toString() ?? '';
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

  Paginate({this.total, this.count, this.perPage, this.nextPageUrl, this.prevPageUrl, this.currentPage, this.totalPages});

  Paginate.fromJson(Map<String, dynamic> json) {
    total = json['total'] is int ? json['total'] : int.tryParse(json['total']?.toString() ?? '0');
    count = json['count'] is int ? json['count'] : int.tryParse(json['count']?.toString() ?? '0');
    perPage = json['per_page'] is int ? json['per_page'] : int.tryParse(json['per_page']?.toString() ?? '0');
    nextPageUrl = json['next_page_url']?.toString() ?? '';
    prevPageUrl = json['prev_page_url']?.toString() ?? '';
    currentPage = json['current_page'] is int ? json['current_page'] : int.tryParse(json['current_page']?.toString() ?? '0');
    totalPages = json['total_pages'] is int ? json['total_pages'] : int.tryParse(json['total_pages']?.toString() ?? '0');
  }
}
