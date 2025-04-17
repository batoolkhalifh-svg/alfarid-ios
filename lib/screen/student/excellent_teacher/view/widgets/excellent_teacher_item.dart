import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:alfarid/screen/student/teacher_profile/view/teacher_profile_screen.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';

class ExcellentTeacherItem extends StatelessWidget {
  final String  name, img , subject, rate;
  final int id;
  const ExcellentTeacherItem({super.key, required this.id, required this.name, required this.img, required this.subject, required this.rate});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){
        navigateTo(widget:  TeacherProfileScreen(id:id));
      },
      child: Container(
        width: width,
        height: height*0.122,
        alignment: AlignmentDirectional.topStart,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.r8)
        ),
        child: Row(
          children: [
            Container(
              margin: EdgeInsetsDirectional.all(width*0.03),
              width: width*0.23,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.r8),
                  image:  DecorationImage(image: NetworkImage(img),fit: BoxFit.fill)
              ),
              child:  img.isEmpty
                  ? Image.asset(AppImages.noImage,fit: BoxFit.fill,)
                  : null,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width*0.02),
                  child: Text(name,style: Styles.textStyle14.copyWith(color: AppColors.mainColor2)),
                ),
                SizedBox(height: width*0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width*0.02,vertical: width*0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(rate,style: Styles.textStyle14.copyWith(color: AppColors.blackColor)),
                      SizedBox(width: width*0.01,),
                      Image.asset(AppImages.star,width: width*0.04)
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            subject==""? const SizedBox.shrink():
            Container(
              padding: EdgeInsetsDirectional.all(width*0.02),
              margin: EdgeInsetsDirectional.all(width*0.03),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.r8),
                color: const Color(0xffEAEEFB),
              ),
              child: Text(subject,style: Styles.textStyle12.copyWith(color: const Color(0xff8098E5)),),
            )

          ],
        ),
      ),
    );
}}
