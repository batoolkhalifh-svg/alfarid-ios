import 'package:alfarid/core/local/app_cached.dart';
import 'package:alfarid/core/local/cache_helper.dart';
import 'package:alfarid/core/utils/colors.dart';
import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:alfarid/core/widgets/custom_network_img.dart';
import 'package:alfarid/screen/student/cart/view/cart_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/utils/images.dart';
import '../../../../../../core/utils/size.dart';
import '../../../../../../core/utils/styles.dart';
import '../../../../../../core/widgets/custom_alert_dialogue.dart';
import '../../../../../../generated/locale_keys.g.dart';
import '../../../../../common/notification/view/notification_screen.dart';
import '../../../../search/view/search_screen.dart';
import '../../controller/home_cubit.dart';
import '../../controller/home_states.dart';

class CustomHomeHeader extends StatelessWidget {
  const CustomHomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.onBoardingBgColor,
      surfaceTintColor: AppColors.onBoardingBgColor,
      floating: true,
      snap: true,
      automaticallyImplyLeading: false,
      expandedHeight: height * 0.36,
      toolbarHeight: height * 0.36,
      flexibleSpace: BlocBuilder<HomeCubit, HomeStates>(builder: (context, state) {
        HomeCubit cubit = HomeCubit.get(context);
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(right: width * 0.045, left: width * 0.045, top: height * 0.018),
              child: Row(
                children: [
                  Text(
                    "${LocaleKeys.welcome.tr()} ${CacheHelper.getData(key: AppCached.name) ?? ''}",
                    style: Styles.textStyle14.copyWith(color: AppColors.mainColorText),
                  ),
                  const Spacer(),
                  CacheHelper.getData(key: AppCached.isApple) == true
                      ? const SizedBox.shrink()
                      : GestureDetector(
                          onTap: () {
                            CacheHelper.getData(key: AppCached.token) == null
                                ? showDialog(context: context, builder: (context) => const CustomAlertDialog())
                                : navigateTo(widget: const CartScreen());
                          },
                          child: Image.asset(
                            AppImages.cart,
                            width: width * 0.11,
                          ),
                        ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  GestureDetector(
                    onTap: () {
                      CacheHelper.getData(key: AppCached.token) == null
                          ? showDialog(context: context, builder: (context) => const CustomAlertDialog())
                          : navigateTo(widget: const NotificationScreen());
                    },
                    child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Stack(
                          alignment: AlignmentDirectional.topStart,
                          children: [
                            Icon(
                              Icons.notifications_none_outlined,
                              color: AppColors.mainColor,
                              size: 33.w,
                            ),
                            if(state is !LoadingHomeState&&state is !ErrorHomeState)
                              if(cubit.bannersModel!.data!.notificationsCount!>0)
                              Container(
                                padding: EdgeInsets.all(3.h),
                                decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle
                                ),
                                child: Text(cubit.bannersModel!.data!.notificationsCount.toString()),
                              )
                          ],
                        )),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                navigateTo(widget: const SearchScreen());
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: height * 0.02, horizontal: width * 0.045),
                padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: width * 0.022),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.r8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.searchAbout.tr(),
                      style: Styles.textStyle14.copyWith(color: AppColors.grayColor2, fontFamily: AppFonts.almaraiRegular),
                    ),
                    Image.asset(AppImages.search, width: width * 0.1)
                  ],
                ),
              ),
            ),
            state is LoadingHomeState
                ? Container(
                    width: double.infinity,
                    height: height * 0.16,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.04),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  )
                : CarouselSlider(
                    items: List.generate(
                      cubit.bannersModel!.data!.banners!.length,
                      (index) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: width * .045),
                          child: CustomNetworkImg(
                            width: width,
                            fit: BoxFit.fill,
                            img: cubit.bannersModel!.data!.banners![index].image!,
                          )),
                    ),
                    options: CarouselOptions(
                      viewportFraction: 1,
                      height: height * 0.16,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, reason) {
                        cubit.changeIndex(index);
                      },
                    ),
                  ),
          ],
        );
      }),
    );
  }
}
