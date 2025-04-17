import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../main.dart';

class CustomProfileRow extends StatelessWidget {
  final String text, img;
  final void Function()? onTap;
  final bool? isLang;
  const CustomProfileRow({super.key, required this.text, required this.img, this.onTap, this.isLang=false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: width*0.02,vertical: width*0.028),
        child: Row(
          children: [
            SvgPicture.asset(img, width: width*0.06),
            SizedBox(width: width*0.028),
            Text(text,style: Styles.textStyle14.copyWith(color: AppColors.blackColor,fontFamily: AppFonts.almaraiRegular),),
            const Spacer(),
            isLang==true?
            Text(navigatorKey.currentContext!.locale.languageCode=="ar"? "English (US)":"اللغة العربية",style: Styles.textStyle12.copyWith(color: AppColors.mainColor,fontFamily: AppFonts.almaraiRegular),)
            :const SizedBox.shrink(),
            SvgPicture.asset(navigatorKey.currentContext!.locale.languageCode=="ar"?AppImages.arrowAr:AppImages.arrowEn, width: width*0.07),
          ],
        ),
      ),
    );
  }
}
