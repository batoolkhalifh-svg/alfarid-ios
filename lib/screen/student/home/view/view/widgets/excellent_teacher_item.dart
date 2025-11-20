import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/local/app_cached.dart';
import '../../../../../../core/local/cache_helper.dart';
import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/utils/images.dart';
import '../../../../../../core/utils/size.dart';
import '../../../../../../core/utils/styles.dart';
import '../../../../../../core/widgets/custom_alert_dialogue.dart';
import '../../../../teacher_profile/view/teacher_profile_screen.dart';
import '../../controller/home_cubit.dart';
import '../../controller/home_states.dart';

class ExcellentTeacherItem extends StatelessWidget {
  final int index;
  const ExcellentTeacherItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(builder: (context, state) {
      final cubit = HomeCubit.get(context);
      return  GestureDetector(
        onTap: (){
          CacheHelper.getData(key: AppCached.token) == null
              ? showDialog(context: context, builder: (context) => const CustomAlertDialog())
              :
          navigateTo(widget:TeacherProfileScreen(id: cubit.dataTeacher[index].id!));
        },
        child: Container(
          width: width*0.4,
          alignment: AlignmentDirectional.topStart,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.r8)
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsetsDirectional.all(width*0.03),
                height: height*0.13,
                width:  height*0.13,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.r8),
                    image:  DecorationImage(image: NetworkImage(cubit.dataTeacher[index].image.toString()),fit: BoxFit.fill)
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width*0.02),
                child: SizedBox(
                    width: width*0.34,
                    child: Center(child: Text(cubit.dataTeacher[index].name.toString(),style: Styles.textStyle14.copyWith(color: AppColors.mainColor2),overflow: TextOverflow.ellipsis,))),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width*0.02,vertical: width*0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(cubit.dataTeacher[index].rate.toString(),style: Styles.textStyle14.copyWith(color: AppColors.blackColor)),
                    SizedBox(width: width*0.01,),
                    Image.asset(AppImages.star,width: width*0.04)
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });

  }
}
