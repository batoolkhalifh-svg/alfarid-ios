import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:alfarid/screen/student/course_details/view/widgets/course_vedio.dart';
import 'package:alfarid/screen/student/exam/view/exam_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/local/app_cached.dart';
import '../../../../../core/local/cache_helper.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../core/widgets/custom_alert_dialogue.dart';
import '../../../../../core/widgets/custom_arrow.dart';
import '../../../../../core/widgets/custom_btn.dart';
import '../../../../../core/widgets/custom_error.dart';
import '../../../../../core/widgets/custom_loading.dart';
import '../../../../../core/widgets/custom_toast.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../teacher_profile/view/widgets/tab_item.dart';
import '../../controller/course_details_cubit.dart';
import 'about_course.dart';
import 'course_list_vedios.dart';

class CourseDetailsBody extends StatelessWidget {
  final int id;
  const CourseDetailsBody({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<CourseDetailsCubit>(
                create: (context) => CourseDetailsCubit()..getCourseDetails(id: id),
            child: BlocBuilder<CourseDetailsCubit, CourseDetailsStates>(builder: (context, state) {
              var cubit = CourseDetailsCubit.get(context);
              return  SafeArea(
                child: Column(
                  children: [
                    CustomArrow(text: LocaleKeys.courseDetails.tr(),),
                    state is CourseDetailsLoadingState? Padding(
                      padding:  EdgeInsets.only(top: width*0.25),
                      child: const CustomLoading(fullScreen: true,),
                    ):
                    state is CourseDetailsErrorState ? CustomError(title: state.msg, onPressed: (){cubit.getCourseDetails(id: id);}):
                    Expanded(
                      child: Padding(
                        padding:EdgeInsets.symmetric(horizontal: width * 0.07, vertical: width * 0.02),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              state is CourseDetailsSChangeVideoState ?Padding(
                                padding:EdgeInsets.symmetric(vertical:height*.08),
                                child: const CustomLoading(),
                              ):
                               CourseDetailsVideo(path:cubit.courseDetailsModel!.data!.sections![cubit.currentSection].lessons![cubit.currentLesson].video.toString(),
                                 cubit: cubit,lessonId: cubit.courseDetailsModel!.data!.sections![cubit.currentSection].lessons![cubit.currentLesson].id!),
                              Padding(
                                padding: EdgeInsets.only(top: height * 0.02),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                         cubit.courseDetailsModel!.data!.subject.toString(),
                                          style: Styles.textStyle14
                                              .copyWith(color: AppColors.mainColor),
                                        ),
                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.center,
                                        //   children: [
                                        //     Text("4.2",style: Styles.textStyle14.copyWith(color: AppColors.blackColor)),
                                        //     SizedBox(width: width*0.01,),
                                        //     Image.asset(AppImages.star,width: width*0.04)
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical:width*0.01),
                                      child: Text(cubit.courseDetailsModel!.data!.name.toString(),style: Styles.textStyle12.copyWith(color: AppColors.blackColor)),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical:width*0.01,horizontal:width*0.018 ),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(AppRadius.r8)
                                          ),
                                          child: Text(cubit.courseDetailsModel!.data!.price.toString(),style: Styles.textStyle14.copyWith(fontFamily:AppFonts.mulishExtraBold,color: AppColors.mainColor),),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(AppImages.clock),
                                            SizedBox(width: width*0.01),
                                            Text(cubit.courseDetailsModel!.data!.duration.toString(),style: Styles.textStyle10.copyWith(color: AppColors.blackColor),),
                                            Text(" | ",style: Styles.textStyle20.copyWith(color: AppColors.blackColor),),
                                            SvgPicture.asset(AppImages.video),
                                            SizedBox(width: width*0.01),
                                            Padding(
                                              padding:  EdgeInsets.only(top: width*0.01),
                                              child: Text(cubit.courseDetailsModel!.data!.totalLessons.toString(),style: Styles.textStyle10.copyWith(color: AppColors.blackColor),),
                                            ),
                                            SizedBox(width: width*0.01),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              ///tabs
                              Padding(
                                padding:  EdgeInsets.symmetric(horizontal: 0,vertical: width*0.038),
                                child: Column(
                                  children: [
                                    Row(
                                        children:[
                                          TabItem(
                                            onTap: (){
                                              cubit.changeTabs(0);
                                            },
                                            title: LocaleKeys.aboutCourse.tr(),
                                            isSelected: cubit.tab==0 ? true :false,),
                                          const Spacer(),
                                          TabItem(
                                            onTap: (){
                                              cubit.changeTabs(1);
                                            },
                                            title: LocaleKeys.content.tr(),isSelected: cubit.tab==1 ? true :false,),
                                        ]
                                    ),
                                    Container(
                                      height: 1,
                                      width: width,
                                      color: AppColors.grayColor,
                                    ),
                          
                                    SizedBox(
                                      height: height*0.39,
                                      child: cubit.tab==0 ?const  AboutCourse(): const CourseListVideos(),
                                    ),
                                    CacheHelper.getData(key: AppCached.isApple)==true?
                                        const SizedBox.shrink():
                                    cubit.courseDetailsModel!.data!.isSubscribed==true?
                                    CustomButton(text: LocaleKeys.startTest.tr(), onPressed: (){
                                      cubit.courseDetailsModel!.data!.isCompleted==false?
                                      showToast(text: LocaleKeys.youShouldCompleteCourse.tr(), state: ToastStates.error):
                                      cubit.courseDetailsModel!.data!.isExamToken==true?
                                      showToast(text: LocaleKeys.youPassedTheExam.tr(), state: ToastStates.error):
                                      navigateTo(widget: ExamScreen(id:cubit.courseDetailsModel!.data!.id!, isLieutenant: false,));
                                    }, widthBtn: width*0.85):
                                    state is SubscribeLoadingState? const CustomLoading():
                                    CustomButton(text: LocaleKeys.subscribeNow.tr(), onPressed: (){
                                      CacheHelper.getData(key: AppCached.token)==null?
                                      showDialog(context: context, builder: (context)=>const CustomAlertDialog()):
                                      cubit.subScribe(id: 1);
                                    }, widthBtn: width*0.85)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }))


    );
  }
}