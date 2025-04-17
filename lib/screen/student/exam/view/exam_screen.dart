import 'package:flutter/material.dart';

import 'widgets/exam_body.dart';

class ExamScreen extends StatelessWidget {
  final int id;
  final bool isLieutenant;
  const ExamScreen({super.key, required this.id, required this.isLieutenant});

  @override
  Widget build(BuildContext context) {
    return  ExamBody(id: id, isLieutenant: isLieutenant,);
  }
}
