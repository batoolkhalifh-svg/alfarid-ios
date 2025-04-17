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
        create:CacheHelper.getData(key: AppCached.role)==AppCached.student?(context) => RegisterCubit()..fetchClassroom():(context) => RegisterCubit()..fetchSubjects(),
        child: BlocBuilder<RegisterCubit, BaseStates>(builder: (context, state) {
        var cubit = RegisterCubit.get(context);
         return CustomAuthBg(widget: Padding(
          padding: EdgeInsets.only(
              left: width * 0.08,right: width * 0.08, top : width * 0.18),
          child: Column(
          children: [
           Text(LocaleKeys.register.tr(), style: Styles.textStyle20),
          CustomTextField(ctrl: cubit.nameController,hint: LocaleKeys.fullName.tr(),prefixImg:AppImages.user,isPrefixImg: true,isCharOnly: true,),
          CustomTextField(ctrl: cubit.emailController,hint: LocaleKeys.email.tr(),prefixImg:AppImages.email,isPrefixImg: true,isEmail: true,),
            CustomPhoneField(onChangedCode: (phone) {
              cubit.getPhoneKey(phone.code,phone.dialCode);
            }, onChangedPhone: (phone) {
              cubit.getPhone(phone.number);
            }, phoneKey: cubit.phoneKeyCode),
          CustomTextField(ctrl: cubit.passController,hint: LocaleKeys.password.tr(),prefixImg: AppImages.pass,isPrefixImg: true,textType: InputType.pass,haveSuffix: true,),
            state is BaseStatesLoadingState2 ?Padding(
              padding:  EdgeInsets.only(top: width*0.025),
              child: const Center(child: CustomLoading()),
            ): CustomDropDown(
              onChanged: (v){
                cubit.changeClassroomId(v);
              },
              dropDownValue: cubit.classroomId,
              items: List.generate(
                  cubit.classroomModel!.data!.length,
                      (index) => DropdownMenuItem<String>(
                      value: cubit.classroomModel!.data![index].id.toString(),
                      child: Text(
                        cubit.classroomModel!.data![index].name.toString(),
                      ))), hintText: LocaleKeys.classRoom.tr(),
            ) ,
            CacheHelper.getData(key: AppCached.role)==AppCached.student?const SizedBox.shrink():
            state is BaseStatesLoadingState2 ?Padding(
              padding:  EdgeInsets.only(top: width*0.025),
              child: const Center(child: CustomLoading()),
            ):
            CustomDropDown(
              onChanged: (v){
                cubit.changeSubjectId(v);
              },
              dropDownValue: cubit.subjectId,
              items: List.generate(
                  cubit.subjectsModel!.data!.length,
                      (index) => DropdownMenuItem<String>(
                      value: cubit.subjectsModel!.data![index].id.toString(),
                      child: Text(
                        cubit.subjectsModel!.data![index].name.toString(),
                      ))), hintText: LocaleKeys.subjectName.tr(),
            ),
            SizedBox(height: height*0.022),
            state is BaseStatesLoadingState ? const CustomLoading():
            CustomButton(text: LocaleKeys.register.tr(), onPressed: () {
              cubit.register();
            }, widthBtn: width,),
            SizedBox(height: height*0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(LocaleKeys.haveAcc.tr(),style: Styles.textStyle14.copyWith(color: AppColors.blackColor,fontFamily:AppFonts.almaraiRegular ),),
                InkWell(
                    onTap: (){
                      navigatorPop();
                    },
                    child: Text(LocaleKeys.loginNow.tr(),style: Styles.textStyle14.copyWith(color: AppColors.mainColor),))
              ],
            ),
            SizedBox(height: height*0.02),



          ],
                ),
    ));}));
  }
}
