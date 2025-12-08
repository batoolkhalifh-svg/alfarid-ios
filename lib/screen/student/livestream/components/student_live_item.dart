import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/images.dart';
import '../../../../core/utils/size.dart';
import '../../../../core/widgets/custom_btn.dart';
import '../../../../generated/locale_keys.g.dart';
import '../controller/student_live_cubit.dart';

class StudentLiveItem extends StatelessWidget {
  final StudentLiveCubit cubit;
  final int index;

  const StudentLiveItem({super.key, required this.cubit, required this.index});

  @override
  Widget build(BuildContext context) {
    final live = cubit.lives[index];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(width * 0.04),
        child: Column(
          children: [
            // زر النسخ
            InkWell(
              onTap: () => Clipboard.setData(ClipboardData(text: live.url ?? '')),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(LocaleKeys.copy.tr(),
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.mainColor)),
                  const Icon(Icons.copy, color: AppColors.mainColor),
                ],
              ),
            ),

            SizedBox(height: height * 0.01),

            // اسم البث + أيقونة Live
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: width * 0.45, child: Text(live.name)),
                Row(children: [
                  SvgPicture.asset(AppImages.lives, width: width * 0.07),
                  SizedBox(width: width * 0.015),
                  Text(LocaleKeys.lives.tr())
                ])
              ],
            ),

            SizedBox(height: height * 0.02),

            // التفاصيل
            Text(live.notes ?? ""),

            SizedBox(height: height * 0.02),

            // التاريخ + الوقت
            Row(
              children: [
                SvgPicture.asset(AppImages.clock),
                SizedBox(width: width * 0.01),
                Text(live.date),
                const Spacer(),
                SvgPicture.asset(AppImages.clock),
                SizedBox(width: width * 0.01),
                Text(live.time)
              ],
            ),

            SizedBox(height: height * 0.02),

            // زر الدخول
            CustomButton(
              onPressed: () => cubit.onClick(context: context, index: index),
              widthBtn: width * 0.9,
              text: cubit.text(index: index),
            )
          ],
        ),
      ),
    );
  }
}
