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
  const NewPassScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewPassCubit>(
        create: (context) => NewPassCubit(),
        child: BlocBuilder<NewPassCubit, BaseStates>(builder: (context, state) {
        var cubit = NewPassCubit.get(context);
         return CustomAuthBg(widget: Padding(
          padding: EdgeInsets.only(
              left: width * 0.08,right: width * 0.08, top : width * 0.28),
          child: Column(
          children: [
           Text(LocaleKeys.rePassword.tr(), style: Styles.textStyle20),
          CustomTextField(ctrl: cubit.passController,hint: LocaleKeys.newPassword.tr(),prefixImg: AppImages.pass,isPrefixImg: true,textType: InputType.pass,haveSuffix: true,),
          CustomTextField(ctrl: cubit.confirmPassController,hint: LocaleKeys.confirmPassword.tr(),prefixImg: AppImages.pass,isPrefixImg: true,textType: InputType.pass,haveSuffix: true,),
            SizedBox(height: height*0.07),
            state is BaseStatesLoadingState? const CustomLoading():
            CustomButton(text: LocaleKeys.send.tr(), onPressed: () {
              cubit.resetPassword(email: email);
            }, widthBtn: width,),
            SizedBox(height: height * 0.175)


          ],
                ),
    ));}));
  }
}
