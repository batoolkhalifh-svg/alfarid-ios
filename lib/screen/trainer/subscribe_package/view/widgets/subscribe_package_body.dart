import 'package:alfarid/core/utils/images.dart';
import 'package:alfarid/core/utils/size.dart';
import 'package:alfarid/core/widgets/custom_btn.dart';
import 'package:alfarid/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_arrow.dart';
import '../../../../../core/widgets/custom_error.dart';
import '../../../../../core/widgets/custom_loading.dart';
import '../../controller/subscribe_package_cubit.dart';

class SubscribePackageBody extends StatelessWidget {
  const SubscribePackageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<SubscribePackageCubit>(
          create: (context) => SubscribePackageCubit()..fetchPackages(),
          child: BlocBuilder<SubscribePackageCubit, BaseStates>(builder: (context, state) {
            var cubit = SubscribePackageCubit.get(context);
            return SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomArrow(text: LocaleKeys.subscribePackages.tr()),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.07, vertical: width * 0.03),
                      child: state is BaseStatesLoadingState2
                          ? const Center(child: CustomLoading(fullScreen: true))
                          : state is BaseStatesErrorState
                              ? CustomError(
                                  title: state.msg,
                                  onPressed: () {
                                    cubit.fetchPackages();
                                  })
                              : cubit.packageModel!.data!.isEmpty
                                  ? Text(
                                      LocaleKeys.emptyPackage.tr(),
                                      style: Styles.textStyle16.copyWith(color: AppColors.mainColorText, fontFamily: AppFonts.almaraiBold),
                                    )
                                  : ListView.separated(
                                      itemBuilder: (context, index1) {
                                        return Container(
                                          width: width * 0.86,
                                          decoration:
                                              BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.r20)),
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(vertical: width * 0.05, horizontal: width * 0.05),
                                                decoration: BoxDecoration(
                                                    color: const Color(0xffF1F7FF),
                                                    borderRadius: BorderRadiusDirectional.only(
                                                        topEnd: Radius.circular(AppRadius.r20), topStart: Radius.circular(AppRadius.r20))),
                                                child: InkWell(
                                                  onTap: () {
                                                    cubit.changePackage(index: cubit.packageModel!.data![index1].id!);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(cubit.packageModel!.data![index1].id! == cubit.choosePackage
                                                          ? AppImages.packageChoose
                                                          : AppImages.packageNotChoose),
                                                      SizedBox(width: width * 0.025),
                                                      Column(
                                                        children: [
                                                          Text(
                                                            cubit.packageModel!.data![index1].name.toString(),
                                                            style: Styles.textStyle16
                                                                .copyWith(fontFamily: AppFonts.almaraiBold, color: AppColors.mainColor2),
                                                          ),
                                                          SizedBox(height: width * 0.015),
                                                          Text(
                                                            "${LocaleKeys.qAr.tr(args: [
                                                                  cubit.packageModel!.data![index1].price!.round().toString()
                                                                ])} / ${cubit.packageModel!.data![index1].durationInMonths.toString()} ${LocaleKeys.months.tr()}",
                                                            style: Styles.textStyle12.copyWith(color: AppColors.blackColor2),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: width * 0.035),
                                                child: ListView.separated(
                                                    shrinkWrap: true,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    itemBuilder: (context, index) {
                                                      return Row(
                                                        children: [
                                                          SvgPicture.asset(AppImages.check),
                                                          SizedBox(
                                                            width: width * 0.02,
                                                          ),
                                                          Text(
                                                            cubit.packageModel!.data![index1].features![index].toString(),
                                                            style: Styles.textStyle12.copyWith(color: AppColors.blackColor2),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                    separatorBuilder: (BuildContext context, int index) {
                                                      return SizedBox(height: height * 0.015);
                                                    },
                                                    itemCount: cubit.packageModel!.data![index1].features!.length),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                      separatorBuilder: (BuildContext context, int index) {
                                        return SizedBox(height: height * 0.025);
                                      },
                                      itemCount: cubit.packageModel!.data!.length)),
                ),
                cubit.choosePackage == null
                    ? const SizedBox.shrink()
                    : Center(
                        child: state is BaseStatesLoadingState
                            ? const CustomLoading()
                            : CustomButton(
                                text: LocaleKeys.paymentNow.tr(),
                                onPressed: () {
                                  cubit.subscribe();
                                },
                                widthBtn: width * 0.86)),
                SizedBox(
                  height: height * 0.02,
                ),
              ],
            ));
          })),
    );
  }
}
