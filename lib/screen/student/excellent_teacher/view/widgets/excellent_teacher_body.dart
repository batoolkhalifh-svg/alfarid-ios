import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/widgets/custom_arrow.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../home/view/controller/home_cubit.dart';
import '../../../home/view/controller/home_states.dart';
import 'excellent_teacher_item.dart';

class ExcellentTeacherBody extends StatelessWidget {
   ExcellentTeacherBody({super.key});
  final  ScrollController controllerTeacher=ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  BlocBuilder<HomeCubit, HomeStates>(builder: (context, state) {
      final cubit = HomeCubit.get(context);
      controllerTeacher.addListener(() {
        if(controllerTeacher.position.maxScrollExtent==controllerTeacher.offset){
          cubit.currentPageTeacher==cubit.teacherModel!.data!.paginate!.totalPages ?
          null: cubit.nextTeachers();
        }
      });
      return SafeArea(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomArrow(text: LocaleKeys.distinguishedTeachers.tr(),),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.07, vertical: width * 0.03),
                      child: ListView.separated(
                        controller: controllerTeacher,
                          padding: EdgeInsetsDirectional.symmetric(vertical: height*0.024),
                          itemBuilder: (context, index){
                            return   ExcellentTeacherItem(
                              id: cubit.dataTeacher[index].id!,
                              name: cubit.dataTeacher[index].name.toString(),
                              img:cubit.dataTeacher[index].image.toString(),
                              subject:cubit.dataTeacher[index].courses!.isEmpty? "": cubit.dataTeacher[index].courses![0].subject.toString(),
                              rate: cubit.dataTeacher[index].rate.toString(),);
                          }, separatorBuilder: (context, index){
                        return SizedBox(height: height*0.018);
                      }, itemCount: cubit.dataTeacher.length)),
                ),
              ]));
    }));
  }
}
