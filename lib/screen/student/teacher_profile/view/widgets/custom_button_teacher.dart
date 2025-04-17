import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../generated/locale_keys.g.dart';

class CustomButtonTeacher extends StatelessWidget {
  final bool isDirectBooking;
  final  Function()? onTap;
  const CustomButtonTeacher({super.key, required this.isDirectBooking, this.onTap});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal:isDirectBooking==true? width*0.12:width*0.115,vertical: width*0.05),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.r8),
            color:isDirectBooking==true? AppColors.mainColor:AppColors.fillColor
        ),
        child: Text(isDirectBooking==true?LocaleKeys.directBooking.tr():LocaleKeys.sendMsg.tr(),style: Styles.textStyle12.copyWith(color:isDirectBooking==true? Colors.white:AppColors.mainColor,fontWeight: FontWeight.bold),),
      ),
    );
  }
}
