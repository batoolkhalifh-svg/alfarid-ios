import 'package:alfarid/core/utils/size.dart';
import 'package:alfarid/generated/locale_keys.g.dart';
import 'package:alfarid/screen/trainer/home_teacher/view/widgets/custom_blue_btn.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_arrow.dart';
import '../../../../../core/widgets/custom_error.dart';
import '../../../../../core/widgets/custom_loading.dart';
import '../../controller/order_details_cubit.dart';

class OrderDetailsBody extends StatelessWidget {
  final int id;

  const OrderDetailsBody({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<OrderDetailsCubit>(
          create: (context) => OrderDetailsCubit()..fetchOrderDetails(id: id),
          child: BlocBuilder<OrderDetailsCubit, BaseStates>(builder: (context, state) {
            var cubit = OrderDetailsCubit.get(context);
            return SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomArrow(text: LocaleKeys.requestDetails.tr()),
                state is BaseStatesLoadingState
                    ? Padding(
                        padding: EdgeInsets.only(top: width * 0.35),
                        child: const CustomLoading(
                          fullScreen: true,
                        ),
                      )
                    : state is BaseStatesErrorState
                        ? CustomError(
                            title: state.msg,
                            onPressed: () {
                              cubit.fetchOrderDetails(id: id);
                            })
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: width * 0.07, vertical: width * 0.03),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: width * 0.06),
                              width: width * 0.86,
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.r20)),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                CircleAvatar(
                                    radius: AppRadius.r30, backgroundImage: NetworkImage(cubit.orderDetailsModel!.data!.student!.image!)),
                                Text(cubit.orderDetailsModel!.data!.student!.name!,
                                    style: Styles.textStyle14.copyWith(color: AppColors.mainColor)),
                                SizedBox(height: width * 0.01),
                                Text(cubit.orderDetailsModel!.data!.student!.classroom!,
                                    style: Styles.textStyle12.copyWith(
                                        color: AppColors.blackColor2, fontFamily: AppFonts.mulishExtraBold, fontWeight: FontWeight.bold)),
                                SizedBox(height: width * 0.02),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.date_range,
                                      color: AppColors.mainColor2,
                                    ),
                                    Text(cubit.orderDetailsModel!.data!.date.toString(),
                                        style: Styles.textStyle12.copyWith(fontFamily: AppFonts.mulish))
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 9.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('${LocaleKeys.from.tr()}  ${cubit.orderDetailsModel!.data!.timeFrom}'),
                                      Text('${LocaleKeys.to.tr()}  ${cubit.orderDetailsModel!.data!.timeTo}'),
                                    ],
                                  ),
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: List.generate(cubit.daysList.length, (index) => Text(cubit.daysList[index].day))),
                                SizedBox(
                                  height: width * 0.04,
                                ),
                                cubit.orderDetailsModel!.data!.status == "pending"
                                    ? state is BaseStatesLoadingState2
                                        ? const Center(child: CustomLoading())
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              CustomBlueButton(
                                                text: LocaleKeys.accept.tr(),
                                                onTap: () {
                                                  cubit.changStatus(id: cubit.orderDetailsModel!.data!.id!, status: "accepted");
                                                },
                                              ),
                                              SizedBox(width: width * 0.05),
                                              CustomBlueButton(
                                                text: LocaleKeys.reject.tr(),
                                                onTap: () {
                                                  cubit.changStatus(id: cubit.orderDetailsModel!.data!.id!, status: "rejected");
                                                },
                                                isRed: true,
                                              ),
                                            ],
                                          )
                                    : CustomBlueButton(
                                        text: cubit.orderDetailsModel!.data!.status == "accepted"
                                            ? LocaleKeys.acceptedOrder.tr()
                                            : LocaleKeys.rejectedOrder.tr(),
                                        onTap: () {},
                                        isRed: cubit.orderDetailsModel!.data!.status == "rejected" ? true : false),
                              ]),
                            )),
              ],
            ));
          })),
    );
  }
}
