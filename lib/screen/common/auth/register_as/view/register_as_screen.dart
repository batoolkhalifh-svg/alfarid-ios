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
import '../../../../../core/utils/colors.dart';
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
    return BlocProvider<RegisterAsCubit>(
      create: (context) => RegisterAsCubit(),
      child: BlocBuilder<RegisterAsCubit, BaseStates>(
        builder: (context, state) {
          var cubit = RegisterAsCubit.get(context);

          return CustomAuthBg(
            widget: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.08,
                    vertical: height * 0.14,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: height * 0.04),

                      /// Title
                      Text(
                        LocaleKeys.registerAs.tr(),
                        style: Styles.textStyle20.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.mainColorBold,
                          fontSize: 24,
                        ),
                      ),

                      SizedBox(height: height * 0.012),

                      Text(
                        "اختر نوع الحساب للمتابعة",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),

                      SizedBox(height: height * 0.05),

                      /// Main card
                      Container(
                        padding: EdgeInsets.all(width * 0.05),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.96),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.mainColor.withOpacity(0.08),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: CustomContainer(
                                    isSelect: cubit.isUser == true,
                                    image: AppImages.student,
                                    title: LocaleKeys.student.tr(),
                                    onTap: () {
                                      cubit.changeUser(true);
                                    },
                                  ),
                                ),
                                SizedBox(width: width * 0.04),
                                Expanded(
                                  child: CustomContainer(
                                    isSelect: cubit.isUser == false,
                                    image: AppImages.teacher,
                                    title: LocaleKeys.teacher.tr(),
                                    onTap: () {
                                      cubit.changeUser(false);
                                    },
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: height * 0.04),

                            InkWell(
                              onTap: () {
                                navigateTo(
                                  widget: const BottomNavScreen(),
                                );
                              },
                              child: Text(
                                LocaleKeys.visitor.tr(),
                                style: Styles.textStyle16.copyWith(
                                  fontSize: AppFonts.t14,
                                  color: AppColors.mainColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            SizedBox(height: height * 0.04),

                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: cubit.isUser == null
                                  ? SizedBox(
                                height: height * 0.075,
                              )
                                  : CustomButton(
                                text: LocaleKeys.next.tr(),
                                onPressed: () {
                                  CacheHelper.saveData(
                                    key: AppCached.role,
                                    value: cubit.isUser!
                                        ? AppCached.student
                                        : AppCached.teacher,
                                  );

                                  navigateTo(
                                    widget: const LoginScreen(),
                                  );
                                },
                                widthBtn: width,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}