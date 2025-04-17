import 'package:flutter/material.dart';

import 'widgets/teacher_profile_body.dart';

class TeacherProfileScreen extends StatelessWidget {
  final int id;
  const TeacherProfileScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return  TeacherProfileBody(id: id,);
  }
}
