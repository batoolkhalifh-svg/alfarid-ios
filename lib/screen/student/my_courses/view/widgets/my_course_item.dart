import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:alfarid/screen/student/course_details/view/course_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';
import '../../model/current_courses.dart';



class MyCourseItem extends StatelessWidget {
  final bool isCurrent;
  final Items items;
  const MyCourseItem({super.key, required this.isCurrent, required this.items});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){navigateTo(widget: CourseDetailsScreen(id: items.id!));},
      child: Container(
        width: width,
        alignment: AlignmentDirectional.topStart,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.r8)
        ),
        child: Row(
          children: [
            Container(
              width: width*0.32,
              decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.only(topStart:Radius.circular( AppRadius.r8),bottomStart: Radius.circular( AppRadius.r8)),
                  image:  DecorationImage(image: NetworkImage(items.image.toString()),fit: BoxFit.fill)
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: width*0.018),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width*0.02,vertical:height*0.006),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(items.name.toString(),style: Styles.textStyle14.copyWith(color: AppColors.mainColor2)),
                        SizedBox(width:isCurrent==true?width*0.1: width*0.24),
                        isCurrent==true? const SizedBox.shrink():SvgPicture.asset(AppImages.complete),
                        isCurrent==true? const Icon(Icons.access_time_outlined,color:AppColors.mainColor2 ,size: 18,):const SizedBox.shrink(),
                        isCurrent==true? Text(items.duration.toString(),style: Styles.textStyle10.copyWith(color: AppColors.blackColor),):const SizedBox.shrink()
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: width*0.02,end:width*0.02,bottom: width*0.02 ),
                    child: SizedBox(
                        width:width*.45,
                        child: Text(items.desc.toString(),style: Styles.textStyle12.copyWith(color: AppColors.blackColor))),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: width*0.02),
                  //   child: Row(
                  //     children: [
                  //       Text("4.2",style: Styles.textStyle14.copyWith(color: AppColors.blackColor)),
                  //       SizedBox(width: width*0.01,),
                  //       Image.asset(AppImages.star,width: width*0.04)
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: width*0.01),
                  isCurrent==true?
                  LinearPercentIndicator(
                    isRTL: true,
                    width: width*0.4,
                    animation: true,
                    animationDuration: 1000,
                    lineHeight: height*0.01,
                    trailing:  Text("${items.finishedLessons}/${items.totalLessons}",style: Styles.textStyle12.copyWith(color: AppColors.blackColor,fontFamily: AppFonts.almaraiBold),),
                    percent: items.finishedLessons!/items.totalLessons!,
                    barRadius: Radius.circular(AppRadius.r10),
                    progressColor: AppColors.mainColor2,
                  ):
                      const SizedBox.shrink()
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: width*0.02),
                  //   child: Text(LocaleKeys.downloadCertificate.tr(),style: Styles.textStyle12.copyWith(color: AppColors.mainColor2,
                  //   fontFamily: AppFonts.almaraiBold,
                  //   decoration: TextDecoration.underline,decorationColor:AppColors.mainColor2 )),
                  // )

                ],
              ),
            ),
          ],
        ),
      ),
    );

  }
}
