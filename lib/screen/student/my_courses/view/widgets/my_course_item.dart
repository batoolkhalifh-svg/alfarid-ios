import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:alfarid/screen/student/course_details/view/course_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';
import '../../model/current_courses.dart';

class MyCourseItem extends StatelessWidget {
  final bool isCurrent;
  final Items items;

  const MyCourseItem({super.key, required this.isCurrent, required this.items});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateTo(widget: CourseDetailsScreen(id: items.id!));
      },
      child: Container(
        width: width,
        alignment: AlignmentDirectional.topStart,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.r8),
        ),
        child: Row(
          children: [
            // صورة الكورس
            Container(
              width: width * 0.32,
              height: 96, // اعطي ارتفاع ثابت لتجنب مشاكل NaN
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(AppRadius.r8),
                  bottomStart: Radius.circular(AppRadius.r8),
                ),
                image: DecorationImage(
                  image: NetworkImage(items.image.toString()),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // نصوص الكورس
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: width * 0.018, left: width * 0.02, right: width * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // عنوان الكورس والأيقونات
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            items.name.toString(),
                            style: Styles.textStyle14.copyWith(color: AppColors.mainColor2),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        if (!isCurrent) SvgPicture.asset(AppImages.complete),
                        if (isCurrent) ...[
                          Icon(Icons.access_time_outlined, color: AppColors.mainColor2, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            items.duration.toString(),
                            style: Styles.textStyle10.copyWith(color: AppColors.blackColor),
                          ),
                        ]
                      ],
                    ),
                    const SizedBox(height: 4),
                    // وصف الكورس
                    Text(
                      items.desc.toString(),
                      style: Styles.textStyle12.copyWith(color: AppColors.blackColor),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // شريط التقدم للكورس الحالي
                    if (isCurrent)
                      LinearPercentIndicator(
                        isRTL: true,
                        width: width * 0.4,
                        animation: true,
                        animationDuration: 1000,
                        lineHeight: height * 0.01,
                        trailing: Text(
                          "${items.finishedLessons ?? 0}/${items.totalLessons ?? 0}",
                          style: Styles.textStyle12.copyWith(
                            color: AppColors.blackColor,
                            fontFamily: AppFonts.almaraiBold,
                          ),
                        ),
                        percent: (items.totalLessons ?? 0) > 0
                            ? (items.finishedLessons ?? 0) / (items.totalLessons ?? 1)
                            : 0,
                        barRadius: Radius.circular(AppRadius.r10),
                        progressColor: AppColors.mainColor2,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
