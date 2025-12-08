class NotificationModel {
  Data? data;
  String? message;
  bool? success;

  NotificationModel({this.data, this.message, this.success});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      message: json['message'],
      success: json['success'],
    );
  }

  Map<String, dynamic> toJson() => {
    'data': data?.toJson(),
    'message': message,
    'success': success,
  };
}

class Data {
  List<Items> items;
  Paginate? paginate;
  dynamic extra;

  Data({required this.items, this.paginate, this.extra});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => Items.fromJson(e))
          .toList(),
      paginate:
      json['paginate'] != null ? Paginate.fromJson(json['paginate']) : null,
      extra: json['extra'],
    );
  }

  Map<String, dynamic> toJson() => {
    'items': items.map((e) => e.toJson()).toList(),
    'paginate': paginate?.toJson(),
    'extra': extra,
  };
}

class Items {
  String id;
  String title;
  String body;
  String type;
  String? icon;
  DateTime time;

  Items({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.icon,
    required this.time,
  });

  factory Items.fromJson(Map<String, dynamic> json) {
    print("======= Notification Item JSON =======");
    print(json); // اطبع كل العنصر
    print("time: ${json['time']}");
    print("created_at: ${json['created_at']}");
    print("createdAt: ${json['createdAt']}");
    print("======================================");
    return Items(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? '',
      icon: json['icon'],
      time: DateTime.tryParse(json['time'] ??
          json['created_at'] ??
          json['createdAt'] ??
          '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'type': type,
    'icon': icon,
    'time': time.toIso8601String(),
  };
}

class Paginate {
  int total;
  int count;
  int perPage;
  String? nextPageUrl;
  String? prevPageUrl;
  int currentPage;
  int totalPages;

  Paginate({
    required this.total,
    required this.count,
    required this.perPage,
    this.nextPageUrl,
    this.prevPageUrl,
    required this.currentPage,
    required this.totalPages,
  });

  factory Paginate.fromJson(Map<String, dynamic> json) {
    return Paginate(
      total: json['total'] ?? 0,
      count: json['count'] ?? 0,
      perPage: json['per_page'] ?? 0,
      nextPageUrl: json['next_page_url'],
      prevPageUrl: json['prev_page_url'],
      currentPage: json['current_page'] ?? 0,
      totalPages: json['total_pages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'count': count,
    'per_page': perPage,
    'next_page_url': nextPageUrl,
    'prev_page_url': prevPageUrl,
    'current_page': currentPage,
    'total_pages': totalPages,
  };
}
