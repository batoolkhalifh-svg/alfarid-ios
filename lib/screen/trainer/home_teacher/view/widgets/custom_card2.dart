import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';
import 'custom_blue_btn.dart';

class CustomCard2 extends StatelessWidget {
  final String img, text1,text2, textBtn;
  final Function()? onTap;
  const CustomCard2({super.key, required this.img, required this.text1, required this.text2, required this.textBtn, this.onTap});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: width*0.045,vertical:width*0.045 ),
      width: width*.43,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.r15)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(img,width: width*0.12,),
          Padding(
            padding: EdgeInsetsDirectional.symmetric(vertical:width*0.02),
            child: Text(text1,style:Styles.textStyle14.copyWith(color: AppColors.mainColor) ,textAlign: TextAlign.center,),
          ),
          Text(text2,style:Styles.textStyle12.copyWith(color: AppColors.blackColor,fontFamily: AppFonts.almaraiBold),textAlign: TextAlign.center),
          SizedBox(height: width*0.01,),
          CustomBlueButton(text: textBtn,onTap: onTap,)
        ],
      ),
    );
  }
}
