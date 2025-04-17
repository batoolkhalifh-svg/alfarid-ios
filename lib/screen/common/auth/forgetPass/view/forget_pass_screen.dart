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
import '../controller/forget_pass_cubit.dart';

class ForgetPassScreen extends StatelessWidget {
  const ForgetPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ForgetPassCubit>(
        create: (context) => ForgetPassCubit(),
        child: BlocBuilder<ForgetPassCubit, BaseStates>(builder: (context, state) {
        var cubit = ForgetPassCubit.get(context);
         return CustomAuthBg(widget: Padding(
          padding:EdgeInsets.only(
              left: width * 0.08,right: width * 0.08, top : width * 0.28),
          child: Column(
          children: [
           Text(LocaleKeys.forgetPass.tr(), style: Styles.textStyle20),
          CustomTextField(ctrl: cubit.emailController,hint: LocaleKeys.email.tr(),prefixImg:AppImages.email,isPrefixImg: true,),
            SizedBox(height: height*0.05),
            state is BaseStatesLoadingState? const CustomLoading():
            CustomButton(text: LocaleKeys.send.tr(), onPressed: () {
              cubit.forgetPass();
            }, widthBtn: width,),
            SizedBox(height: height * 0.28)


          ],
                ),
    ));}));
  }
}
