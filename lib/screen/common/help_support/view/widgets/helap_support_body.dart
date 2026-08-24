import 'package:alfarid/core/utils/size.dart';
import 'package:alfarid/core/utils/colors.dart';
import 'package:alfarid/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/images.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_arrow.dart';
import '../../../../../core/widgets/custom_error.dart';
import '../../../../../core/widgets/custom_loading.dart';
import '../../controller/help_support_cubit.dart';
import 'help_support_item.dart';

class HelpAndSupportBody extends StatelessWidget {
  const HelpAndSupportBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      AppColors.onBoardingBgColor,
      body: BlocProvider(
        create: (context) =>
        HelpAndSupportCubit()
          ..helpAndSupport(),
        child: BlocBuilder<
            HelpAndSupportCubit,
            BaseStates>(
          builder: (context, state) {
            var cubit =
            HelpAndSupportCubit.get(
                context);

            return SafeArea(
              child: Column(
                children: [
                  CustomArrow(
                    text:
                    LocaleKeys.support
                        .tr(),
                  ),

                  Expanded(
                    child: state
                    is BaseStatesLoadingState
                        ? const CustomLoading(
                      fullScreen:
                      true,
                    )
                        : state
                    is BaseStatesErrorState
                        ? Center(
                      child:
                      CustomError(
                        title:
                        state.msg,
                        onPressed:
                            () {
                          cubit
                              .helpAndSupport();
                        },
                      ),
                    )
                        : SingleChildScrollView(
                      padding:
                      EdgeInsets.symmetric(
                        horizontal:
                        width *
                            0.06,
                        vertical:
                        height *
                            0.02,
                      ),
                      child:
                      Column(
                        children: [
                          /// title card
                          Container(
                            width:
                            double.infinity,
                            padding:
                            EdgeInsets.all(
                              width *
                                  0.05,
                            ),
                            margin:
                            EdgeInsets.only(
                              bottom:
                              height *
                                  0.025,
                            ),
                            decoration:
                            BoxDecoration(
                              color:
                              Colors.white,
                              borderRadius:
                              BorderRadius.circular(
                                22,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors
                                      .mainColor
                                      .withOpacity(
                                    0.06,
                                  ),
                                  blurRadius:
                                  18,
                                  offset:
                                  const Offset(
                                    0,
                                    6,
                                  ),
                                ),
                              ],
                            ),
                            child:
                            Column(
                              children: [
                                Icon(
                                  Icons
                                      .support_agent_rounded,
                                  size:
                                  38,
                                  color:
                                  AppColors.mainColor,
                                ),
                                SizedBox(
                                  height:
                                  height *
                                      0.012,
                                ),
                                Text(
                                  "نحن هنا لمساعدتك",
                                  style:
                                  TextStyle(
                                    fontSize:
                                    18,
                                    fontWeight:
                                    FontWeight.bold,
                                    color:
                                    AppColors.mainColorBold,
                                  ),
                                ),
                                SizedBox(
                                  height:
                                  height *
                                      0.006,
                                ),
                                Text(
                                  "تواصل معنا عبر أي وسيلة تناسبك",
                                  style:
                                  TextStyle(
                                    fontSize:
                                    13,
                                    color:
                                    Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// contact items
                          if (cubit
                              .helpAndSupportModel
                              ?.data
                              ?.phone !=
                              null)
                            HelpAndSupportItem(
                              text1:
                              LocaleKeys.phone.tr(),
                              text2: cubit
                                  .helpAndSupportModel!
                                  .data!
                                  .phone
                                  .toString(),
                              img:
                              AppImages.phone2,
                              onTap:
                                  () =>
                                  cubit.launcher(
                                    path:
                                    "tel://${cubit.helpAndSupportModel!.data!.phone}",
                                  ),
                            ),

                          if (cubit
                              .helpAndSupportModel
                              ?.data
                              ?.phone1 !=
                              null)
                            HelpAndSupportItem(
                              text1:
                              LocaleKeys.phone.tr(),
                              text2: cubit
                                  .helpAndSupportModel!
                                  .data!
                                  .phone1
                                  .toString(),
                              img:
                              AppImages.phone2,
                              onTap:
                                  () =>
                                  cubit.launcher(
                                    path:
                                    "tel://${cubit.helpAndSupportModel!.data!.phone1}",
                                  ),
                            ),

                          if (cubit
                              .helpAndSupportModel
                              ?.data
                              ?.phone2 !=
                              null)
                            HelpAndSupportItem(
                              text1:
                              LocaleKeys.whats.tr(),
                              text2: cubit
                                  .helpAndSupportModel!
                                  .data!
                                  .phone2
                                  .toString(),
                              img:
                              AppImages.whats,
                              onTap:
                                  () {
                                cubit
                                    .launcher(
                                  path:
                                  "https://api.whatsapp.com/send?phone=${cubit.helpAndSupportModel!.data!.phone2}",
                                );
                              },
                            ),

                          if (cubit
                              .helpAndSupportModel
                              ?.data
                              ?.email !=
                              null)
                            HelpAndSupportItem(
                              text1:
                              LocaleKeys.email.tr(),
                              text2: cubit
                                  .helpAndSupportModel!
                                  .data!
                                  .email
                                  .toString(),
                              img:
                              AppImages.email2,
                              onTap:
                                  () {
                                cubit
                                    .launcher(
                                  path:
                                  "mailto:${cubit.helpAndSupportModel!.data!.email}",
                                );
                              },
                            ),
                        ],
                      ),
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