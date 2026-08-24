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
    return BlocProvider(
      create: (context) => ForgetPassCubit(),
      child: BlocBuilder<ForgetPassCubit, BaseStates>(
        builder: (context, state) {
          var cubit = ForgetPassCubit.get(context);

          return CustomAuthBg(
            widget: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.08,
                  vertical: height * 0.12,
                ),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(width * 0.06),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.lock_reset_rounded,
                          size: 70,
                          color: Theme.of(context).primaryColor,
                        ),

                        SizedBox(height: height * 0.02),

                        Text(
                          LocaleKeys.forgetPass.tr(),
                          style: Styles.textStyle20.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: height * 0.015),

                        Text(
                          "أدخل بريدك الإلكتروني لإرسال رابط إعادة تعيين كلمة المرور",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            height: 1.6,
                          ),
                        ),

                        SizedBox(height: height * 0.04),

                        CustomTextField(
                          ctrl: cubit.emailController,
                          hint: LocaleKeys.email.tr(),
                          prefixImg: AppImages.email,
                          isPrefixImg: true,
                        ),

                        SizedBox(height: height * 0.04),

                        state is BaseStatesLoadingState
                            ? const CustomLoading()
                            : CustomButton(
                          text: LocaleKeys.send.tr(),
                          onPressed: () {
                            cubit.forgetPass();
                          },
                          widthBtn: width,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}