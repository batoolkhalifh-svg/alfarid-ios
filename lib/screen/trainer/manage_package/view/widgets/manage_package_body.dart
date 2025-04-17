
import 'package:alfarid/core/utils/size.dart';
import 'package:alfarid/generated/locale_keys.g.dart';
import 'package:alfarid/screen/trainer/home_teacher/view/widgets/custom_blue_btn.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_arrow.dart';
import '../../../../../core/widgets/custom_error.dart';
import '../../../../../core/widgets/custom_loading.dart';
import '../../controller/manage_package_cubit.dart';

class ManagePackageBody extends StatelessWidget {
  const ManagePackageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<ManagePackageCubit>(
          create: (context) => ManagePackageCubit()..fetchPackages(),
          child: BlocBuilder<ManagePackageCubit, BaseStates>(
              builder: (context, state) {
            var cubit = ManagePackageCubit.get(context);
            return SafeArea(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 CustomArrow(text: LocaleKeys.managePackage.tr()),
                  state is  BaseStatesLoadingState2? const Center(child: CustomLoading(fullScreen: true)):
                  state is BaseStatesErrorState ? CustomError(title: state.msg, onPressed: (){
                    cubit.fetchPackages();}):
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.07, vertical: width * 0.03),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: width*0.05,horizontal: width*0.05),
                        width: width*0.86,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.r20)
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(cubit.packageModel!.data!.plan!.name.toString(),style: Styles.textStyle14.copyWith(color: AppColors.mainColor)),
                                      SizedBox(height: width*0.01),
                                      Text("${cubit.packageModel!.data!.price!.round().toString()} ${LocaleKeys.sar.tr()} / ${cubit.packageModel!.data!.duration.toString()} ${LocaleKeys.months.tr()}",style: Styles.textStyle12.copyWith(color: AppColors.blackColor2)),
                                    ],
                                  ),
                                  state is BaseStatesLoadingState ? const CustomLoading():
                                  CustomBlueButton(text: LocaleKeys.reNewPackage.tr(),onTap: (){
                                    cubit.reNewPackage();
                                  },),
                                ],
                              ),
                              Padding(
                                padding:  EdgeInsets.symmetric(vertical: width*0.03),
                                child: const Divider(),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(LocaleKeys.subscriptionDate.tr(),style: Styles.textStyle12.copyWith(color: AppColors.grayColor)),
                                  Text(cubit.packageModel!.data!.startDate.toString(),style: Styles.textStyle12.copyWith(color: AppColors.blackColor2,fontFamily: AppFonts.almaraiBold)),
                                   ],
                              ),
                              SizedBox(height: width*0.02),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(LocaleKeys.remainder.tr(),style: Styles.textStyle12.copyWith(color: AppColors.grayColor)),
                                  Text(cubit.packageModel!.data!.remainingDays.toString(),style: Styles.textStyle12.copyWith(color: AppColors.blackColor2,fontFamily: AppFonts.almaraiBold)),
                                   ],
                              ),
                              SizedBox(height: width*0.02),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(LocaleKeys.packagePrice.tr(),style: Styles.textStyle12.copyWith(color: AppColors.grayColor)),
                                  Text(cubit.packageModel!.data!.price.toString(),style: Styles.textStyle12.copyWith(color: AppColors.blackColor2,fontFamily: AppFonts.almaraiBold)),
                                   ],
                              ),
                              SizedBox(height: width*0.02),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(LocaleKeys.endDate.tr(),style: Styles.textStyle12.copyWith(color: const Color(0xffF45167))),
                                  Text(cubit.packageModel!.data!.endDate.toString(),style: Styles.textStyle12.copyWith(color:const Color(0xffF45167),fontFamily: AppFonts.almaraiBold)),
                                   ],
                              ),
                            ]),
                      )),

                ],
            ));
          })),
    );
  }
}
