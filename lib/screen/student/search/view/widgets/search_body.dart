import 'package:alfarid/core/widgets/custom_loading.dart';
import 'package:alfarid/core/widgets/custom_textfield.dart';
import 'package:alfarid/core/widgets/empty_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/my_navigate.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_arrow.dart';
import '../../../../../core/widgets/custom_btn.dart';
import '../../../../../core/widgets/custom_course_item.dart';
import '../../../../../core/widgets/custom_error.dart';
import '../../../../../core/widgets/custom_toast.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../course_details/view/course_details_screen.dart';
import '../../../excellent_teacher/view/widgets/excellent_teacher_item.dart';
import '../../controller/search_cubit.dart';

class SearchBody extends StatelessWidget {
  const SearchBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider<SearchCubit>(
            create: (context) => SearchCubit(),
            child:
                BlocBuilder<SearchCubit, BaseStates>(builder: (context, state) {
              var cubit = SearchCubit.get(context);
              return SafeArea(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    CustomArrow(text: LocaleKeys.search.tr(),),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: width * 0.07, vertical: width * 0.03),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextField(ctrl: cubit.searchCtrl,suffixIcon: InkWell(
                                    onTap: (){
                                      cubit.searchCtrl.text.isEmpty? showToast(text: LocaleKeys.addWordToSearch.tr(), state: ToastStates.error): cubit.search();
                                      FocusScope.of(context).unfocus();
                                    },
                                    child: Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: width*0.018),
                                      child: Image.asset(AppImages.filter,width: width*0.06),
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: height * 0.022, horizontal: width * 0.03),
                                  withOutBorderColor: true,),
                                    SizedBox(height: height*0.015),
                                  cubit.searchCtrl.text.isEmpty? Center(child: EmptyList(img: AppImages.emptySearch, text: LocaleKeys.addWordToSearch.tr())):
                                  Row(
                                      children: [
                                        Text("${LocaleKeys.resultSearch.tr()}  ", style: Styles.textStyle14.copyWith(color: AppColors.blackColor),),
                                        Text(cubit.searchCtrl.text ?? "", style: Styles.textStyle14.copyWith(color: AppColors.mainColor2),),
                                      ],
                                    ),
                                    SizedBox(height: height*0.015),
                                  cubit.searchModel==null?const SizedBox.shrink():
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomButton(hit: height * 0.062,text: LocaleKeys.courses.tr(), onPressed: (){cubit.changeCourse(true);}, widthBtn: width*0.41,color: cubit.isCurrent==true?true:false),
                                        CustomButton(hit: height * 0.062,text: LocaleKeys.teachers.tr(), onPressed: (){cubit.changeCourse(false);}, widthBtn: width*0.41,color: cubit.isCurrent==false?true:false),
                                      ],
                                    ),
                                    SizedBox(height: height*0.013),
                                  state is BaseStatesLoadingState ? const CustomLoading(fullScreen: true,):
                                  state is BaseStatesErrorState ? Padding(
                                    padding: EdgeInsets.only(top: width*0.2),
                                    child: CustomError(title: state.msg, onPressed: (){cubit.search();}),
                                  ):
                                  cubit.searchModel==null?const SizedBox.shrink():

                                    SizedBox(
                                      height: height*0.7,
                                      child:cubit.isCurrent==true?
                                          cubit.searchModel!.data!.courses!.items!.isEmpty? Center(child: EmptyList(img: AppImages.emptySearch, text: LocaleKeys.noSearch.tr())):
                                      ListView.separated(
                                        padding: EdgeInsetsDirectional.symmetric(vertical: height*0.024),
                                        itemBuilder: (context, index){
                                        return CustomCourseItem(
                                        onTap:(){ navigateTo(widget: CourseDetailsScreen(id: cubit.searchModel!.data!.courses!.items![index].id!,));
                                        },
                                        onTapSave: (){cubit.toggleSaved(id: cubit.searchModel!.data!.courses!.items![index].id!,index: index);},
                                        img: cubit.searchModel!.data!.courses!.items![index].image.toString(),
                                        title: cubit.searchModel!.data!.courses!.items![index].name.toString(),
                                        subTitle: cubit.searchModel!.data!.courses!.items![index].desc.toString(),
                                        price: cubit.searchModel!.data!.courses!.items![index].price.toString(),
                                        isSaves:cubit.searchModel!.data!.courses!.items![index].isFavorite,
                                        teacherName: cubit.searchModel!.data!.courses!.items![index].teacher!.name.toString(),
                                        );
                                        }, separatorBuilder: (context, index){
                                        return SizedBox(height: height*0.018);
                                        }, itemCount:cubit.searchModel!.data!.courses!.items!.length):
                                      cubit.searchModel!.data!.teachers!.items!.isEmpty? Center(child: EmptyList(img: AppImages.emptySearch, text: LocaleKeys.noSearch.tr())):
                                      ListView.separated(
                                          padding: EdgeInsetsDirectional.symmetric(vertical: height*0.024),
                                          itemBuilder: (context, index){
                                            return ExcellentTeacherItem(
                                              id: cubit.searchModel!.data!.teachers!.items![index].id!,
                                              img:cubit.searchModel!.data!.teachers!.items![index].image.toString() ,
                                             name: cubit.searchModel!.data!.teachers!.items![index].name.toString(),
                                            rate: cubit.searchModel!.data!.teachers!.items![index].rate.toString(),
                                            subject: "");
                                          }, separatorBuilder: (context, index){
                                        return SizedBox(height: height*0.018);
                                      }, itemCount:cubit.searchModel!.data!.teachers!.items!.length),
                                    ),


                        
                            ])),
                      ),
                    ),
                  ]));
            })));
  }
}
