import 'package:alfarid/core/widgets/custom_loading.dart';
import 'package:easy_localization/easy_localization.dart' as localize;
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_auth_bg.dart';
import '../../../../../core/widgets/custom_btn.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../controller/pin_code_cubit.dart';

class PinCodeScreen extends StatelessWidget {
  final bool fromRegister;
  final String token;
  final String email;
  const PinCodeScreen({super.key, required this.fromRegister, required this.token, required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PinCodeCubit>(
        create: (context) => PinCodeCubit(),
        child: BlocBuilder<PinCodeCubit, BaseStates>(builder: (context, state) {
        var cubit = PinCodeCubit.get(context);
         return CustomAuthBg(widget: Padding(
          padding: EdgeInsets.only(
              left: width * 0.08,right: width * 0.08, top : width * 0.28),
          child: Column(
          children: [
           Text(LocaleKeys.verificationCode.tr(), style: Styles.textStyle20),
           SizedBox(height: height*0.02,),
           Text(LocaleKeys.enterCode.tr(), style: Styles.textStyle14.copyWith(color: AppColors.grayColor,fontFamily: AppFonts.almaraiRegular)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.02,vertical: height*.04),
              child: Directionality(
                textDirection:TextDirection.ltr,
                child: PinCodeTextField(
                  appContext: context,
                  autoDisposeControllers: false,
                  length: 4,
                  controller: cubit.codeController,
                  textStyle: Styles.textStyle12.copyWith(color: AppColors.mainColor2, fontSize: AppFonts.t16, fontWeight: FontWeight.w600),
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.circle,
                      fieldOuterPadding: EdgeInsets.symmetric(horizontal: width * .006),
                      fieldHeight: width * .16,
                      fieldWidth: width * .16,
                      borderWidth: .5,
                      inactiveColor: Colors.transparent,
                      selectedColor: AppColors.mainColor2,
                      disabledColor: AppColors.mainColor2,
                      activeFillColor: AppColors.fillColor,
                      selectedFillColor: AppColors.fillColor,
                      activeColor: AppColors.mainColor2,
                      inactiveFillColor: AppColors.fillColor),
                  cursorColor: AppColors.mainColor2,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
            state is BaseStatesChangeState ? const CustomLoading():
            InkWell(
              onTap: (){
                cubit.resendVerifyCode(email: email);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(LocaleKeys.sendAgain.tr(), style: Styles.textStyle14.copyWith(color: AppColors.blackColor)),
                  Image.asset(AppImages.sendAgain,width: width*0.06,),
                ],
              ),
            ),
            SizedBox(height: height*0.05),
            state is BaseStatesLoadingState? const CustomLoading():
            CustomButton(text: LocaleKeys.send.tr(), onPressed: () {
              cubit.verifyCode(token: token, fromRegister: fromRegister, email: email);
            }, widthBtn: width,),
            SizedBox(height: height * 0.13)

                  ],
                ),
    ));}));
  }
}
