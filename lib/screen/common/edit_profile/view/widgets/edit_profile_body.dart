import 'package:alfarid/core/widgets/custom_error.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/local/app_cached.dart';
import '../../../../../core/local/cache_helper.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_arrow.dart';
import '../../../../../core/widgets/custom_btn.dart';
import '../../../../../core/widgets/custom_loading.dart';
import '../../../../../core/widgets/custom_phone_field.dart';
import '../../../../../core/widgets/custom_textfield.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../controller/edit_profile_cubit.dart';

class EditProfileBody extends StatelessWidget {
  const EditProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditProfileCubit>(
      create: CacheHelper.getData(key: AppCached.role) ==
          AppCached.student
          ? (context) => EditProfileCubit()..fetchUser()
          : (context) => EditProfileCubit()..fetchTeacher(),
      child: BlocBuilder<EditProfileCubit, BaseStates>(
        builder: (context, state) {
          var cubit = EditProfileCubit.get(context);

          return Scaffold(
            backgroundColor: AppColors.onBoardingBgColor,
            body: SafeArea(
              child: Column(
                children: [
                  CustomArrow(
                    text: LocaleKeys.editProfile.tr(),
                  ),

                  if (state is BaseStatesLoadingState)
                    const Expanded(
                      child: CustomLoading(fullScreen: true),
                    )
                  else if (state is BaseStatesErrorState)
                    Expanded(
                      child: Center(
                        child: CustomError(
                          title: state.msg,
                          onPressed: () {
                            CacheHelper.getData(
                              key: AppCached.role,
                            ) ==
                                AppCached.student
                                ? cubit.fetchUser()
                                : cubit.fetchTeacher();
                          },
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.06,
                          vertical: height * 0.02,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(width * 0.05),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.mainColor
                                    .withOpacity(0.08),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              /// icon
                              Container(
                                padding:
                                const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.mainColor
                                      .withOpacity(0.08),
                                ),
                                child: Icon(
                                  Icons.person_outline_rounded,
                                  size: 34,
                                  color:
                                  AppColors.mainColor,
                                ),
                              ),

                              SizedBox(
                                  height: height * 0.025),

                              CustomTextField(
                                ctrl: cubit.nameController,
                                hint: LocaleKeys.fullName.tr(),
                                prefixImg: AppImages.user,
                                isPrefixImg: true,
                                isCharOnly: true,
                              ),

                              SizedBox(
                                  height: height * 0.018),

                              CustomTextField(
                                ctrl: cubit.emailController,
                                hint: LocaleKeys.email.tr(),
                                prefixImg: AppImages.email,
                                isPrefixImg: true,
                                isEmail: true,
                              ),

                              SizedBox(
                                  height: height * 0.018),

                              CustomPhoneField(
                                ctrl:
                                cubit.phoneController,
                                onChangedCode: (phone) {
                                  cubit.getPhoneKey(
                                    phone.code,
                                    phone.dialCode,
                                  );
                                },
                                onChangedPhone: (phone) {
                                  cubit.getPhone(
                                    phone.number,
                                  );
                                },
                                phoneKey:
                                cubit.phoneKeyCode,
                              ),

                              SizedBox(
                                  height: height * 0.018),

                              CustomTextField(
                                hint: LocaleKeys.classRoom
                                    .tr(),
                                prefixImg:
                                AppImages.user,
                                isPrefixImg: true,
                                readOnly: true,
                                ctrl:
                                cubit.classRoomCtrl,
                                onTap: () {
                                  // نفس bottom sheet الحالي
                                },
                              ),

                              if (CacheHelper.getData(
                                  key:
                                  AppCached.role) ==
                                  AppCached.teacher)
                                SizedBox(
                                    height:
                                    height * 0.018),

                              if (CacheHelper.getData(
                                  key:
                                  AppCached.role) ==
                                  AppCached.teacher)
                                CustomTextField(
                                  hint: LocaleKeys
                                      .subjectName
                                      .tr(),
                                  prefixImg:
                                  AppImages.user,
                                  isPrefixImg: true,
                                  readOnly: true,
                                  ctrl:
                                  cubit.subjectCtrl,
                                  onTap: () {
                                    // نفس bottom sheet الحالي
                                  },
                                ),

                              SizedBox(
                                  height: height * 0.04),

                              state
                              is BaseStatesLoadingState2
                                  ? const CustomLoading()
                                  : CustomButton(
                                text: LocaleKeys
                                    .saveEdits
                                    .tr(),
                                onPressed: () {
                                  cubit
                                      .profileEdits();
                                },
                                widthBtn: width,
                              ),
                            ],
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