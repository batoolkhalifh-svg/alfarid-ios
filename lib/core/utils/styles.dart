import 'package:alfarid/core/utils/size.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

abstract class Styles {
  static TextStyle textStyle20 = TextStyle(
    fontSize: AppFonts.t18,
    fontFamily: AppFonts.almaraiBold,
    color: AppColors.blackColor,
  );
  static TextStyle textStyle16 = TextStyle(
    fontSize: AppFonts.t16,
    fontWeight: FontWeight.w500,
    fontFamily: AppFonts.almaraiRegular,
    color: AppColors.mainColor,
  );
  static TextStyle textStyle14 = TextStyle(
    fontSize: AppFonts.t14,
    fontWeight: FontWeight.w400,
    fontFamily: AppFonts.almaraiBold,
    color:Colors.white,
  );
  static TextStyle textStyle12 = TextStyle(
      fontSize: AppFonts.t12,
      fontWeight: FontWeight.w400,
      fontFamily: AppFonts.almaraiRegular,
      color: AppColors.grayColor
  );
  static TextStyle textStyle8 = TextStyle(
    fontSize: AppFonts.t8,
    fontWeight: FontWeight.w400,
    fontFamily: AppFonts.almaraiRegular,
    color: AppColors.mainColor,
  );
  static TextStyle textStyle10 = TextStyle(
      fontSize: AppFonts.t10,
      fontWeight: FontWeight.w400,
      fontFamily: AppFonts.almaraiRegular,
      color: AppColors.grayColor
  );
}