import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
    return  Column(
      children: [
        Padding(
          padding:EdgeInsets.only(right: width*0.045 , left: width*0.045,top: height*0.018),
          child: Row(
            children: [
              Text("${LocaleKeys.welcome.tr()} ${CacheHelper.getData(key: AppCached.name)}",style: Styles.textStyle14.copyWith(color: AppColors.mainColorText),),
              const Spacer(),
              GestureDetector(
                onTap: (){
                  navigateTo(widget: const NotificationScreen());
                },
                child: Image.asset(AppImages.notification,width: width*0.11,),
              )
            ],
          ),
        ),
      ],
    );
  }
}
