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
        child: BlocBuilder<NotificationCubit, BaseStates>(
          builder: (context, state) {
            var cubit = NotificationCubit.get(context);

            // إضافة Listener للتمرير
            controller.addListener(() {
              if (controller.position.maxScrollExtent == controller.offset) {
                if (cubit.myNotificationModel != null &&
                    cubit.currentPage < (cubit.myNotificationModel!.data!.paginate!.totalPages ?? 1)) {
                  cubit.nextNotification();
                }
              }
            });

            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomArrow(text: LocaleKeys.notification.tr()),
                  Expanded(
                    child: Builder(builder: (_) {
                      if (state is BaseStatesLoadingState && cubit.data.isEmpty) {
                        // تحميل أولي
                        return const Center(
                          child: CustomLoading(fullScreen: true),
                        );
                      } else if (state is BaseStatesErrorState && cubit.data.isEmpty) {
                        return CustomError(
                          title: state.msg,
                          onPressed: () => cubit.getNotification(),
                        );
                      } else if (cubit.data.isEmpty) {
                        return Center(
                          child: EmptyList(
                            img: AppImages.emptyNotification,
                            text: LocaleKeys.emptyNotification.tr(),
                          ),
                        );
                      } else {
                        return ListView.separated(
                          controller: controller,
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.07, vertical: height * 0.024),
                          itemBuilder: (context, index) {
                            if (index < cubit.data.length) {
                              return NotificationItem(
                                text1: cubit.data[index].title.toString(),
                                type: cubit.data[index].type.toString(),
                                text2: cubit.data[index].body.toString(),
                                img: cubit.data[index].icon.toString(),
                                time: cubit.data[index].time.toString(),
                              );
                            } else {
                              // Loader أسفل القائمة عند تحميل المزيد
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Center(child: CustomLoading()),
                              );
                            }
                          },
                          separatorBuilder: (context, index) =>
                              SizedBox(height: height * 0.018),
                          itemCount: cubit.data.length +
                              ((state is BaseStatesChangeState) ? 1 : 0),
                        );
                      }
                    }),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
