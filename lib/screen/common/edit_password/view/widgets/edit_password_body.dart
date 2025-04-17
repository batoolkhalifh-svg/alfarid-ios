import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/size.dart';
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
        child: BlocBuilder<EditPasswordCubit, BaseStates>(builder: (context, state) {
          var cubit = EditPasswordCubit.get(context);
          return Scaffold(
            body:  SafeArea(
              child: Column(
                children: [
                  CustomArrow(text: LocaleKeys.editPass.tr(),),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.07, vertical: width * 0.06),
                      child: ListView(
                        children: [
                          CustomTextField(ctrl: cubit.oldPassController,hint: LocaleKeys.oldPass.tr(),prefixImg: AppImages.pass,isPrefixImg: true,textType: InputType.pass,haveSuffix: true,),
                          CustomTextField(ctrl: cubit.newPassController,hint: LocaleKeys.newPassword.tr(),prefixImg: AppImages.pass,isPrefixImg: true,textType: InputType.pass,haveSuffix: true,),
                          CustomTextField(ctrl: cubit.confirmNewPassController,hint: LocaleKeys.confirmPassword.tr(),prefixImg: AppImages.pass,isPrefixImg: true,textType: InputType.pass,haveSuffix: true,),
                          SizedBox(height: height*0.47),
                          state is BaseStatesLoadingState ? const Center(child: CustomLoading()):
                          CustomButton(text: LocaleKeys.saveEdits.tr(), onPressed: () {cubit.editPassword();}, widthBtn: width,),
                          SizedBox(height: height*0.01),

                        ],
                      ),
                    ),
                  )




                ],
              ),
            ),
          );}));
  }
}
