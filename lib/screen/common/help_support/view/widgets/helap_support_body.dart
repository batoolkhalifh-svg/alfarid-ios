import 'package:alfarid/core/utils/size.dart';
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
      body: BlocProvider<HelpAndSupportCubit>(
          create: (context) => HelpAndSupportCubit()..helpAndSupport(),
          child: BlocBuilder<HelpAndSupportCubit, BaseStates>(builder: (context, state) {
            var cubit = HelpAndSupportCubit.get(context);
            return SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomArrow(
                  text: LocaleKeys.support.tr(),
                ),
                state is BaseStatesLoadingState
                    ? const CustomLoading(
                        fullScreen: true,
                      )
                    : state is BaseStatesErrorState
                        ? CustomError(
                            title: state.msg,
                            onPressed: () {
                              cubit.helpAndSupport();
                            })
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: width * 0.07, vertical: width * 0.1),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (cubit.helpAndSupportModel!.data!.phone != null)
                                    HelpAndSupportItem(
                                      text1: LocaleKeys.phone.tr(),
                                      text2: cubit.helpAndSupportModel!.data!.phone.toString(),
                                      img: AppImages.phone2,
                                      onTap: () => cubit.launcher(path: "tel://${cubit.helpAndSupportModel!.data!.phone}"),
                                    ),
                                  if (cubit.helpAndSupportModel!.data!.phone1 != null)
                                    HelpAndSupportItem(
                                      text1: LocaleKeys.phone.tr(),
                                      text2: cubit.helpAndSupportModel!.data!.phone1.toString(),
                                      img: AppImages.phone2,
                                      onTap: () => cubit.launcher(path: "tel://${cubit.helpAndSupportModel!.data!.phone1}"),
                                    ),
                                  if (cubit.helpAndSupportModel!.data!.phone2 != null)
                                    HelpAndSupportItem(
                                      text1: LocaleKeys.phone.tr(),
                                      text2: cubit.helpAndSupportModel!.data!.phone2.toString(),
                                      img: AppImages.phone2,
                                      onTap: () => cubit.launcher(path: "tel://${cubit.helpAndSupportModel!.data!.phone2}"),
                                    ),
                                  if (cubit.helpAndSupportModel!.data!.email != null)
                                    HelpAndSupportItem(
                                      text1: LocaleKeys.email.tr(),
                                      text2: cubit.helpAndSupportModel!.data!.email.toString(),
                                      img: AppImages.email2,
                                      onTap: () {
                                        cubit.launcher(path: "mailto:${cubit.helpAndSupportModel!.data!.email}");
                                      },
                                    ),
                                  if (cubit.helpAndSupportModel!.data!.whatsapp != null)
                                    HelpAndSupportItem(
                                      text1: LocaleKeys.whats.tr(),
                                      text2: cubit.helpAndSupportModel!.data!.whatsapp.toString(),
                                      img: AppImages.whats,
                                      onTap: () {
                                        cubit.launcher(
                                            path: "https://api.whatsapp.com/send?phone=${cubit.helpAndSupportModel!.data!.whatsapp}");
                                      },
                                    )
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
