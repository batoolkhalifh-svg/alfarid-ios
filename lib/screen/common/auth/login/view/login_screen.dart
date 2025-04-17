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
        child: BlocBuilder<LoginCubit, BaseStates>(builder: (context, state) {
        var cubit = LoginCubit.get(context);
         return CustomAuthBg(widget: Padding(
          padding: EdgeInsets.only(
              left: width * 0.08,right: width * 0.08, top : width * 0.25),
          child: Column(
          children: [
           Text(LocaleKeys.login.tr(), style: Styles.textStyle20),
          CustomTextField(ctrl: cubit.emailController,hint: LocaleKeys.email.tr(),prefixImg:AppImages.email,isPrefixImg: true,),
          CustomTextField(ctrl: cubit.passController,hint: LocaleKeys.password.tr(),prefixImg: AppImages.pass,isPrefixImg: true,textType: InputType.pass,haveSuffix: true,),
            SizedBox(height: height*0.01,),
            InkWell(
              onTap: (){
                navigateTo(widget: const ForgetPassScreen());
              },
              child: Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: Text("${LocaleKeys.forgetPass.tr()}${navigatorKey.currentState!.context.locale.languageCode=="ar"? "؟":"?"}",style: Styles.textStyle14.copyWith(color: AppColors.mainColor,fontFamily: AppFonts.almaraiRegular),)),
            ),
            SizedBox(height: height*0.07),
            state is BaseStatesLoadingState ? const CustomLoading():
            CustomButton(text: LocaleKeys.login.tr(), onPressed: () {
              cubit.login();
            }, widthBtn: width,),
            SizedBox(height: height*0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(LocaleKeys.notHaveAcc.tr(),style: Styles.textStyle14.copyWith(color: AppColors.blackColor,fontFamily:AppFonts.almaraiRegular ),),
                InkWell(
                    onTap: (){
                      navigateTo(widget: const RegisterScreen());
                    },
                    child: Text(LocaleKeys.loginNow.tr(),style: Styles.textStyle14.copyWith(color: AppColors.mainColor),))
              ],
            ),
            SizedBox(height: height * 0.11)


          ],
                ),
    ));}));
  }
}
