import 'package:alfarid/core/utils/images.dart';
import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:alfarid/core/widgets/custom_loading.dart';
import 'package:alfarid/core/widgets/custom_textfield.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_auth_bg.dart';
import '../../../../../core/widgets/custom_btn.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../../main.dart';
import '../../forgetPass/view/forget_pass_screen.dart';
import '../../register/view/register_screen.dart';
import '../controller/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (context) => LoginCubit(),
      child: BlocBuilder<LoginCubit, BaseStates>(
        builder: (context, state) {
          var cubit = LoginCubit.get(context);

          return CustomAuthBg(
            widget: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.07,
                    vertical: height * 0.08,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: height * 0.04),

                      /// Welcome Header
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome Back 👋",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.blackColor,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "سجّل دخولك للمتابعة",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: height * 0.06),

                      /// Luxury Card
                      Container(
                        padding: EdgeInsets.all(width * 0.06),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 30,
                              spreadRadius: 2,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              LocaleKeys.login.tr(),
                              style: Styles.textStyle20.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),

                            SizedBox(height: height * 0.035),

                            CustomTextField(
                              ctrl: cubit.emailController,
                              hint: LocaleKeys.email.tr(),
                              prefixImg: AppImages.email,
                              isPrefixImg: true,
                            ),

                            SizedBox(height: height * 0.02),

                            CustomTextField(
                              ctrl: cubit.passController,
                              hint: LocaleKeys.password.tr(),
                              prefixImg: AppImages.pass,
                              isPrefixImg: true,
                              textType: InputType.pass,
                              haveSuffix: true,
                            ),

                            SizedBox(height: height * 0.015),

                            Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: InkWell(
                                onTap: () {
                                  navigateTo(
                                    widget: const ForgetPassScreen(),
                                  );
                                },
                                child: Text(
                                  "${LocaleKeys.forgetPass.tr()}${navigatorKey.currentState!.context.locale.languageCode == "ar" ? "؟" : "?"}",
                                  style: TextStyle(
                                    color: AppColors.mainColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: height * 0.04),

                            state is BaseStatesLoadingState
                                ? const CustomLoading()
                                : CustomButton(
                              text: LocaleKeys.login.tr(),
                              onPressed: () {
                                cubit.login();
                              },
                              widthBtn: width,
                            ),

                            SizedBox(height: height * 0.03),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  LocaleKeys.notHaveAcc.tr(),
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(width: 5),
                                InkWell(
                                  onTap: () {
                                    navigateTo(
                                      widget: const RegisterScreen(),
                                    );
                                  },
                                  child: Text(
                                    LocaleKeys.loginNow.tr(),
                                    style: TextStyle(
                                      color: AppColors.mainColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
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