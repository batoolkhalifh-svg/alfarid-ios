import 'package:alfarid/core/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../core/widgets/custom_network_img.dart';
import '../../controller/on_boarding_cubit.dart';
import '../../controller/on_boarding_states.dart';


class CustomPageView extends StatelessWidget {
  const CustomPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnBoardingCubit,OnBoardingStates>(
        builder: (context,state) {
          final cubit = BlocProvider.of<OnBoardingCubit>(context);
          return SizedBox(
            height: height*.725,
            child: PageView.builder(
              controller: cubit.pageViewController,
              itemBuilder: (context, index) => Stack(
                   children: [
                     SizedBox(width: width,height: height,),
                  Container(
                    margin: EdgeInsets.only(top: height*0.04),
                      width: width,
                      height: height*.55,
                      child: CustomNetworkImg(img: cubit.onBoardingModel!.data![index].image.toString(),height: height*.5,)
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: height*.3,
                      width: width,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(AppImages.onBoardingBottom),
                            fit: BoxFit.fill),
                      ),
                      child: Padding(
                        padding:  EdgeInsets.only(top: height*0.13),
                        child: Column(
                          children: [
                            Text(cubit.onBoardingModel!.data![index].title.toString(),style: Styles.textStyle20,textAlign: TextAlign.center),
                           SizedBox(height: height*0.02,),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: width*.04),
                                  child:
                                  Text(cubit.onBoardingModel!.data![index].desc.toString(),
                                    textAlign: TextAlign.center,style: Styles.textStyle14.copyWith(color: AppColors.grayColor,fontFamily: AppFonts.almaraiRegular),),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                ],
              ),
              itemCount:cubit.onBoardingModel!.data!.length,
              onPageChanged: (index) {
                cubit.pageChanged(i: index);
              },
            ),
          );
        }
    );
  }
}