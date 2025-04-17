import 'package:alfarid/core/widgets/custom_network_img.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';

class NotificationItem extends StatelessWidget {
  final String text1, text2, img;
  const NotificationItem({super.key, required this.text1, required this.text2, required this.img});

  @override
  Widget build(BuildContext context) {
    return   Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: width*0.02,vertical: width*0.02),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.r10),
          border: Border.all(color: const Color(0xffB4BDC4).withOpacity(.2))
      ),
      child: Row(
        children: [
          CustomNetworkImg(img: img,width: width*0.18,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text1,style: Styles.textStyle14.copyWith(color: AppColors.blackColor),),
              SizedBox(
                  width: width*0.62,
                  child: Text(text2,style: Styles.textStyle12.copyWith(),)),
            ],
          )
        ],
      ),
    );
  }
}
