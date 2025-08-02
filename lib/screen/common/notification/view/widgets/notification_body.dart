import 'package:alfarid/core/utils/images.dart';
import 'package:alfarid/core/utils/size.dart';
import 'package:alfarid/generated/locale_keys.g.dart';
import 'package:alfarid/screen/common/notification/view/widgets/notification_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_arrow.dart';
import '../../../../../core/widgets/custom_error.dart';
import '../../../../../core/widgets/custom_loading.dart';
import '../../../../../core/widgets/empty_list.dart';
import '../../controller/notification_cubit.dart';

class NotificationBody extends StatelessWidget {
  NotificationBody({super.key});

  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<NotificationCubit>(
          create: (context) => NotificationCubit()..getNotification(),
          child: BlocBuilder<NotificationCubit, BaseStates>(builder: (context, state) {
            var cubit = NotificationCubit.get(context);
            controller.addListener(() {
              if (controller.position.maxScrollExtent == controller.offset) {
                cubit.currentPage == cubit.myNotificationModel!.data!.paginate!.totalPages ? null : cubit.nextNotification();
              }
            });
            return SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomArrow(
                  text: LocaleKeys.notification.tr(),
                ),
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
                              cubit.getNotification();
                            })
                        : cubit.data.isEmpty
                            ? Center(child: EmptyList(img: AppImages.emptyNotification, text: LocaleKeys.emptyNotification.tr()))
                            : Padding(
                                padding: EdgeInsets.symmetric(horizontal: width * 0.07, vertical: width * 0.03),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: height*0.8,
                                        child: ListView.separated(
                                            controller: controller,
                                            padding: EdgeInsetsDirectional.symmetric(vertical: height * 0.024),
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return NotificationItem(
                                                  text1: cubit.data[index].title.toString(),
                                                  type: cubit.data[index].type.toString(),
                                                  text2: cubit.data[index].body.toString(),
                                                  img: cubit.data[index].icon.toString());
                                            },
                                            separatorBuilder: (context, index) {
                                              return SizedBox(height: height * 0.018);
                                            },
                                            itemCount: cubit.data.length),
                                      ),
                                      state is BaseStatesChangeState
                                          ? Padding(
                                              padding: EdgeInsets.symmetric(vertical: height * 0.02),
                                              child: const CustomLoading(),
                                            )
                                          : const SizedBox.shrink()
                                    ],
                                  ),
                                ),
                              ),
              ],
            ));
          })),
    );
  }
}
