import 'package:alfarid/core/widgets/custom_network_img.dart';
import 'package:alfarid/generated/locale_keys.g.dart';
import 'package:alfarid/screen/student/home/view/controller/home_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/local/app_cached.dart';
import '../../../../../../core/local/cache_helper.dart';
import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/utils/size.dart';
import '../../../../../../core/utils/styles.dart';
import '../../../../../../core/widgets/custom_alert_dialogue.dart';
import '../../../../../../core/widgets/custom_btn.dart';

class HomeOffersSection extends StatelessWidget {
  const HomeOffersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final cubit = context.read<HomeCubit>();
        if (cubit.offersModel.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(width * 0.04),
                child: Text(LocaleKeys.offers.tr(), style: Styles.textStyle14.copyWith(color: AppColors.mainColorBold)),
              ),
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(
                    cubit.offersModel.length,
                    (index) => Container(
                      alignment: AlignmentDirectional.topStart,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.r8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(AppRadius.r8), topRight: Radius.circular(AppRadius.r8)),
                            child: CustomNetworkImg(
                              img: cubit.offersModel[index].imageUrl,
                              fit: BoxFit.cover,
                              width: width * 0.55,
                              height: height * 0.1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.02,
                              vertical: height * 0.01,
                            ),
                            child: SizedBox(
                                width: width * 0.33,
                                child: Text(
                                  cubit.offersModel[index].name.toString(),
                                  style: Styles.textStyle14.copyWith(color: AppColors.mainColor2),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                            child: Text("${LocaleKeys.coursesCount.tr()}${cubit.offersModel[index].coursesCount}",
                                style: TextStyle(fontSize: 14.sp)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                            child: Text(cubit.offersModel[index].price.toString(),
                                style: Styles.textStyle14.copyWith(color: AppColors.mainColor2, fontSize: 15.sp)),
                          ),
                          CustomButton(
                              hit: height * 0.05,
                              text: LocaleKeys.subscribeNow.tr(),
                              onPressed: () {
                                CacheHelper.getData(key: AppCached.token) == null
                                    ? showDialog(
                                    context: context, builder: (context) => const CustomAlertDialog())
                                    : cubit.subscribeOffer(id: cubit.offersModel[index].id);
                              },
                              widthBtn: width * 0.5)
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
