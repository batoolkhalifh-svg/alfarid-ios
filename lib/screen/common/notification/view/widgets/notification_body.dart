import 'package:alfarid/core/utils/colors.dart';
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

class NotificationBody extends StatefulWidget {
  const NotificationBody({super.key});

  @override
  State<NotificationBody> createState() =>
      _NotificationBodyState();
}

class _NotificationBodyState
    extends State<NotificationBody> {
  final ScrollController controller =
  ScrollController();

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      final cubit =
      NotificationCubit.get(context);

      if (controller.position.pixels >=
          controller.position
              .maxScrollExtent -
              100) {
        if (cubit.myNotificationModel !=
            null &&
            cubit.currentPage <
                (cubit
                    .myNotificationModel!
                    .data!
                    .paginate!
                    .totalPages ??
                    1)) {
          cubit.nextNotification();
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      AppColors.onBoardingBgColor,
      body: BlocProvider(
        create: (context) =>
        NotificationCubit()
          ..getNotification(),
        child: BlocBuilder<
            NotificationCubit,
            BaseStates>(
          builder: (context, state) {
            var cubit =
            NotificationCubit.get(
                context);

            return SafeArea(
              child: Column(
                children: [
                  CustomArrow(
                    text:
                    LocaleKeys.notification
                        .tr(),
                  ),

                  /// header card
                  Container(
                    margin:
                    EdgeInsets.symmetric(
                      horizontal:
                      width * 0.06,
                      vertical:
                      height * 0.015,
                    ),
                    padding:
                    EdgeInsets.all(
                      width * 0.04,
                    ),
                    decoration:
                    BoxDecoration(
                      color:
                      Colors.white,
                      borderRadius:
                      BorderRadius.circular(
                        18,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors
                              .mainColor
                              .withOpacity(
                            0.05,
                          ),
                          blurRadius: 16,
                          offset:
                          const Offset(
                            0,
                            5,
                          ),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons
                              .notifications_active_rounded,
                          color:
                          AppColors.mainColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "الإشعارات الجديدة",
                          style:
                          TextStyle(
                            fontWeight:
                            FontWeight.bold,
                            fontSize: 15,
                            color:
                            AppColors.mainColorBold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Builder(
                      builder: (_) {
                        if (state
                        is BaseStatesLoadingState &&
                            cubit
                                .data
                                .isEmpty) {
                          return const Center(
                            child:
                            CustomLoading(
                              fullScreen:
                              true,
                            ),
                          );
                        }

                        if (state
                        is BaseStatesErrorState &&
                            cubit
                                .data
                                .isEmpty) {
                          return CustomError(
                            title:
                            state.msg,
                            onPressed:
                                () =>
                                cubit.getNotification(),
                          );
                        }

                        if (cubit
                            .data
                            .isEmpty) {
                          return Center(
                            child:
                            EmptyList(
                              img: AppImages
                                  .emptyNotification,
                              text: LocaleKeys
                                  .emptyNotification
                                  .tr(),
                            ),
                          );
                        }

                        return ListView.separated(
                          controller:
                          controller,
                          padding:
                          EdgeInsets.symmetric(
                            horizontal:
                            width *
                                0.06,
                            vertical:
                            height *
                                0.01,
                          ),
                          itemBuilder:
                              (
                              context,
                              index,
                              ) {
                            if (index <
                                cubit
                                    .data
                                    .length) {
                              final item =
                              cubit.data[index];

                              return NotificationItem(
                                text1: item
                                    .title
                                    .toString(),
                                type: item
                                    .type
                                    .toString(),
                                text2: item
                                    .body
                                    .toString(),
                                img: item
                                    .icon
                                    .toString(),
                                time: item
                                    .time
                                    .toString(),
                              );
                            }

                            return const Padding(
                              padding:
                              EdgeInsets.symmetric(
                                vertical:
                                12,
                              ),
                              child:
                              Center(
                                child:
                                CustomLoading(),
                              ),
                            );
                          },
                          separatorBuilder:
                              (
                              context,
                              index,
                              ) =>
                              SizedBox(
                                height:
                                height *
                                    0.015,
                              ),
                          itemCount: cubit
                              .data
                              .length +
                              ((state
                              is BaseStatesChangeState)
                                  ? 1
                                  : 0),
                        );
                      },
                    ),
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