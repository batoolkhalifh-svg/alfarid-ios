class CourseDetailsModel {
  Data? data;
  String? message;
  bool? success;

  CourseDetailsModel({this.data, this.message, this.success});

  CourseDetailsModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
    success = json['success'];
  }

}

class Data {
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
  bool? isCompleted;
  bool? hasExam;
  bool? isExamToken;
  List<Sections>? sections;

  Data(
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
        this.sections,
        this.isFavourite,
        this.hasExam,
        this.isCompleted,
        this.isExamToken,
        this.totalLessons});

  Data.fromJson(Map<String, dynamic> json) {
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
    isFavourite=json['is_favorite'];
    totalLessons=json['total_lessons'];
    isCompleted=json["is_completed"];
    hasExam=json["has_exam"];
    isExamToken=json["is_exam_taken"];
    if (json['sections'] != null) {
      sections = <Sections>[];
      json['sections'].forEach((v) {
        sections!.add(Sections.fromJson(v));
      });
    }
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

class Sections {
  int? id;
  String? name;
  String? totalDuration;
  List<Lessons>? lessons;

  Sections({this.id, this.name, this.totalDuration, this.lessons});

  Sections.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    totalDuration = json['total_duration'];
    if (json['lessons'] != null) {
      lessons = <Lessons>[];
      json['lessons'].forEach((v) {
        lessons!.add(Lessons.fromJson(v));
      });
    }
  }

}

class Lessons {
  int? id;
  String? name;
  String? duration;
  bool? isFree;
  String? video;

  Lessons({this.id, this.name, this.duration, this.isFree, this.video});

  Lessons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    duration = json['duration'];
    isFree = json['is_free'];
    video = json['video'];
  }
}
