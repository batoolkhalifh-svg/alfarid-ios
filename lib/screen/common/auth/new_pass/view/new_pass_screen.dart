import 'package:alfarid/core/utils/images.dart';
import 'package:alfarid/core/widgets/custom_loading.dart';
import 'package:alfarid/core/widgets/custom_textfield.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_auth_bg.dart';
import '../../../../../core/widgets/custom_btn.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../controller/new_pass_cubit.dart';

class NewPassScreen extends StatelessWidget {
  final String email;

  const NewPassScreen({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewPassCubit>(
      create: (context) => NewPassCubit(),
      child: BlocBuilder<NewPassCubit, BaseStates>(
        builder: (context, state) {
          var cubit = NewPassCubit.get(context);

          return CustomAuthBg(
            widget: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.07,
                    vertical: height * 0.12,
                  ),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(width * 0.06),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.96),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 30,
                            spreadRadius: 2,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// Icon
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.08),
                            ),
                            child: Icon(
                              Icons.lock_reset_rounded,
                              size: 38,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),

                          SizedBox(height: height * 0.025),

                          /// Title
                          Text(
                            LocaleKeys.rePassword.tr(),
                            style: Styles.textStyle20.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),

                          SizedBox(height: height * 0.012),

                          /// Subtitle
                          Text(
                            "قم بإدخال كلمة مرور جديدة وتأكيدها للمتابعة",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              height: 1.6,
                            ),
                          ),

                          SizedBox(height: height * 0.04),

                          /// New password
                          CustomTextField(
                            ctrl: cubit.passController,
                            hint: LocaleKeys.newPassword.tr(),
                            prefixImg: AppImages.pass,
                            isPrefixImg: true,
                            textType: InputType.pass,
                            haveSuffix: true,
                          ),

                          SizedBox(height: height * 0.02),

                          /// Confirm password
                          CustomTextField(
                            ctrl: cubit.confirmPassController,
                            hint: LocaleKeys.confirmPassword.tr(),
                            prefixImg: AppImages.pass,
                            isPrefixImg: true,
                            textType: InputType.pass,
                            haveSuffix: true,
                          ),

                          SizedBox(height: height * 0.045),

                          /// Button
                          state is BaseStatesLoadingState
                              ? const CustomLoading()
                              : CustomButton(
                            text: LocaleKeys.send.tr(),
                            onPressed: () {
                              cubit.resetPassword(email: email);
                            },
                            widthBtn: width,
                          ),
                        ],
                      ),
                    ),
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