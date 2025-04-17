import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/utils/images.dart';
import '../../../../../../core/utils/size.dart';
import '../../../../../../core/utils/styles.dart';
import '../../controller/home_cubit.dart';
import '../../controller/home_states.dart';


class CustomTitleCourseList extends StatelessWidget {
  final bool? withOutPadding;
  const CustomTitleCourseList({super.key, this.withOutPadding});

  @override
  Widget build(BuildContext context) {
    return   BlocBuilder<HomeCubit, HomeStates>(builder: (context, state) {
      final cubit = HomeCubit.get(context);
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal:withOutPadding==true?0: width * 0.03),
          child: Row(
            children: List.generate(
                cubit.subjectsModel!.data!.length,
                    (index) => GestureDetector(
                  onTap: () {
                    cubit.changeCourses(index: index, curSubId:  cubit.subjectsModel!.data![index].id!);
                    cubit.fetchCourse(first: false);
                    cubit.fetchTeacher(first: false);
                  },
                  child: Container(
                    margin: EdgeInsetsDirectional.symmetric(
                        horizontal: width * 0.013,
                        vertical: width * 0.03),
                    padding: EdgeInsetsDirectional.symmetric(
                        horizontal: width * 0.05,
                        vertical: width * 0.02),
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(AppRadius.r8),
                        color: cubit.currentCourse == index
                            ? null
                            : Colors.white,
                        image: cubit.currentCourse == index
                            ? const DecorationImage(
                            image: AssetImage(AppImages.backBtn),fit: BoxFit.fill)
                            : null),
                    child: Text(
                      cubit.subjectsModel!.data![index].name.toString(),
                      style: Styles.textStyle14.copyWith(
                          color:cubit.currentCourse == index? Colors.white: AppColors.blackColor,
                          fontFamily: AppFonts.almaraiRegular),
                    ),
                  ),
                )),
          ),
        ),
      );
    });
  }
}
