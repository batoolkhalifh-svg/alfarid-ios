import 'package:alfarid/screen/trainer/home_teacher/controller/home_teacher_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/local/app_cached.dart';
import '../../../../../core/local/cache_helper.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/my_navigate.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../common/notification/view/notification_screen.dart';

class CustomTeacherHeader extends StatelessWidget {
  const CustomTeacherHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeTeacherCubit>();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.045,
        vertical: height * 0.01,
      ),
      child: Row(
        children: [
          // 👤 صورة + اسم
          Row(
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundColor: AppColors.mainColor.withOpacity(0.15),
                backgroundImage: const NetworkImage(
                  "https://app.alfarid.info/app/images/user.png",
                ),
              ),

              SizedBox(width: 10.w),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.welcome.tr(),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12.sp,
                    ),
                  ),
                  Text(
                    CacheHelper.getData(key: AppCached.name) ?? "Teacher",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Spacer(),

          // 🔔 Notifications
          GestureDetector(
            onTap: () {
              navigateTo(widget: const NotificationScreen());
            },
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.25),
                ),
              ),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                    size: 26.sp,
                  ),

                  // 🔴 Badge
                  if (cubit.studentHomeModel!.data!.notificationsCount! > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 18.w,
                          minHeight: 18.w,
                        ),
                        child: Center(
                          child: Text(
                            cubit.studentHomeModel!.data!.notificationsCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}