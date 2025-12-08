import 'package:flutter/material.dart';

import 'widgets/teacher_profile_body.dart';

class TeacherProfileScreen extends StatelessWidget {
  final int id;
  final String? classroomType;
  const TeacherProfileScreen({super.key, required this.id,  this.classroomType,});

  @override
  Widget build(BuildContext context) {
    return  TeacherProfileBody(id: id,classroomType: classroomType);
  }
}
