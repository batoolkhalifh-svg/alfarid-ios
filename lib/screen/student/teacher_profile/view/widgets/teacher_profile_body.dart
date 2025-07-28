import 'package:alfarid/core/local/app_cached.dart';
import 'package:alfarid/core/local/cache_helper.dart';
import 'package:alfarid/core/utils/colors.dart';
import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:alfarid/core/utils/size.dart';
import 'package:alfarid/core/utils/styles.dart';
import 'package:alfarid/core/widgets/custom_btn.dart';
import 'package:alfarid/core/widgets/custom_loading.dart';
import 'package:alfarid/screen/student/course_details/view/course_details_screen.dart';
import 'package:alfarid/screen/student/teacher_profile/view/widgets/booking_sheet.dart';
import 'package:alfarid/screen/student/teacher_profile/view/widgets/review_item.dart';
import 'package:alfarid/screen/student/teacher_profile/view/widgets/tab_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_alert_dialogue.dart';
import '../../../../../core/widgets/custom_arrow.dart';
import '../../../../../core/widgets/custom_course_item.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../common/all_chat/individual/chat_details/view/chat_details_screen.dart';
import '../../../add_rate/view/add_rate_screen.dart';
import '../../controller/teacher_profile_cubit.dart';
import 'custom_button_teacher.dart';
import 'custom_row_teacher.dart';

class TeacherProfileBody extends StatelessWidget {
  final int id;

  const TeacherProfileBody({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider<TeacherProfileCubit>(
            create: (context) => TeacherProfileCubit()..fetchTeacherProfile(id: id),
            child: BlocBuilder<TeacherProfileCubit, BaseStates>(builder: (context, state) {
              var cubit = TeacherProfileCubit.get(context);
              return state is BaseStatesLoadingState
                  ? const Center(
                      child: CustomLoading(
                      fullScreen: true,
                    ))
                  : Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                      Container(
                        width: width,
                        color: Colors.white,
                        child: SafeArea(
                          child: Column(
                            children: [
                              CustomArrow(
                                text: LocaleKeys.teacherProfile.tr(),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: AppRadius.r45,
                                    backgroundImage: NetworkImage(cubit.teacherProfileModel!.data!.image.toString()),
                                  ),
                                  SizedBox(
                                    height: width * 0.01,
                                  ),
                                  Text(
                                    cubit.teacherProfileModel!.data!.name.toString(),
                                    style: Styles.textStyle16.copyWith(color: AppColors.blackColor, fontFamily: AppFonts.almaraiBold),
                                  ),
                                  SizedBox(
                                    height: width * 0.01,
                                  ),
                                  Text(
                                    cubit.teacherProfileModel!.data!.courses!.isEmpty
                                        ? ""
                                        : cubit.teacherProfileModel!.data!.courses![0].subject.toString(),
                                    style: Styles.textStyle12.copyWith(color: AppColors.mainColor),
                                  ),
                                  SizedBox(height: width * 0.06),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CustomRowTeacher(
                                        number: cubit.teacherProfileModel!.data!.rateCount.toString(),
                                        text: LocaleKeys.reviewNumbers.tr(),
                                      ),
                                      CustomRowTeacher(
                                        number: cubit.teacherProfileModel!.data!.studentsCount.toString(),
                                        text: LocaleKeys.studentNumbers.tr(),
                                      ),
                                      CustomRowTeacher(
                                        number: cubit.teacherProfileModel!.data!.coursesCount.toString(),
                                        text: LocaleKeys.coursesNumbers.tr(),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: height * 0.02),
                                    child: Row(
                                      mainAxisAlignment: CacheHelper.getData(key: AppCached.isApple) == true
                                          ? MainAxisAlignment.center
                                          : MainAxisAlignment.spaceEvenly,
                                      children: [
                                        CacheHelper.getData(key: AppCached.isApple) == true
                                                ? const SizedBox()
                                                : CustomButtonTeacher(
                                                    isDirectBooking: true,
                                                    onTap: () {
                                                      if(cubit.teacherProfileModel!.data!.availability!.isNotEmpty)
                                                      showModalBottomSheet(
                                                        isScrollControlled: true,
                                                        context: context, builder: (_) => BlocProvider.value(
                                                        value: context.read<TeacherProfileCubit>(),
                                                        child: const BookingSheet(),
                                                      ),);
                                                      // CacheHelper.getData(key: AppCached.token) == null
                                                      //     ? showDialog(context: context, builder: (context) => const CustomAlertDialog())
                                                      //     : cubit.directReserve(id: id);
                                                    },
                                                  ),
                                        CustomButtonTeacher(
                                          isDirectBooking: false,
                                          onTap: CacheHelper.getData(key: AppCached.token) == null
                                              ? () {
                                                  showDialog(context: context, builder: (context) => const CustomAlertDialog());
                                                }
                                              : () {
                                                  cubit.createUsers(
                                                      id: cubit.teacherProfileModel!.data!.id!,
                                                      name: cubit.teacherProfileModel!.data!.name.toString(),
                                                      image: cubit.teacherProfileModel!.data!.image.toString());
                                                  navigateTo(
                                                      widget: ChatDetailsScreen(
                                                    id: 't_${cubit.teacherProfileModel!.data!.id!}',
                                                    receiverName: cubit.teacherProfileModel!.data!.name.toString(),
                                                    recImg: cubit.teacherProfileModel!.data!.image.toString(),
                                                  ));
                                                },
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),

                      ///tabs
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: width * 0.07, vertical: width * 0.038),
                          child: Column(
                            children: [
                              Row(children: [
                                TabItem(
                                  onTap: () {
                                    cubit.changeTabs(0);
                                  },
                                  title: LocaleKeys.rates.tr(),
                                  isSelected: cubit.tab == 0 ? true : false,
                                ),
                                const Spacer(),
                                TabItem(
                                  onTap: () {
                                    cubit.changeTabs(1);
                                  },
                                  title: LocaleKeys.courses.tr(),
                                  isSelected: cubit.tab == 1 ? true : false,
                                ),
                              ]),
                              Container(
                                height: 1,
                                width: width,
                                color: AppColors.grayColor,
                              ),
                              cubit.tab == 0
                                  ? Expanded(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: List.generate(
                                              cubit.teacherProfileModel!.data!.rates!.length,
                                              (index) => ReviewItem(
                                                    image: cubit.teacherProfileModel!.data!.rates![index].student!.image!,
                                                    name: cubit.teacherProfileModel!.data!.rates![index].student!.name!,
                                                    rate: cubit.teacherProfileModel!.data!.rates![index].rate!,
                                                    commented: cubit.teacherProfileModel!.data!.rates![index].comment!,
                                                    createAt: cubit.teacherProfileModel!.data!.rates![index].createdAt!,
                                                  )),
                                        ),
                                      ),
                                    )
                                  : Expanded(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: List.generate(
                                              cubit.teacherProfileModel!.data!.courses!.length,
                                              (index) => CustomCourseItem(
                                                    isSaves: cubit.teacherProfileModel!.data!.courses![index].isFavorite,
                                                    img: cubit.teacherProfileModel!.data!.courses![index].image.toString(),
                                                    title: cubit.teacherProfileModel!.data!.courses![index].name.toString(),
                                                    subTitle: cubit.teacherProfileModel!.data!.courses![index].desc.toString(),
                                                    price: cubit.teacherProfileModel!.data!.courses![index].price.toString(),
                                                    teacherName: cubit.teacherProfileModel!.data!.courses![index].teacher!.name.toString(),
                                                    onTap: () {
                                                      navigateTo(
                                                          widget: CourseDetailsScreen(
                                                              id: cubit.teacherProfileModel!.data!.courses![index].id!));
                                                    },
                                                    onTapSave: () {
                                                      cubit.toggleSaved(
                                                          id: cubit.teacherProfileModel!.data!.courses![index].id!, index: index);
                                                    },
                                                  )),
                                        ),
                                      ),
                                    ),
                              CustomButton(
                                  text: LocaleKeys.addReviews.tr(),
                                  onPressed: () {
                                    CacheHelper.getData(key: AppCached.token) == null
                                        ? showDialog(context: context, builder: (context) => const CustomAlertDialog())
                                        : navigateTo(
                                            widget: AddRateScreen(
                                            id: cubit.teacherProfileModel!.data!.id!,
                                          ));
                                  },
                                  widthBtn: width * 0.85)
                            ],
                          ),
                        ),
                      )
                    ]);
            })));
  }
}
