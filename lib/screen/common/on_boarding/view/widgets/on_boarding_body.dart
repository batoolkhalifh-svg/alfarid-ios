import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/widgets/custom_error.dart';
import '../../../../../core/widgets/custom_loading.dart';
import '../../controller/on_boarding_cubit.dart';
import '../../controller/on_boarding_states.dart';
import 'custom_buttons.dart';
import 'custom_indicator.dart';
import 'custom_page_view.dart';


class OnBoardingBody extends StatelessWidget {
  const OnBoardingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnBoardingCubit()..fetchOnBoarding(),
      child: BlocBuilder<OnBoardingCubit,OnBoardingStates>(
        builder: (context, state) {
          final cubit = BlocProvider.of<OnBoardingCubit>(context);
          return Scaffold(
            backgroundColor: AppColors.onBoardingBgColor,
            body: Padding(
              padding: EdgeInsets.only(top: height*.04),
              child:
              state is OnBoardingLoadingState ? const CustomLoading(fullScreen: true) :
              state is OnBoardingFailedState ? CustomError(title: state.msg, onPressed: (){cubit.fetchOnBoarding();}) :
             Column(
              children: [
                const CustomPageView(),
               Container(
                 color: Colors.white,
                 child: const Column(
                   children: [
                     CustomIndicator(),
                     CustomOnBoardingBottomBtn(),
                   ],
                 ),
               )
              ],
            )
            ),
          );
        },
      ),
    );
  }
}