import 'package:flutter/material.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';

class CustomBlueButton extends StatelessWidget {
  final String text;
  final Function()? onTap;
  final bool? isRed;
  final double? fontSize;
  const CustomBlueButton({super.key, required this.text, this.onTap, this.isRed, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return   GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsetsDirectional.all(width*0.02),
        decoration: BoxDecoration(
            color:isRed==true? const Color(0xffEC221F).withOpacity(.1): const Color(0xffE8F1FF),
            borderRadius: BorderRadius.circular(AppRadius.r10)
        ),
        child: Text(text,style: Styles.textStyle10.copyWith(color:isRed==true? const Color(0xffEC221F): AppColors.mainColor2,fontFamily: AppFonts.jost,fontSize: fontSize),),
      ),
    );
  }
}
