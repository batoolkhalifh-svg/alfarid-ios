import 'package:flutter/material.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';

class PointItem extends StatelessWidget {
  final String score,name,img;
  const PointItem({super.key, required this.score, required this.name, required this.img});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: width*0.035,vertical: width*0.035),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.r10)
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: AppRadius.r30,
            backgroundColor: Colors.transparent,
            backgroundImage:NetworkImage(img),
          ),
          SizedBox(width: width*0.025),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,style: Styles.textStyle12.copyWith(fontWeight: FontWeight.bold,color: AppColors.blackColor),),
              SizedBox(height: width*0.025),
              // Text(score,style: Styles.textStyle12.copyWith(fontWeight: FontWeight.bold),)
            ],
          ),
          const Spacer(),
          CircleAvatar(
            radius: AppRadius.r15,
            backgroundColor: AppColors.grayColor3,
            child: Text(score,style: Styles.textStyle14.copyWith(
                color: Colors.white,
                fontFamily: AppFonts.iBMPlexSansArabicRegular
            ),),
          )
        ],
      ),
    );
  }
}
