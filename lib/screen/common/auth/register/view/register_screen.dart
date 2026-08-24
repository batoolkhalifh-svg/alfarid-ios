import 'package:alfarid/core/utils/images.dart';
import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:alfarid/core/widgets/custom_loading.dart';
import 'package:alfarid/core/widgets/custom_textfield.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/local/app_cached.dart';
import '../../../../../core/local/cache_helper.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_auth_bg.dart';
import '../../../../../core/widgets/custom_btn.dart';
import '../../../../../core/widgets/custom_drop_down.dart';
import '../../../../../core/widgets/custom_phone_field.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../controller/register_cubit.dart';


class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterCubit>(
      create: CacheHelper.getData(key: AppCached.role) == AppCached.student
          ? (context) => RegisterCubit()..fetchClassroom()
          : (context) => RegisterCubit()..fetchSubjects(),
      child: BlocBuilder<RegisterCubit, BaseStates>(
        builder: (context, state) {
          var cubit = RegisterCubit.get(context);

          return CustomAuthBg(
            widget: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.08, vertical: width * 0.05),
                child: Column(
                  children: [
                    SizedBox(height: height * 0.02),

                    // شعار التطبيق
                 //  Image.asset(AppImages.logo, height: height * 0.12),
                    SizedBox(height: height * 0.052),

                    // عنوان التسجيل
                    Text(
                      LocaleKeys.register.tr(),
                      style: Styles.textStyle20.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.mainColorBold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: height * 0.03),

                    // Card الحقول
                    Container(
                      padding: EdgeInsets.all(width * 0.05),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.mainColor.withOpacity(0.1),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          CustomTextField(
                            ctrl: cubit.nameController,
                            hint: LocaleKeys.fullName.tr(),
                            prefixImg: AppImages.user,
                            isPrefixImg: true,
                            isCharOnly: true,
                          ),
                          SizedBox(height: height * 0.02),

                          CustomTextField(
                            ctrl: cubit.emailController,
                            hint: LocaleKeys.email.tr(),
                            prefixImg: AppImages.email,
                            isPrefixImg: true,
                            isEmail: true,
                          ),
                          SizedBox(height: height * 0.02),

                          CustomPhoneField(
                            onChangedCode: (phone) {
                              cubit.getPhoneKey(phone.code, phone.dialCode);
                            },
                            onChangedPhone: (phone) {
                              cubit.getPhone(phone.number);
                            },
                            phoneKey: cubit.phoneKeyCode,
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
                          SizedBox(height: height * 0.02),

                          // حقل الفصول أو المواد
                          CacheHelper.getData(key: AppCached.role) == AppCached.student
                              ? _buildClassroomField(context, cubit)
                              : _buildSubjectsField(context, cubit),

                          SizedBox(height: height * 0.03),

                          // زر التسجيل
                          state is BaseStatesLoadingState
                              ? const CustomLoading()
                              : CustomButton(
                            text: LocaleKeys.register.tr(),
                            onPressed: () {
                              cubit.register();
                            },
                            widthBtn: width,
                          ),
                        ],
                      ),
                    ),

                    // تسجيل الدخول لو عنده حساب
                    SizedBox(height: height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LocaleKeys.haveAcc.tr(),
                          style: Styles.textStyle14.copyWith(color: AppColors.blackColor),
                        ),
                        SizedBox(width: width * 0.01),
                        InkWell(
                          onTap: () {
                            navigatorPop();
                          },
                          child: Text(
                            LocaleKeys.loginNow.tr(),
                            style: Styles.textStyle14.copyWith(color: AppColors.mainColor),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildClassroomField(BuildContext context, RegisterCubit cubit) {
    return CustomTextField(
      hint: LocaleKeys.classRoom.tr(),
      prefixImg: AppImages.user,
      isPrefixImg: true,
      maxLines: 1,
      readOnly: true,
      ctrl: TextEditingController.fromValue(
        TextEditingValue(text: cubit.selectedClassroomNames.join(', ')),
      ),
      onTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (_) => BlocProvider.value(
            value: context.read<RegisterCubit>(),
            child: BlocBuilder<RegisterCubit, BaseStates>(
              builder: (context, state) {
                return Container(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  constraints: BoxConstraints(maxHeight: height * 0.7),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        cubit.classroomModel!.data!.length,
                            (index) => CheckboxListTile(
                          title: Text(cubit.classroomModel!.data![index].name.toString()),
                          value: cubit.selectedClassroomIds.contains(cubit.classroomModel!.data![index].id),
                          onChanged: (val) => cubit.changeSelectedClassrooms(
                            id: cubit.classroomModel!.data![index].id!,
                            name: cubit.classroomModel!.data![index].name.toString(),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubjectsField(BuildContext context, RegisterCubit cubit) {
    return CustomTextField(
      hint: LocaleKeys.subjectName.tr(),
      prefixImg: AppImages.user,
      isPrefixImg: true,
      maxLines: 2,
      readOnly: true,
      ctrl: TextEditingController.fromValue(
        TextEditingValue(text: cubit.selectedSubjectsNames.join(', ')),
      ),
      onTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (_) => BlocProvider.value(
            value: context.read<RegisterCubit>(),
            child: BlocBuilder<RegisterCubit, BaseStates>(
              builder: (context, state) {
                return Container(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  constraints: BoxConstraints(maxHeight: height * 0.7),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        cubit.subjectsModel!.data!.length,
                            (index) => CheckboxListTile(
                          title: Text(cubit.subjectsModel!.data![index].name.toString()),
                          value: cubit.selectedSubjectsIds.contains(cubit.subjectsModel!.data![index].id),
                          onChanged: (val) => cubit.changeSelectedSubjects(
                            id: cubit.subjectsModel!.data![index].id!,
                            name: cubit.subjectsModel!.data![index].name.toString(),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
