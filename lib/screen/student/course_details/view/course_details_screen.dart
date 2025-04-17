import 'package:flutter/material.dart';

import 'widgets/course_details_body.dart';

class CourseDetailsScreen extends StatelessWidget {
  final int id;
  const CourseDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return  CourseDetailsBody(id: id,);
  }
}
