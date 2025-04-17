import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/my_navigate.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../core/widgets/custom_btn.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../auth/register_as/view/register_as_screen.dart';
import '../../controller/on_boarding_cubit.dart';
import '../../controller/on_boarding_states.dart';

class CustomOnBoardingBottomBtn extends StatelessWidget {
  const CustomOnBoardingBottomBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnBoardingCubit, OnBoardingStates>(
        builder: (context, state) {
      final cubit = BlocProvider.of<OnBoardingCubit>(context);
      return Padding(
        padding: EdgeInsets.symmetric(vertical: height * .06),
        child: cubit.isLast == true ?
        Container(
          margin: EdgeInsets.symmetric(horizontal: width * .06),
          width: width,
          child: CustomButton(text: LocaleKeys.startNow.tr(), onPressed: () {
            navigateAndFinish(widget: const RegisterASScreen());
          }, widthBtn: width,),
        ) :
        Row(
          children: [
            context.locale.languageCode == "ar" ?
            SlideInRight(
              duration: const Duration(seconds: 1),
              child: SizedBox(
                  width: width * .35,
                  child: CustomButton(
                    text: LocaleKeys.next.tr(), onPressed: () {
                    if (cubit.isLast == true) {
                      navigateAndFinish(widget: const RegisterASScreen());
                    } else {
                      cubit.pageViewController.nextPage(
                          duration: const Duration(seconds: 1),
                          curve: Curves.fastEaseInToSlowEaseOut);
                    }
                  }, widthBtn: width * .35,)),
            ) : SlideInLeft(
              duration: const Duration(seconds: 1),
              child: SizedBox(
                  width: width * .35,
                  child: CustomButton(
                    text: LocaleKeys.next.tr(), onPressed: () {
                    if (cubit.isLast == true) {
                      navigateAndFinish(widget: const RegisterASScreen());
                    } else {
                      cubit.pageViewController.nextPage(
                          duration: const Duration(seconds: 1),
                          curve: Curves.fastEaseInToSlowEaseOut);
                    }
                  }, widthBtn: width * .35,)),
            ),
            const Spacer(),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                navigateAndFinish(widget: const RegisterASScreen());
              },
              child: Container(
                width: width * .25,
                padding: EdgeInsets.all(width * .02),
                child: Text(
                  LocaleKeys.skip.tr(), style: Styles.textStyle14.copyWith(
                  color: AppColors.blackColor,
                ), textAlign: TextAlign.center,),
              ),
            ),
          ],
        ),
      );
    }); }
}
