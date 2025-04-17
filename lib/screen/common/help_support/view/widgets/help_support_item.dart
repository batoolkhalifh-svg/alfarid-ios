import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';

class HelpAndSupportItem extends StatelessWidget {
  final String text1, text2, img;
  final void Function()? onTap;
  const HelpAndSupportItem({super.key, required this.text1, required this.text2, required this.img, this.onTap});

  @override
  Widget build(BuildContext context) {
    return   GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsetsDirectional.symmetric(horizontal: width*0.02,vertical: width*0.02),
        margin: EdgeInsetsDirectional.only(bottom: height*0.01),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.r10),
            border: Border.all(color: const Color(0xffB4BDC4).withOpacity(.2))
        ),
        child: Row(
          children: [
            SvgPicture.asset(img,width: width*0.18,),
            SizedBox(width: width*0.01,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text1,style: Styles.textStyle14.copyWith(color: AppColors.blackColor),),
                SizedBox(height: width*0.02,),
                Text(text2,style: Styles.textStyle12.copyWith(),),
              ],
            )
          ],
        ),
      ),
    );
  }
}
