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
            borderRadius: BorderRadius.circular(25), // بدل AppRadius.r25,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: height * .015, horizontal: width * .08),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(cubit.btmList.length, (index) {
              bool isSelected = cubit.currentIndex == index;

              return InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  if (CacheHelper.getData(key: AppCached.token) == null &&
                      (index == 1 || index == 2 || index == 3)) {
                    showDialog(
                        context: context,
                        builder: (context) => const CustomAlertDialog());
                  } else {
                    cubit.changeIndex(index: index);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(vertical: height * 0.005, horizontal: width*0.02),
                  decoration: BoxDecoration(
                    borderRadius:BorderRadius.circular(25), // بدل AppRadius.r25,
                    color: isSelected ? AppColors.mainColor.withOpacity(0.1) : Colors.transparent,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedScale(
                        scale: isSelected ? 1.2 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: Image.asset(
                          isSelected
                              ? cubit.btmListSelected[index].image
                              : cubit.btmList[index].image,
                          height: height * 0.035,
                          matchTextDirection: true,
                          color: isSelected ? AppColors.mainColor : AppColors.grayColor,
                        ),
                      ),
                      SizedBox(height: height * 0.008),
                      Text(
                        cubit.btmList[index].title,
                        style: Styles.textStyle12.copyWith(
                          color: isSelected ? AppColors.mainColor : AppColors.grayColor,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          fontFamily: AppFonts.iBMPlexSansArabicRegular,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}