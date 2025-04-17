class TeacherModel {
  Teacher? data;
  String? message;
  bool? success;

  TeacherModel({this.data, this.message, this.success});

  TeacherModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ? Teacher.fromJson(json['data']) : null;
    message = json['message'];
    success = json['success'];
  }
}

class Teacher {
  final int? id;
  final String? name;
  final String? email;
  final String? phoneKey;
  final String? phone;
  final String? image;
  final List<Subject>? subjects;
  final List<Classroom>? classrooms;

  Teacher({
    this.id,
    this.name,
    this.email,
    this.phoneKey,
    this.phone,
    this.image,
    this.subjects,
    this.classrooms,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneKey: json['phone_key'],
      phone: json['phone'],
      image: json['image'],
      subjects: (json['subjects'] as List)
          .map((subject) => Subject.fromJson(subject))
          .toList(),
      classrooms: (json['classrooms'] as List)
          .map((classroom) => Classroom.fromJson(classroom))
          .toList(),
    );
  }
}

class Subject {
  final int? id;
  final String? name;

  Subject({
    this.id,
    this.name,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Classroom {
  final int? id;
  final String? name;

  Classroom({
    this.id,
    this.name,
  });

  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      id: json['id'],
      name: json['name'],
    );
  }
}

