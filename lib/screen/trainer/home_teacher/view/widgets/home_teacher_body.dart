import 'package:alfarid/core/utils/images.dart';
import 'package:alfarid/core/utils/size.dart';
import 'package:alfarid/core/utils/styles.dart';
import 'package:alfarid/generated/locale_keys.g.dart';
import 'package:alfarid/screen/trainer/home_teacher/controller/home_teacher_states.dart';
import 'package:alfarid/screen/trainer/timetable/view/timetable_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/local/app_cached.dart';
import '../../../../../core/local/cache_helper.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/my_navigate.dart';
import '../../../../../core/widgets/custom_error.dart';
import '../../../../../core/widgets/custom_loading.dart';
import '../../../start_live/view/start_live_screen.dart';
import '../../../start_vr/view/start_vr_screen.dart';
import '../../../upload_file/view/upload_file_screen.dart';
import '../../controller/home_teacher_cubit.dart';
import 'custom_card.dart';
import 'custom_card2.dart';
import 'custom_teacher_header.dart';
import 'list_item.dart';

class HomeTeacherBody extends StatelessWidget {
  const HomeTeacherBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeTeacherCubit>(
      create: (context) => HomeTeacherCubit()..fetchStudentHome(),
      child: BlocBuilder<HomeTeacherCubit, HomeTeacherStates>(
        builder: (context, state) {
          var cubit = HomeTeacherCubit.get(context);

          return Scaffold(
            backgroundColor: const Color(0xFFF5F7FB),

            // 🔥 Floating Button (Timetable)
            floatingActionButton: FloatingActionButton(
              onPressed: () => navigateTo(widget: const TimetableScreen()),
              backgroundColor: AppColors.mainColor,
              child: const Icon(Icons.calendar_month, color: Colors.white),
            ),

            body: SafeArea(
              child: state is LoadingHomeState
                  ? const Center(child: CustomLoading(fullScreen: true))
                  : state is ErrorHomeState
                  ? Center(
                child: CustomError(
                  title: state.msg,
                  onPressed: () {
                    cubit.fetchStudentHome();
                  },
                ),
              )
                  : SingleChildScrollView(
                child: Column(
                  children: [
                    // 🔵 HEADER
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.mainColor,
                            AppColors.blackColor2,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30.r),
                          bottomRight: Radius.circular(30.r),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomTeacherHeader(),
                          SizedBox(height: 15.h),
                          Text(
                            LocaleKeys.shareAndTeach.tr(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 📊 CARDS
                          Row(
                            children: [
                              Expanded(
                                child: CustomCard(
                                  img: AppImages.totalRequests,
                                  text1: LocaleKeys.totalRequests.tr(),
                                  text2:
                                  "${cubit.studentHomeModel!.data!.reservationsCount}${LocaleKeys.request.tr()}",
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: CustomCard(
                                  img: AppImages.totalCourses,
                                  text1: LocaleKeys.coursesNumbers.tr(),
                                  text2:
                                  "${cubit.studentHomeModel!.data!.courses}${LocaleKeys.courses.tr()}",
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 20.h),

                          // ⚡ ACTION CARDS
                          Text(
                            LocaleKeys.shareAndTeach.tr(),
                            style: Styles.textStyle16.copyWith(
                              color: AppColors.blackColor2,
                              fontFamily: AppFonts.almaraiBold,
                            ),
                          ),

                          SizedBox(height: 12.h),

                          Column(
                            children: [

                              // 🟢 ROW 1: Live + VR
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomCard2(
                                      img: AppImages.llive,
                                      text1: LocaleKeys.startLive.tr(),
                                      text2: LocaleKeys.startLiveWithStudents.tr(),
                                      textBtn: LocaleKeys.startRecording.tr(),
                                      onTap: () {
                                        navigateTo(widget: const StartLiveScreen());
                                      },
                                    ),
                                  ),

                                  SizedBox(width: 12.w),

                                  Expanded(
                                    child: CustomCard2(
                                      img: AppImages.lab, // لاحقًا VR icon
                                      text1: LocaleKeys.vr.tr(),
                                      text2: LocaleKeys.details.tr(),
                                      textBtn: LocaleKeys.bvr.tr(),
                                      onTap: () {
                                        navigateTo(
                                          widget: const StartVrScreen(),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 12.h),

                              // 🔵 ROW 2: Upload File (Full width)

            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child: CustomCard2(
                  img: AppImages.file,
                  text1: LocaleKeys.uploadEducationalFile.tr(),
                  text2: LocaleKeys.addPdf.tr(),
                  textBtn: LocaleKeys.downloadFile.tr(),
                  onTap: () {
                    navigateTo(widget: const UploadFileScreen());
                  },
                ),
              ),
            ),

                            ],
                          ),

                          SizedBox(height: 25.h),

                          // 📚 RESERVATIONS
                          if (CacheHelper.getData(key: AppCached.isApple) == false) ...[
                            Text(
                              LocaleKeys.bookingRequests.tr(),
                              style: Styles.textStyle16.copyWith(
                                color: AppColors.blackColor2,
                                fontFamily: AppFonts.almaraiBold,
                              ),
                            ),

                            SizedBox(height: 12.h),

                            cubit.studentHomeModel!.data!.reservations!.isEmpty
                                ? Padding(
                              padding: EdgeInsets.only(top: 20.h),
                              child: Text(
                                LocaleKeys.noReservations.tr(),
                                style: Styles.textStyle16.copyWith(
                                  color: AppColors.mainColorText,
                                ),
                              ),
                            )
                                : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),

                              // 🔥 الحل الأساسي (حتى ما ينغطى المحتوى)
                              padding: EdgeInsets.only(bottom: 100.h),

                              itemBuilder: (context, index) {
                                return ListItem(
                                  id: cubit.studentHomeModel!.data!.reservations![index].id!,
                                  image: cubit.studentHomeModel!.data!.reservations![index].student!.image!,
                                  name: cubit.studentHomeModel!.data!.reservations![index].student!.name!,
                                  classRoom: cubit.studentHomeModel!.data!.reservations![index].student!.classroom!,
                                  onTapAccept: () {},
                                  status: cubit.studentHomeModel!.data!.reservations![index].status!,
                                );
                              },
                              separatorBuilder: (_, __) => SizedBox(height: 12.h),
                              itemCount: cubit.studentHomeModel!.data!.reservations!.length,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}