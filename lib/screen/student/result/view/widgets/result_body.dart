
import 'package:alfarid/core/utils/colors.dart';
import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:alfarid/core/utils/styles.dart';
import 'package:alfarid/core/widgets/custom_btn.dart';
import 'package:alfarid/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../bottom_nav_student/view/bottom_nav_screen.dart';
import '../../controller/result_cubit.dart';

class ResultBody extends StatelessWidget {
  final List data;

  const ResultBody({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider<ResultCubit>(
            create: (context) => ResultCubit(),
            child: BlocBuilder<ResultCubit, BaseStates>(builder: (context, state) {
              var cubit = ResultCubit.get(context);
              return SafeArea(
                  child: Center(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: height*0.07),
                          Image.asset(AppImages.result,width: width*0.4,),
                          SizedBox(height: height*0.02),
                          Text(LocaleKeys.result.tr(),style: Styles.textStyle20,),
                          SizedBox(height: height*0.01),
                          // Text(LocaleKeys.youHaveComplete.tr(),style: Styles.textStyle14.copyWith(color: AppColors.grayColor),),
                          SizedBox(height: height*0.05),
                          Expanded(
                            child: GridView.builder(
                              padding: EdgeInsetsDirectional.symmetric(horizontal: width*0.06),
                              itemCount: 4,
                              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2 ,
                                  crossAxisSpacing: width*0.03,
                                  mainAxisSpacing: width*0.03,
                                  childAspectRatio:1.2
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  padding: EdgeInsetsDirectional.symmetric(horizontal: width*0.015,vertical: width*0.02),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(AppRadius.r17)
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(cubit.resultsImages[index],width: width*0.1,),
                                      SizedBox(width: width*0.02,),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width:width*0.27,
                                              child: Text(cubit.resultsText[index],style: Styles.textStyle12.copyWith(color: AppColors.blackColor,fontFamily: AppFonts.almaraiBold),)),
                                          SizedBox(height: height*0.008),
                                          Text(data[index].toString(),style: Styles.textStyle12.copyWith(fontFamily: AppFonts.almaraiBold),),
                                        ],
                                      )
                                      
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          CustomButton(text: LocaleKeys.home.tr(), onPressed: (){navigateAndFinish(widget: const BottomNavScreen());}, widthBtn: width*0.85),
                          SizedBox(height: height*0.015,)




                        ]),
                  ));
            })));
  }
}
