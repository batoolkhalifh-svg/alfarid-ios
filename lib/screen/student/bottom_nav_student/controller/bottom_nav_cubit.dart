import 'package:alfarid/screen/student/home/view/view/home_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/images.dart';
import '../../../../core/widgets/base_state.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../common/all_chat/group/chat_teacher/view/chat_teacher_screen.dart';
import '../../../common/profile/view/profile_screen.dart';
import '../../my_books/view/my_books_screen.dart';
import '../../my_lieutenant/view/lieutenants_screen.dart';
import '../model/bottom_nav_model.dart';


class BottomNavCubit extends Cubit<BaseStates> {
  BottomNavCubit() : super(BaseStatesInitState());

  static BottomNavCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;

  List<BottomNavModel> btmList = [
    BottomNavModel(
      title: LocaleKeys.home.tr(),
      image: AppImages.home,
    ),
    BottomNavModel(
      title: LocaleKeys.myBooks.tr(),
      image: AppImages.book,
    ),
    BottomNavModel(
      title: LocaleKeys.lieutenant.tr(),
      image: AppImages.book,
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

  List<BottomNavModel> btmListSelected = [
    BottomNavModel(
      title: LocaleKeys.home.tr(),
      image: AppImages.homeA,
    ),
    BottomNavModel(
      title: LocaleKeys.myBooks.tr(),
      image: AppImages.bookA,
    ),
    BottomNavModel(
      title: LocaleKeys.lieutenant.tr(),
      image: AppImages.bookA,
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

  List<Widget> pages =  [
    const HomeScreen(),
    const MyBooksScreen(),
    const LieutenantScreen(),
    const ChatTeacherScreen(),
    const ProfileScreen(),
  ];

  changeIndex({required int index}) {
    currentIndex = index;
    emit(BaseStatesChangeState());
  }
}