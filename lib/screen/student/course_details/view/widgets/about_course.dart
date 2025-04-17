import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:alfarid/core/utils/styles.dart';
import 'package:alfarid/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/size.dart';
import '../../../../common/all_chat/individual/chat_details/view/chat_details_screen.dart';
import '../../controller/course_details_cubit.dart';

class AboutCourse extends StatelessWidget {
  const AboutCourse({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseDetailsCubit, CourseDetailsStates>(builder: (context, state) {
      var cubit = CourseDetailsCubit.get(context);
      return   Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height*0.02),
          Text(LocaleKeys.lecture.tr(),style: Styles.textStyle14.copyWith(color: AppColors.blackColor),),
          SizedBox(height: height*0.015),
          Row(
            children: [
              CircleAvatar(
                radius: AppRadius.r28,
                backgroundImage: NetworkImage(cubit.courseDetailsModel!.data!.teacher!.image!),
              ),
              SizedBox(width: width*0.02,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cubit.courseDetailsModel!.data!.teacher!.name.toString(),style: Styles.textStyle14.copyWith(color: AppColors.blackColor),),
                  SizedBox(height:  width*0.01),
                  Text(cubit.courseDetailsModel!.data!.teacher!.subject ?? "",style: Styles.textStyle12.copyWith(color: AppColors.mainColor,fontWeight: FontWeight.bold),)
                ],
              ),
              const Spacer(),
              GestureDetector(
                  onTap: (){
                    cubit.createUsers(id: cubit.courseDetailsModel!.data!.teacher!.id!,
                        name: cubit.courseDetailsModel!.data!.teacher!.name.toString(),
                        image: cubit.courseDetailsModel!.data!.teacher!.image.toString());
                    navigateTo(widget: ChatDetailsScreen(
                      id:'t_${cubit.courseDetailsModel!.data!.teacher!.id.toString()}' ,
                      receiverName: cubit.courseDetailsModel!.data!.teacher!.name.toString(),
                      recImg: cubit.courseDetailsModel!.data!.teacher!.image.toString() ,));
                  },
                  child: SvgPicture.asset(AppImages.chat))
            ],
          ),
          Container(
            margin: EdgeInsetsDirectional.symmetric(vertical: width*0.06),
            height: 1,
            width: width,
            color: AppColors.grayColorOp.withOpacity(.2),
          ),
          Text(LocaleKeys.aboutCourse.tr(),style: Styles.textStyle14.copyWith(color: AppColors.blackColor),),

          Expanded(
            child: Padding(
              padding:  EdgeInsets.symmetric(vertical: height*0.02),
              child: SingleChildScrollView(
                  child: Text(cubit.courseDetailsModel!.data!.desc.toString(),
                    style: Styles.textStyle14.copyWith(color: AppColors.grayColor,fontFamily: AppFonts.almaraiRegular),
                  )),
            ),
          )
        ],
      ); });


  }
}