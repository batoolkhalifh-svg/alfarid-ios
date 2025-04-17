import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';

class CustomCard extends StatelessWidget {
  final String img, text1, text2;
  const CustomCard({super.key, required this.img, required this.text1, required this.text2});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(img,width: width*0.12,),
          Padding(
            padding: EdgeInsetsDirectional.symmetric(vertical:width*0.02),
            child: Text(text1,style:Styles.textStyle14.copyWith(color: AppColors.blackColor) ,),
          ),
          Text(text2,style:Styles.textStyle14.copyWith(color: AppColors.grayColor) ,),
        ],
      ),
    );
  }
}
