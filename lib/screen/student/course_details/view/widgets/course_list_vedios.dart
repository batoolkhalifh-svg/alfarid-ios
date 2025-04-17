import 'package:alfarid/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/size.dart';
import '../../controller/course_details_cubit.dart';

class CourseListVideos extends StatelessWidget {
  const CourseListVideos({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseDetailsCubit, CourseDetailsStates>(builder: (context, state) {
      var cubit = CourseDetailsCubit.get(context);
      return   ListView.separated(
        padding: EdgeInsets.symmetric(vertical: height*0.015),
        itemBuilder: (context,index1) {
          return Column(
            children: [
              Row(
                children: [
                  Text(cubit.courseDetailsModel!.data!.sections![index1].name.toString(),style: Styles.textStyle14.copyWith(color: AppColors.blackColor,fontFamily: AppFonts.almaraiRegular),),
                  const Spacer(),
                  SvgPicture.asset(AppImages.clock),
                  SizedBox(width: width*0.01),
                  Text(cubit.courseDetailsModel!.data!.sections![index1].totalDuration.toString(),style: Styles.textStyle10.copyWith(color: AppColors.blackColor),),
                ],
              ),
              ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: height*0.02),
                  shrinkWrap: true, // Important
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: (){
                      cubit.changeVideo(indexSection: index1,indexLesson: index,id: cubit.courseDetailsModel!.data!.id);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.r15)),
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.035, vertical: width * 0.04),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(width*0.024),
                            decoration: const BoxDecoration(shape: BoxShape.circle,color: AppColors.mainColor),
                            child: Text(
                              "${index+1}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: AppFonts.jost,
                                  fontSize: AppFonts.t10),
                            ),
                          ),
                          SizedBox(width: width*0.02,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(cubit.courseDetailsModel!.data!.sections![index1].lessons![index].name.toString(),style: Styles.textStyle12.copyWith(color: AppColors.mainColor),),
                                SizedBox(height: height*0.01,),
                                Row(
                                  children: [
                                    Icon(Icons.access_time,color:const Color(0xffCBCBCB),size: width*0.04,),
                                    SizedBox(width: width*0.01),
                                    Text(cubit.courseDetailsModel!.data!.sections![index1].lessons![index].duration.toString() ,style: Styles.textStyle10.copyWith(color: const Color(0xffCBCBCB)),)
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          cubit.courseDetailsModel!.data!.sections![index1].lessons![index].isFree==true?
                          SvgPicture.asset(AppImages.play) :SvgPicture.asset(AppImages.editPass,color: AppColors.grayColor,)
                        ],
                      ),
                    ),
                  ),
                  separatorBuilder: (context, index) => SizedBox(
                    height: height * 0.02,
                  ),
                  itemCount: cubit.courseDetailsModel!.data!.sections![index1].lessons!.length),
            ],
          );
        }, separatorBuilder: (BuildContext context, int index) => SizedBox(height: height * 0.02,),
           itemCount:cubit.courseDetailsModel!.data!.sections!.length,
      );
    });


  }
}