import 'package:alfarid/core/widgets/custom_btn.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_arrow.dart';
import '../../../../../core/widgets/custom_error.dart';
import '../../../../../core/widgets/custom_loading.dart';
import '../../../../../core/widgets/empty_list.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../controller/my_courses_cubit.dart';
import 'my_course_item.dart';

class MyCoursesBody extends StatelessWidget {
   MyCoursesBody({super.key});
 final   ScrollController controller=ScrollController();
 final   ScrollController controllerComplete=ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider<MyCoursesCubit>(
            create: (context) => MyCoursesCubit()..getCurrentCourses(),
            child: BlocBuilder<MyCoursesCubit, BaseStates>(builder: (context, state) {
              var cubit = MyCoursesCubit.get(context);
              controller.addListener(() {
                if(controller.position.maxScrollExtent==controller.offset){
                  cubit.currentPage==cubit.myCurrentCoursesModel!.data!.paginate!.totalPages ?
                  null: cubit.nextCurrentCourses();
                }
              });
              controllerComplete.addListener(() {
                if(controllerComplete.position.maxScrollExtent==controllerComplete.offset){
                  cubit.currentPageComplete==cubit.myCompleteCoursesModel!.data!.paginate!.totalPages ?
                  null: cubit.nextCompleteCourses();
                }
              });
              return SafeArea(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    CustomArrow(text: LocaleKeys.myCourses.tr(),),
                        state is BaseStatesLoadingState? Padding(
                          padding:  EdgeInsets.only(top:width*0.3),
                          child: const CustomLoading(fullScreen: true,),
                        ):
                        state is BaseStatesErrorState ? CustomError(title: state.msg, onPressed: (){cubit.getCurrentCourses();}):
                        cubit.data.isEmpty?Center(child: EmptyList(img: AppImages.emptyCourses, text: LocaleKeys.noCourses.tr())):
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.07, vertical: width * 0.03),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomButton(hit: height * 0.062,text: LocaleKeys.currentCourses.tr(), onPressed: (){cubit.changeCourse(true);}, widthBtn: width*0.41,color: cubit.isCurrent==true?true:false),
                                  CustomButton(hit: height * 0.062,text: LocaleKeys.completedCourses.tr(),
                                      onPressed: (){
                                    cubit.changeCourse(false);
                                    cubit.currentPageComplete==1? cubit.getCompleteCourses():null;
                                    }, widthBtn: width*0.41,color: cubit.isCurrent==false?true:false),
                                ],
                              ),
                              SizedBox(height: height*0.008),
                              SizedBox(
                              height: height*0.77,
                              child: cubit.isCurrent==true?
                              ListView.separated(
                                  controller: controller,
                                  padding: EdgeInsetsDirectional.symmetric(vertical: height*0.024),
                                  itemBuilder: (context, index){
                                    return  MyCourseItem(isCurrent:cubit.isCurrent, items:cubit.data[index]);
                                  }, separatorBuilder: (context, index){
                                return SizedBox(height: height*0.018);
                              }, itemCount: cubit.data.length):
                                  state is BaseStatesLoadingState3? const CustomLoading(fullScreen: true,):
                                  cubit.dataComplete.isEmpty?Center(child: EmptyList(img: AppImages.emptyCourses, text: LocaleKeys.noCourses.tr())):
                                  ListView.separated(
                                controller: controllerComplete,
                                    padding: EdgeInsetsDirectional.symmetric(vertical: height*0.024),
                                    itemBuilder: (context, index){
                                      return  MyCourseItem(isCurrent:cubit.isCurrent, items: cubit.dataComplete[index]);
                                      }, separatorBuilder: (context, index){
                                  return SizedBox(height: height*0.018);
                                }, itemCount: cubit.dataComplete.length),
                          ),

                        ])),
                  ]));
            })));
  }
}
