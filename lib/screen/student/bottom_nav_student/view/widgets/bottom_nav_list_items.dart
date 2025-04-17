import 'package:easy_localization/easy_localization.dart' as localize;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/local/app_cached.dart';
import '../../../../../core/local/cache_helper.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_alert_dialogue.dart';
import '../../controller/bottom_nav_cubit.dart';


class CustomBottomNavListItems extends StatelessWidget {
  const CustomBottomNavListItems({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, BaseStates>(
      builder: (context, state) {
        final cubit = BottomNavCubit.get(context);
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: AppColors.borderColor,
              width: .5,
            ),
            borderRadius: BorderRadius.circular(AppRadius.r20),
            boxShadow: [
              BoxShadow(
                color: AppColors.borderColor.withOpacity(0.15),
                spreadRadius: 0,
                blurRadius: 16,
                offset: const Offset(0, 4), // changes position of shadow
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: width * .08),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              cubit.btmList.length, (index) => InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  if(CacheHelper.getData(key: AppCached.token)==null){
                    if(index == 1 || index == 2 || index == 3) {
                      showDialog(context: context, builder: (context)=>const CustomAlertDialog());
                    }
                    else{
                      cubit.changeIndex(index: index);
                    }
                  }
                  else{
                    cubit.changeIndex(index: index);
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: height * .012),
                      child: Directionality(
                        textDirection: context.locale.languageCode == "ar" ? TextDirection.ltr : TextDirection.rtl,
                        child: Image.asset(
                          cubit.currentIndex == index ? cubit.btmListSelected[index].image : cubit.btmList[index].image ,
                          height: height * .03,
                          matchTextDirection: true,
                          color: cubit.currentIndex == index ? AppColors.mainColor : AppColors.grayColor,
                        ),
                      ),
                    ),
                    Text(
                      cubit.btmList[index].title,style: Styles.textStyle10.copyWith(
                      color: cubit.currentIndex == index ? AppColors.mainColor : AppColors.grayColor,
                      fontFamily: AppFonts.iBMPlexSansArabicRegular
                 ),
                    ),
                    SizedBox(
                      height: height * .02,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
