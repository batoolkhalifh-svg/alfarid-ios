import 'package:flutter/material.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';

class CustomRowTeacher extends StatelessWidget {
  final String number, text;
  const CustomRowTeacher({super.key, required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return   Column(
      children: [
        Text(number,style: Styles.textStyle16.copyWith(color: AppColors.blackColor,fontFamily: AppFonts.jost),),
        Text(text,style: Styles.textStyle14.copyWith(color: AppColors.grayColor,fontFamily: AppFonts.mulish,fontWeight: FontWeight.bold),)
      ],
    );
  }
}
