import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';

class CustomProfileRow extends StatelessWidget {
  final String text, img;
  final void Function()? onTap;
  final bool? isLang;

  const CustomProfileRow({
    super.key,
    required this.text,
    required this.img,
    this.onTap,
    this.isLang = false,
  });

  @override
  Widget build(BuildContext context) {
    String langText = context.locale.languageCode == "ar" ? "English (US)" : "اللغة العربية";

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: width * 0.028),
        child: Row(
          children: [
            SvgPicture.asset(img, width: width * 0.06),
            SizedBox(width: width * 0.028),
            Expanded(
              child: Text(
                text,
                style: Styles.textStyle14.copyWith(
                  color: AppColors.blackColor,
                  fontFamily: AppFonts.almaraiRegular,
                ),
              ),
            ),
            if (isLang == true)
              Padding(
                padding: EdgeInsets.only(right: width * 0.02),
                child: Text(
                  langText,
                  style: Styles.textStyle12.copyWith(
                    color: AppColors.mainColor,
                    fontFamily: AppFonts.almaraiRegular,
                  ),
                ),
              ),
            SvgPicture.asset(
              context.locale.languageCode == "ar" ? AppImages.arrowAr : AppImages.arrowEn,
              width: width * 0.07,
            ),
          ],
        ),
      ),
    );
  }
}