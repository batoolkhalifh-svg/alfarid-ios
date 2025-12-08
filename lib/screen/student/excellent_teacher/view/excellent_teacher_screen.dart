import 'package:flutter/material.dart';
import 'widgets/excellent_teacher_body.dart';

class ExcellentTeacherScreen extends StatelessWidget {
  final Map teacher;

  const ExcellentTeacherScreen({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(teacher["name"] ?? "")),
      body: ExcellentTeacherBody(
        teachers: [],        // 🔥 قائمة فيها معلم واحد
        title: teacher["name"] ?? "",  // 🔥 عنوان الصفحة
      ),
    );
  }
}
