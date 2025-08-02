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
    return Builder(
      builder: (context) {
        final cubit = context.read<HomeTeacherCubit>();
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(right: width * 0.045, left: width * 0.045, top: height * 0.018),
              child: Row(
                children: [
                  Text(
                    "${LocaleKeys.welcome.tr()} ${CacheHelper.getData(key: AppCached.name)}",
                    style: Styles.textStyle14.copyWith(color: AppColors.mainColorText),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      navigateTo(widget: const NotificationScreen());
                    },
                    child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Stack(
                          alignment: AlignmentDirectional.topStart,
                          children: [
                            Icon(
                              Icons.notifications_none_outlined,
                              color: AppColors.mainColor,
                              size: 33.w,
                            ),
                            if(cubit.studentHomeModel!.data!.notificationsCount!>0)
                            Container(
                              padding: EdgeInsets.all(3.h),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle
                              ),
                              child: Text(cubit.studentHomeModel!.data!.notificationsCount.toString()),
                            )
                          ],
                        )),
                  )
                ],
              ),
            ),
          ],
        );
      }
    );
  }
}
