import 'package:alfarid/core/local/app_cached.dart';
import 'package:alfarid/core/local/cache_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/images.dart';
import '../../../../core/widgets/base_state.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../common/profile/view/profile_screen.dart';
import '../../../common/all_chat/group/chat_teacher/view/chat_teacher_screen.dart';
import '../../home_teacher/view/home_teacher_screen.dart';
import '../../order/view/order_screen.dart';
import '../model/bottom_nav_model.dart';


class BottomNavCubit extends Cubit<BaseStates> {
  BottomNavCubit() : super(BaseStatesInitState());

  static BottomNavCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;

  List<BottomNavModel> btmList = CacheHelper.getData(key: AppCached.isApple)==true?
  [
    BottomNavModel(
      title: LocaleKeys.home.tr(),
      image: AppImages.home,
    ),
    BottomNavModel(
      title: LocaleKeys.messages.tr(),
      image: AppImages.message,
    ),
    BottomNavModel(
      title: LocaleKeys.profile.tr(),
      image: AppImages.profile,
    )
  ]:
  [
    BottomNavModel(
      title: LocaleKeys.home.tr(),
      image: AppImages.home,
    ),
    BottomNavModel(
      title: LocaleKeys.orders.tr(),
      image: AppImages.order,
    ),
    BottomNavModel(
      title: LocaleKeys.messages.tr(),
      image: AppImages.message,
    ),
    BottomNavModel(
      title: LocaleKeys.profile.tr(),
      image: AppImages.profile,
    )
  ];

  List<BottomNavModel> btmListSelected =CacheHelper.getData(key: AppCached.isApple)==true?[
    BottomNavModel(
      title: LocaleKeys.home.tr(),
      image: AppImages.homeA,
    ),
    BottomNavModel(
      title: LocaleKeys.messages.tr(),
      image: AppImages.messageA,
    ),
    BottomNavModel(
      title: LocaleKeys.profile.tr(),
      image: AppImages.profileA,
    )
  ]:
  [
    BottomNavModel(
      title: LocaleKeys.home.tr(),
      image: AppImages.homeA,
    ),
    BottomNavModel(
      title: LocaleKeys.orders.tr(),
      image: AppImages.orderA,
    ),
    BottomNavModel(
      title: LocaleKeys.messages.tr(),
      image: AppImages.messageA,
    ),
    BottomNavModel(
      title: LocaleKeys.profile.tr(),
      image: AppImages.profileA,
    )
  ];

  List<Widget> pages = CacheHelper.getData(key: AppCached.isApple)==true?
  [
    const TeacherHomeScreen(),
    const ChatTeacherScreen(),
    const ProfileScreen(),
  ]: [
    const TeacherHomeScreen(),
    const OrderScreen(),
    const ChatTeacherScreen(),
    const ProfileScreen(),
  ];

  changeIndex({required int index}) {
    currentIndex = index;
    emit(BaseStatesChangeState());
  }
}