import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_arrow.dart';
import '../../../../../core/widgets/custom_btn.dart';
import '../../../../../core/widgets/custom_loading.dart';
import '../../../../../core/widgets/custom_textfield.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../controller/edit_password_cubit.dart';

class EditPasswordBody extends StatelessWidget {
  const EditPasswordBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditPasswordCubit>(
      create: (context) => EditPasswordCubit(),
      child: BlocBuilder<EditPasswordCubit, BaseStates>(
        builder: (context, state) {
          var cubit = EditPasswordCubit.get(context);

          return Scaffold(
            backgroundColor: AppColors.onBoardingBgColor,
            body: SafeArea(
              child: Column(
                children: [
                  CustomArrow(
                    text: LocaleKeys.editPass.tr(),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.06,
                          vertical: height * 0.03,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(width * 0.05),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.mainColor.withOpacity(0.08),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              /// icon
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.mainColor.withOpacity(0.08),
                                ),
                                child: Icon(
                                  Icons.lock_reset_rounded,
                                  size: 34,
                                  color: AppColors.mainColor,
                                ),
                              ),

                              SizedBox(height: height * 0.02),

                              Text(
                                "قم بتحديث كلمة المرور الخاصة بك",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),

                              SizedBox(height: height * 0.035),

                              CustomTextField(
                                ctrl: cubit.oldPassController,
                                hint: LocaleKeys.oldPass.tr(),
                                prefixImg: AppImages.pass,
                                isPrefixImg: true,
                                textType: InputType.pass,
                                haveSuffix: true,
                              ),

                              SizedBox(height: height * 0.018),

                              CustomTextField(
                                ctrl: cubit.newPassController,
                                hint: LocaleKeys.newPassword.tr(),
                                prefixImg: AppImages.pass,
                                isPrefixImg: true,
                                textType: InputType.pass,
                                haveSuffix: true,
                              ),

                              SizedBox(height: height * 0.018),

                              CustomTextField(
                                ctrl: cubit.confirmNewPassController,
                                hint: LocaleKeys.confirmPassword.tr(),
                                prefixImg: AppImages.pass,
                                isPrefixImg: true,
                                textType: InputType.pass,
                                haveSuffix: true,
                              ),

                              SizedBox(height: height * 0.04),

                              state is BaseStatesLoadingState
                                  ? const Center(
                                child: CustomLoading(),
                              )
                                  : CustomButton(
                                text: LocaleKeys.saveEdits.tr(),
                                onPressed: () {
                                  cubit.editPassword();
                                },
                                widthBtn: width,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}