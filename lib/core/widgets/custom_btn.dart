import 'package:alfarid/core/utils/styles.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/images.dart';
import '../utils/size.dart';


class CustomButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final double widthBtn;
  final TextStyle? style;
  final bool? color;
  final double? hit;

  const CustomButton(
      {super.key,
        required this.text,
        required this.onPressed, required this.widthBtn, this.style, this.color=true, this.hit});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: widthBtn,
        height:hit?? height * 0.075,
        decoration:color==true?BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.r10)),
          image: const DecorationImage(
              image: AssetImage(AppImages.backBtn), fit: BoxFit.fill),
        ):BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.r10)),
          color: Colors.white,
        ),
        child: Center(
            child: Text(text, style:style?? Styles.textStyle14.copyWith(color: color==false?AppColors.blackColor:Colors.white),)),
      ),
    );
  }
}