import 'dart:io';

import 'package:alfarid/core/utils/images.dart';
import 'package:alfarid/core/utils/size.dart';
import 'package:alfarid/core/utils/styles.dart';
import 'package:alfarid/core/widgets/custom_loading.dart';
import 'package:alfarid/generated/locale_keys.g.dart';
import 'package:alfarid/screen/common/notification/view/notification_screen.dart';
import 'package:alfarid/screen/student/bottom_nav_student/view/bottom_nav_screen.dart';
import 'package:alfarid/screen/trainer/manage_package/view/manage_package_screen.dart';
import 'package:alfarid/screen/trainer/subscribe_package/view/subscribe_package_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/local/app_cached.dart';
import '../../../../../core/local/cache_helper.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/my_navigate.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_alert_dialogue.dart';
import '../../../../../core/widgets/custom_choose_image.dart';
import '../../../../student/my_courses/view/my_course_screen.dart';
import '../../../../student/my_points/view/my_points_screen.dart';
import '../../../../student/my_saves/view/my_saves_screen.dart';
import '../../../../trainer/bottom_nav_teacher/view/bottom_nav_screen.dart';
import '../../../../trainer/live/view/teacher_live_view.dart';
import '../../../../trainer/show_files/view/show_file_screen.dart';
import '../../../auth/register_as/view/register_as_screen.dart';
import '../../../edit_password/view/edit_password_screen.dart';
import '../../../edit_profile/view/edit_profile_screen.dart';
import '../../../help_support/view/help_support_screen.dart';
import '../../controller/profile_cubit.dart';
import 'custom_profile_row.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(),
          child: BlocBuilder<ProfileCubit, BaseStates>(
              builder: (context, state) {
            var cubit = ProfileCubit.get(context);
            return SafeArea(
                child: Padding(
                  padding:  EdgeInsets.only(top: width*0.1),
                  child: CacheHelper.getData(key: AppCached.token)==null?
                  Container(
                    width: width,
                    height: height*0.6,
                    padding: EdgeInsetsDirectional.only(top: height*0.09),
                    margin: EdgeInsetsDirectional.only(top: height*0.08,end: width*0.09,start: width*0.09),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(AppRadius.r15),topLeft:Radius.circular(AppRadius.r15) )
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                          children: [
                            CustomProfileRow(text: LocaleKeys.lang.tr(),img:AppImages.lang ,onTap: (){
                              setState(() {
                                context.locale.languageCode=="ar"?context.setLocale(const Locale("en")): context.setLocale(const Locale("ar"));
                                CacheHelper.getData(key: AppCached.role)==AppCached.student?
                                navigateAndFinish(widget: const BottomNavScreen()):navigateAndFinish(widget: const BottomNavTeacherScreen());
                              });
                            },isLang: true),
                            CustomProfileRow(text: LocaleKeys.support.tr(),img:AppImages.support ,onTap: (){
                              navigateTo(widget: const HelpAndSupportScreen());
                            },),
                            CustomProfileRow(text: LocaleKeys.shareApp.tr(),img:AppImages.share ,onTap: (){},),
                            state is BaseStatesLoadingState ? const Center(child: CustomLoading()):
                            CustomProfileRow(text: LocaleKeys.login.tr(),img:AppImages.logOut ,onTap: (){
                              navigateAndFinish(widget: const RegisterASScreen());
                            },),
                          ]),
                    ),
                  ): Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      SizedBox(height: height,width: width,),
                      Container(
                        width: width,
                        height: height,
                        padding: EdgeInsetsDirectional.only(top: height*0.09),
                        margin: EdgeInsetsDirectional.only(top: height*0.08,end: width*0.09,start: width*0.09),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(AppRadius.r15),topLeft:Radius.circular(AppRadius.r15) )
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                          children: [
                            Text(CacheHelper.getData(key: AppCached.name),style: Styles.textStyle20,),
                            SizedBox(height: height*0.01),
                            Text(CacheHelper.getData(key: AppCached.email),style: Styles.textStyle14.copyWith(color: AppColors.grayColor,fontFamily: AppFonts.almaraiRegular)),
                            SizedBox(height: height*0.035),
                            CustomProfileRow(text: LocaleKeys.editProfile.tr(),img:AppImages.userEdit ,onTap: (){
                              navigateTo(widget: const EditProfileScreen());
                            },),
                            CustomProfileRow(text: LocaleKeys.editPass.tr(),img:AppImages.editPass ,onTap: (){
                              navigateTo(widget: const EditPasswordScreen());
                            },),
                            CustomProfileRow(text: LocaleKeys.notification.tr(),img:AppImages.notificationProfile ,onTap: (){
                              navigateTo(widget: const NotificationScreen());
                            },),
                            if(CacheHelper.getData(key: AppCached.role)==AppCached.student)...[
                              CustomProfileRow(text: LocaleKeys.mySaves.tr(),img:AppImages.saves ,onTap: (){
                                navigateTo(widget: const MySavesScreen());
                              },),
                              CacheHelper.getData(key: AppCached.isApple)==true?
                              const SizedBox.shrink():
                              CustomProfileRow(text: LocaleKeys.myCourses.tr(),img:AppImages.myCourses ,onTap: (){
                                navigateTo(widget: const MyCoursesScreen());
                              },),
                              CustomProfileRow(text: LocaleKeys.myPoints.tr(),img:AppImages.myPoint ,onTap: (){
                                navigateTo(widget: const MyPointsScreen());
                              },),
                            ],
                            if(CacheHelper.getData(key: AppCached.role)==AppCached.teacher)...[
                              CustomProfileRow(text: LocaleKeys.lives.tr(),img:AppImages.lives ,onTap: (){
                                navigateTo(widget: const TeacherLive());
                              },),
                              CacheHelper.getData(key: AppCached.isApple)==true?
                                  const SizedBox.shrink():
                              CustomProfileRow(text: LocaleKeys.managePackage.tr(),img:AppImages.package ,onTap: (){
                                navigateTo(widget: const ManagePackageScreen());
                              },),
                              CacheHelper.getData(key: AppCached.isApple)==true?
                              const SizedBox.shrink():
                              CustomProfileRow(text: LocaleKeys.subscribePackages.tr(),img:AppImages.package ,onTap: (){
                                navigateTo(widget: const SubscribePackageScreen());
                              },),
                              CustomProfileRow(text: LocaleKeys.myFiles.tr(),img:AppImages.myCourses ,onTap: (){
                                navigateTo(widget: const ShowFilesScreen());
                              },),
                            ],
                            CustomProfileRow(text: LocaleKeys.lang.tr(),img:AppImages.lang ,onTap: (){
                              setState(() {
                              context.locale.languageCode=="ar"?context.setLocale(const Locale("en")): context.setLocale(const Locale("ar"));
                              CacheHelper.getData(key: AppCached.role)==AppCached.student?
                              navigateAndFinish(widget: const BottomNavScreen()):navigateAndFinish(widget: const BottomNavTeacherScreen());
                              });
                            },isLang: true),
                            CustomProfileRow(text: LocaleKeys.support.tr(),img:AppImages.support ,onTap: (){
                              navigateTo(widget: const HelpAndSupportScreen());
                            },),
                            CacheHelper.getData(key: AppCached.isApple)==true?SizedBox():
                            CustomProfileRow(text: LocaleKeys.shareApp.tr(),img:AppImages.share ,onTap: (){},),
                            state is BaseStatesLoadingState ? const Center(child: CustomLoading()):
                            CustomProfileRow(text: LocaleKeys.logOut.tr(),img:AppImages.logOut ,onTap: (){
                              cubit.userLogout();
                            },),
                            state is BaseStatesLoadingState3 ? const Center(child: CustomLoading()):
                            CustomProfileRow(text: LocaleKeys.deleteAcc.tr(),img:AppImages.userEdit ,onTap: (){
                              showDialog(context: context, builder: (context)=> CustomAlertDialog(isDelete: true,onTap: (){cubit.delAccount();},));
                            },),
                          ]),
                        ),
                      ),
                      Stack(
                        alignment: AlignmentDirectional.bottomStart,
                        children: [
                          CircleAvatar(
                            radius: AppRadius.r47,
                            backgroundColor: const Color(0xff2253BC),
                            child: CircleAvatar(
                              radius: AppRadius.r45,
                              backgroundImage:  cubit.imagePicked!=null ? FileImage(File(cubit.imagePicked!)): NetworkImage(CacheHelper.getData(key: AppCached.image)) as ImageProvider,
                              backgroundColor: AppColors.fillColor,
                            ),
                          ),
                          state is BaseStatesLoadingState2? const CustomLoading():
                          InkWell(
                              onTap: (){
                                showCupertinoModalPopup(context: context,
                                  builder: (context) => PickImageBottomSheetContainer(
                                    fromCamFun: (){
                                      cubit.pickImageFromCamera();
                                      navigatorPop();
                                    },
                                    fromGalleryFun: (){
                                      cubit.pickImageFromGallery();
                                      navigatorPop();
                                    },
                                  ),);
                              },
                              child: Image.asset(AppImages.editImage,width: width*0.11))
                        ],
                      )

                    ],
                  ),
                ));
          })),
    );
  }
}
