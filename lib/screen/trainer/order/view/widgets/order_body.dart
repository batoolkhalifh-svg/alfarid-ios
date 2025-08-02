
import 'package:alfarid/core/utils/colors.dart';
import 'package:alfarid/core/utils/size.dart';
import 'package:alfarid/core/utils/styles.dart';
import 'package:alfarid/core/widgets/custom_loading.dart';
import 'package:alfarid/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_arrow.dart';
import '../../../../../core/widgets/custom_btn.dart';
import '../../../../../core/widgets/custom_error.dart';
import '../../../home_teacher/view/widgets/list_item.dart';
import '../../controller/order_cubit.dart';

class OrderBody extends StatelessWidget {
  const OrderBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<OrderCubit>(
          create: (context) => OrderCubit()..fetchCurrentOrder(),
          child: BlocBuilder<OrderCubit, BaseStates>(
              builder: (context, state) {
            var cubit = OrderCubit.get(context);
            return SafeArea(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 CustomArrow(text: LocaleKeys.bookingRequests.tr(),withArrow: false,),
                  state is BaseStatesLoadingState ? Padding(
                    padding:  EdgeInsets.only(top: width*0.16),
                    child: const Center(child: CustomLoading(fullScreen: true,)),
                  ):
                  state is BaseStatesErrorState ? Padding(
                    padding:  EdgeInsets.only(top: width*0.46),
                    child: Center(child: CustomError(title: state.msg, onPressed: (){
                      cubit.fetchCurrentOrder();
                    })),
                  ):
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.07, vertical: width * 0.03),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomButton(hit: height * 0.062,text: LocaleKeys.currentRequests.tr(), onPressed: (){cubit.changeCourse(true);}, widthBtn: width*0.41,color: cubit.isCurrent==true?true:false),
                                CustomButton(hit: height * 0.062,text: LocaleKeys.answered.tr(),
                                    onPressed: (){cubit.changeCourse(false);}, widthBtn: width*0.41,color: cubit.isCurrent==false?true:false),
                              ],
                            ),
                            SizedBox(height: height*0.025),
                            SizedBox(
                              height: height*0.6,
                              child: cubit.isCurrent==true?
                              cubit.currentOrderModel!.data!.isEmpty?
                              Center(child: Text(LocaleKeys.noReservations.tr(),style: Styles.textStyle14.copyWith(color: AppColors.mainColorText))):
                              ListView.separated(itemBuilder: (context, index){
                                return ListItem(id: cubit.currentOrderModel!.data![index].id!,
                                  image: cubit.currentOrderModel!.data![index].student!.image!,
                                  name:  cubit.currentOrderModel!.data![index].student!.name!,
                                  classRoom:  cubit.currentOrderModel!.data![index].student!.classroom!, status: cubit.currentOrderModel!.data![index].status!,);
                              }, separatorBuilder: (BuildContext context, int index) {
                                return SizedBox(height: height*0.01);
                              }, itemCount: cubit.currentOrderModel!.data!.length):
                               cubit.doneOrderModel!.data!.isEmpty?
                                   Center(child: Text(LocaleKeys.noReservations.tr(),style: Styles.textStyle14.copyWith(color: AppColors.mainColorText),)):
                              ListView.separated(itemBuilder: (context, index){
                                return ListItem(id: cubit.doneOrderModel!.data![index].id!,
                                  image: cubit.doneOrderModel!.data![index].student!.image!,
                                  name:  cubit.doneOrderModel!.data![index].student!.name!,
                                  classRoom:  cubit.doneOrderModel!.data![index].student!.classroom!,status: cubit.doneOrderModel!.data![index].status!);
                              }, separatorBuilder: (BuildContext context, int index) {
                                return SizedBox(height: height*0.01);
                              }, itemCount: cubit.doneOrderModel!.data!.length,)),

                          ])),

                ],
            ));
          })),
    );
  }
}
