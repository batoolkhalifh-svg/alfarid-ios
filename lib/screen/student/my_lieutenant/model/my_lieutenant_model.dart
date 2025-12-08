class AllLieutenantModel {
  Data? data;
  String? message;
  bool? success;

  AllLieutenantModel({this.data, this.message, this.success});

  AllLieutenantModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : Data(items: []);
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
    } else {
      items = [];
    }
    paginate = json['paginate'] != null ? Paginate.fromJson(json['paginate']) : null;
    extra = json['extra']?.toString() ?? '';
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

  Items({this.id, this.name, this.unitName, this.file, this.image, this.price, this.classroom, this.subject});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0');
    name = json['name']?.toString() ?? '';
    unitName = json['unit_name']?.toString() ?? '';
    file = json['file']?.toString() ?? '';
    image = json['image']?.toString() ?? '';
    price = json['price'] is int ? json['price'] : int.tryParse(json['price']?.toString() ?? '0');
    classroom = json['classroom'] != null ? Classroom.fromJson(json['classroom']) : Classroom(name: '');
    subject = json['subject'] != null ? Classroom.fromJson(json['subject']) : Classroom(name: '');
  }
}

class Classroom {
  int? id;
  String? name;

  Classroom({this.id, this.name});

  Classroom.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0');
    name = json['name']?.toString() ?? '';
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
