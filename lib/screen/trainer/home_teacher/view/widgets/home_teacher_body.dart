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
        child: BlocBuilder<HomeTeacherCubit, HomeTeacherStates>(builder: (context, state) {
          var cubit = HomeTeacherCubit.get(context);
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: ()=>navigateTo(widget: const TimetableScreen()),
              backgroundColor: AppColors.mainColor,
              child: Text(
                LocaleKeys.timetable.tr(),
                style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: width * 0.05, top: height * 0.02, right: width * 0.05),
                      child: state is LoadingHomeState
                          ? Padding(
                              padding: EdgeInsets.only(top: width * 0.25),
                              child: const Center(
                                  child: CustomLoading(
                                fullScreen: true,
                              )),
                            )
                          : state is ErrorHomeState
                              ? Padding(
                                  padding: EdgeInsets.only(top: width * 0.4),
                                  child: CustomError(
                                      title: state.msg,
                                      onPressed: () {
                                        cubit.fetchStudentHome();
                                      }),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CustomTeacherHeader(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomCard(
                                          img: AppImages.totalRequests,
                                          text1: LocaleKeys.totalRequests.tr(),
                                          text2: "${cubit.studentHomeModel!.data!.reservationsCount.toString()}${LocaleKeys.request.tr()}",
                                        ),
                                        CustomCard(
                                          img: AppImages.totalCourses,
                                          text1: LocaleKeys.coursesNumbers.tr(),
                                          text2: "${cubit.studentHomeModel!.data!.courses.toString()}${LocaleKeys.courses.tr()}",
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: width * 0.03),
                                      child: Text(
                                        LocaleKeys.shareAndTeach.tr(),
                                        style: Styles.textStyle16.copyWith(color: AppColors.blackColor2, fontFamily: AppFonts.almaraiBold),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomCard2(
                                          img: AppImages.live,
                                          text1: LocaleKeys.startLive.tr(),
                                          text2: LocaleKeys.startLiveWithStudents.tr(),
                                          textBtn: LocaleKeys.startRecording.tr(),
                                          onTap: () {
                                            navigateTo(widget: const StartLiveScreen());
                                          },
                                        ),
                                        CustomCard2(
                                          img: AppImages.uploadFile,
                                          text1: LocaleKeys.uploadEducationalFile.tr(),
                                          text2: LocaleKeys.addPdf.tr(),
                                          textBtn: LocaleKeys.downloadFile.tr(),
                                          onTap: () {
                                            navigateTo(widget: const UploadFileScreen());
                                          },
                                        ),
                                      ],
                                    ),
                                    if (CacheHelper.getData(key: AppCached.isApple) == false) ...[
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: width * 0.03),
                                        child: Text(
                                          LocaleKeys.bookingRequests.tr(),
                                          style:
                                              Styles.textStyle16.copyWith(color: AppColors.blackColor2, fontFamily: AppFonts.almaraiBold),
                                        ),
                                      ),
                                      cubit.studentHomeModel!.data!.reservations!.isEmpty
                                          ? Center(
                                              child: Text(LocaleKeys.noReservations.tr(),
                                                  style: Styles.textStyle16
                                                      .copyWith(color: AppColors.mainColorText, fontFamily: AppFonts.almaraiBold)))
                                          : SizedBox(
                                              height: context.locale.languageCode == "ar" ? height * 0.245 : height * 0.24,
                                              child: ListView.separated(
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
                                                separatorBuilder: (BuildContext context, int index) {
                                                  return SizedBox(height: height * 0.01);
                                                },
                                                itemCount: cubit.studentHomeModel!.data!.reservations!.length,
                                              ),
                                            )
                                    ],
                                  ],
                                ),
                    )
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
