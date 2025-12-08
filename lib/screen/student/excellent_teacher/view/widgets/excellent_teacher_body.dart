import 'package:flutter/material.dart';
import 'excellent_teacher_item.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/widgets/custom_arrow.dart';

class ExcellentTeacherBody extends StatelessWidget {
  final List<Map<String, dynamic>> teachers;
  final String title;

  final ScrollController controllerTeacher = ScrollController();

  ExcellentTeacherBody({super.key, required this.teachers, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomArrow(text: title),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.07, vertical: width * 0.03),
                child: ListView.separated(
                  controller: controllerTeacher,
                  padding: EdgeInsetsDirectional.symmetric(vertical: height * 0.024),
                  itemBuilder: (context, index) {
                    final t = teachers[index];
                    return ExcellentTeacherItem(
                      id: t['id'] ?? 0,
                      name: t['name'] ?? '',
                      img: t['image'] ?? '',
                      subject: t['courses'] != null && (t['courses'] as List).isNotEmpty
                          ? t['courses'][0]['subject'] ?? ''
                          : '',
                      rate: t['rate'] != null ? t['rate'].toString() : '0',
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: height * 0.018),
                  itemCount: teachers.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
