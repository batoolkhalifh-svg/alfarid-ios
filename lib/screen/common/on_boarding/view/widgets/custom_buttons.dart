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
          padding: EdgeInsets.symmetric(vertical: height * 0.06),
          child: cubit.isLast
              ? _buildStartNowButton()
              : _buildNextAndSkipRow(cubit, context),
        );
      },
    );
  }

  Widget _buildStartNowButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.06),
      width: width,
      height: height * 0.065,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.mainColor, AppColors.mainColor2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.r15),
        boxShadow: [
          BoxShadow(
            color: AppColors.mainColor.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.r15),
          onTap: () => navigateAndFinish(widget: const RegisterASScreen()),
          child: Center(
            child: Text(
              LocaleKeys.startNow.tr(),
              style: Styles.textStyle16.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNextAndSkipRow(cubit, BuildContext context) {
    return Row(
      children: [
        SlideInRight(
          duration: const Duration(milliseconds: 800),
          child: _gradientNextButton(cubit, context),
        ),
        const Spacer(),
        _skipButton(context),
      ],
    );
  }

  Widget _gradientNextButton(cubit, BuildContext context) {
    return Container(
      width: width * 0.35,
      height: height * 0.065,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.mainColor, AppColors.mainColor2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.r15),
        boxShadow: [
          BoxShadow(
            color: AppColors.mainColor.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.r15),
          onTap: () {
            if (cubit.isLast) {
              navigateAndFinish(widget: const RegisterASScreen());
            } else {
              cubit.pageViewController.nextPage(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
              );
            }
          },
          child: Center(
            child: Text(
              LocaleKeys.next.tr(),
              style: Styles.textStyle14.copyWith(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _skipButton(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.r10),
      onTap: () => navigateAndFinish(widget: const RegisterASScreen()),
      child: Container(
        width: width * 0.25,
        padding: EdgeInsets.symmetric(vertical: height * 0.01),
        child: Text(
          LocaleKeys.skip.tr(),
          style: Styles.textStyle14.copyWith(
            color: AppColors.blackColor.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}