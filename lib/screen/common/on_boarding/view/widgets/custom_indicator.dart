import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/size.dart';
import '../../controller/on_boarding_cubit.dart';
import '../../controller/on_boarding_states.dart';

class CustomIndicator extends StatelessWidget {
  const CustomIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnBoardingCubit, OnBoardingStates>(
      builder: (context, state) {
        final cubit = BlocProvider.of<OnBoardingCubit>(context);
        return Padding(
          padding: EdgeInsets.only(top: height*.01, bottom: height*.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(cubit.onBoardingModel!.data!.length, (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: width * .007),
              height: height * .016,
              width: width * .036,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.r10),
                border: Border.all(color: cubit.index == index ? AppColors.mainColor:Colors.transparent),
                color: AppColors.mainColor.withOpacity(.2),
              ),
            ),
            ),
          ),
        );
      },
    );
  }
}