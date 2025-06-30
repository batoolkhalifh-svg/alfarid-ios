import 'package:alfarid/core/widgets/custom_error.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/local/app_cached.dart';
import '../../../../../core/local/cache_helper.dart';
import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_arrow.dart';
import '../../../../../core/widgets/custom_btn.dart';
import '../../../../../core/widgets/custom_drop_down.dart';
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
        create: CacheHelper.getData(key: AppCached.role) == AppCached.student
            ? (context) => EditProfileCubit()..fetchUser()
            : (context) => EditProfileCubit()..fetchTeacher(),
        child: BlocBuilder<EditProfileCubit, BaseStates>(builder: (context, state) {
          var cubit = EditProfileCubit.get(context);
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  CustomArrow(
                    text: LocaleKeys.editProfile.tr(),
                  ),
                  state is BaseStatesLoadingState
                      ? const CustomLoading(
                          fullScreen: true,
                        )
                      : state is BaseStatesErrorState
                          ? Center(
                              child: CustomError(
                                  title: state.msg,
                                  onPressed: () {
                                    CacheHelper.getData(key: AppCached.role) == AppCached.student
                                        ? cubit.fetchUser()
                                        : cubit.fetchTeacher();
                                  }))
                          : Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: width * 0.07, vertical: width * 0.06),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      CustomTextField(
                                        ctrl: cubit.nameController,
                                        hint: LocaleKeys.fullName.tr(),
                                        prefixImg: AppImages.user,
                                        isPrefixImg: true,
                                        isCharOnly: true,
                                      ),
                                      CustomTextField(
                                        ctrl: cubit.emailController,
                                        hint: LocaleKeys.email.tr(),
                                        prefixImg: AppImages.email,
                                        isPrefixImg: true,
                                        isEmail: true,
                                      ),
                                      CustomPhoneField(
                                          ctrl: cubit.phoneController,
                                          onChangedCode: (phone) {
                                            cubit.getPhoneKey(phone.code, phone.dialCode);
                                          },
                                          onChangedPhone: (phone) {
                                            cubit.getPhone(phone.number);
                                          },
                                          phoneKey: cubit.phoneKeyCode),
                                      CustomTextField(
                                        hint: LocaleKeys.classRoom.tr(),
                                        prefixImg: AppImages.user,
                                        isPrefixImg: true,
                                        maxLines: CacheHelper.getData(key: AppCached.role) == AppCached.student ? 1 : 2,
                                        readOnly: true,
                                        ctrl: cubit.classRoomCtrl,
                                        onTap: () {
                                          showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (_) => BlocProvider.value(
                                              value: context.read<EditProfileCubit>(),
                                              child: BlocBuilder<EditProfileCubit, BaseStates>(
                                                builder: (context, state) {
                                                  return Container(
                                                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                    constraints: BoxConstraints(maxHeight: height*0.7),
                                                    child: SingleChildScrollView(
                                                      child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: List.generate(
                                                            cubit.classroomModel!.data!.length,
                                                            (index) => CheckboxListTile(
                                                              title: Text(cubit.classroomModel!.data![index].name.toString()),
                                                              value:
                                                                  cubit.selectedClassroomIds.contains(cubit.classroomModel!.data![index].id),
                                                              onChanged: (val) => cubit.changeSelectedClassrooms(
                                                                  id: cubit.classroomModel!.data![index].id!,
                                                                  name: cubit.classroomModel!.data![index].name.toString()),
                                                            ),
                                                          )),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      CacheHelper.getData(key: AppCached.role) == AppCached.teacher
                                          ? CustomTextField(
                                              hint: LocaleKeys.subjectName.tr(),
                                              prefixImg: AppImages.user,
                                              isPrefixImg: true,
                                              maxLines: CacheHelper.getData(key: AppCached.role) == AppCached.student ? 1 : 2,
                                              readOnly: true,
                                              ctrl: cubit.subjectCtrl,
                                              onTap: () {
                                                showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  context: context,
                                                  builder: (_) => BlocProvider.value(
                                                    value: context.read<EditProfileCubit>(),
                                                    child: BlocBuilder<EditProfileCubit, BaseStates>(
                                                      builder: (context, state) {
                                                        return Container(
                                                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                          constraints: BoxConstraints(maxHeight: height*0.7),
                                                          child: SingleChildScrollView(
                                                            child: Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: List.generate(
                                                                  cubit.subjectsModel!.data!.length,
                                                                  (index) => CheckboxListTile(
                                                                    title: Text(cubit.subjectsModel!.data![index].name.toString()),
                                                                    value: cubit.subjectIds
                                                                        .contains(cubit.subjectsModel!.data![index].id),
                                                                    onChanged: (val) => cubit.changeSelectedSubjects(
                                                                        id: cubit.subjectsModel!.data![index].id!,
                                                                        name: cubit.subjectsModel!.data![index].name.toString()),
                                                                  ),
                                                                )),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          : const SizedBox.shrink(),
                                      SizedBox(
                                          height: CacheHelper.getData(key: AppCached.role) == AppCached.teacher
                                              ? height * 0.32
                                              : height * 0.39),
                                      state is BaseStatesLoadingState2
                                          ? const CustomLoading()
                                          : CustomButton(
                                              text: LocaleKeys.saveEdits.tr(),
                                              onPressed: () {
                                                cubit.profileEdits();
                                              },
                                              widthBtn: width,
                                            ),
                                      SizedBox(height: height * 0.01),
                                    ],
                                  ),
                                ),
                              ),
                            )
                ],
              ),
            ),
          );
        }));
  }
}
