import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../../core/utils/colors.dart';
import '../../../../../../../core/utils/images.dart';
import '../../../../../../../core/utils/size.dart';
import '../../../../../../../core/utils/styles.dart';
import '../../../../../../../generated/locale_keys.g.dart';
import '../../../../../../trainer/home_teacher/view/widgets/custom_blue_btn.dart';
class EmptyGroupChat extends StatelessWidget {
  final Function()? onTap;
  final bool isTeacher;
  const EmptyGroupChat({super.key, this.onTap, required this.isTeacher});

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(AppImages.emptyGroupChat),
        if(isTeacher==true)...[
          Text(LocaleKeys.starGroupChat.tr(),style: Styles.textStyle14.copyWith(color: AppColors.blackColor),),
          SizedBox(height: height*0.02,),
          CustomBlueButton(text: LocaleKeys.startNewGroup.tr(),onTap: onTap,),
        ],
        SizedBox(width: width*.92,)
      ],
    );
  }
}
