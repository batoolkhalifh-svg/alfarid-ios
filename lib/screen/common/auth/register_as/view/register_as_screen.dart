import 'package:alfarid/core/local/app_cached.dart';
import 'package:alfarid/core/utils/styles.dart';
import 'package:alfarid/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/local/cache_helper.dart';
import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/my_navigate.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_auth_bg.dart';
import '../../../../../core/widgets/custom_btn.dart';
import '../../../../student/bottom_nav_student/view/bottom_nav_screen.dart';
import '../../../auth/login/view/login_screen.dart';
import '../controller/register_as_cubit.dart';
import 'widgets/custom_container.dart';

class RegisterASScreen extends StatelessWidget {
  const RegisterASScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocProvider<RegisterAsCubit>(
        create: (context) => RegisterAsCubit(),
        child: BlocBuilder<RegisterAsCubit, BaseStates>(builder: (context, state) {
      var cubit = RegisterAsCubit.get(context);
      return CustomAuthBg(widget: Padding(
        padding: EdgeInsets.only(
            left: width * 0.08,right: width * 0.08, top : width * 0.28),
        child: Column(
          children: [
            Text(LocaleKeys.registerAs.tr(), style: Styles.textStyle20),
            SizedBox(height: height * 0.06),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.018),
              child: Row(
                children: [
                  CustomContainer(isSelect:
                  cubit.isUser == true ? true : false,
                      image: AppImages.student,
                      title: LocaleKeys.student.tr(),
                      onTap: () {
                        cubit.changeUser(true);
                      }),
                  const Spacer(),
                  CustomContainer(
                    isSelect: cubit.isUser == false ? true : false,
                    image: AppImages.teacher,
                    title: LocaleKeys.teacher.tr(),
                    onTap: () {
                      cubit.changeUser(false);
                    },),
                ],
              ),
            ),
            SizedBox(height: height * 0.04),
            GestureDetector(
                onTap: (){
                  navigateTo(widget: const BottomNavScreen());
                },
                child: Text(LocaleKeys.visitor.tr(),style: Styles.textStyle16.copyWith(fontSize: AppFonts.t14),)),
            SizedBox(height: height * 0.04),
            cubit.isUser == null ?
            SizedBox(height: height *  0.075,) :
            CustomButton(text: LocaleKeys.next.tr(), onPressed: () {
              CacheHelper.saveData(key: AppCached.role, value: cubit.isUser! ? AppCached.student : AppCached.teacher);
              navigateTo(widget: const LoginScreen());
            }, widthBtn: width,),
            SizedBox(height: height * 0.08)


          ],
        ),
      ),);

        }));
  }
}
