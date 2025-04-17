class ExamModel {
  Data? data;
  String? message;
  bool? success;

  ExamModel({this.data, this.message, this.success});

  ExamModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
    success = json['success'];
  }
}

class Data {
  int? id;
  String? name;
  dynamic duration;
  List<Items>? questions;

  Data({this.id, this.name, this.questions,this.duration});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    duration=json['duration'];
    if (json['questions'] != null) {
      questions = <Items>[]; // تهيئة القائمة
      json['questions'].forEach((v) {
        questions!.add(Items.fromJson(v));
      });
    }
  }
}

class Items {
  int? id;
  String? question;
  List<Options>? options;

  Items({this.id, this.question, this.options});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
  }
}

class Options {
  int? id;
  String? answer;

  Options({this.id, this.answer});

  Options.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    answer = json['answer'];
  }
}
