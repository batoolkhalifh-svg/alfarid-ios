import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/images.dart';
import '../../../../core/utils/size.dart';
import '../../../../core/utils/styles.dart';
import '../../../../core/widgets/custom_arrow.dart';
import '../../../../core/widgets/custom_loading.dart';
import '../../../../generated/locale_keys.g.dart';
import '../components/live_item.dart';
import '../controller/teacher_live_cubit.dart';
import '../controller/teacher_live_states.dart';


class TeacherLive extends StatelessWidget {
  const TeacherLive({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TeacherLiveCubit()..getLives(context: context),
      child: BlocBuilder<TeacherLiveCubit, TeacherLiveStates>(
        builder: (context, state) {
          final cubit = TeacherLiveCubit.get(context);
          return Scaffold(
              body: SafeArea(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       CustomArrow(text: LocaleKeys.lives.tr(),),
                      SizedBox(height: height * 0.02),
                      state is GetLivesLoading ? const CustomLoading(fullScreen: true):
                          cubit.lives.isEmpty?
                          Align(
                            alignment: AlignmentDirectional.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: height * 0.21),
                                SvgPicture.asset(AppImages.live,),
                                SizedBox(height: height * 0.03),
                               Text(LocaleKeys.notLives.tr(),style: Styles.textStyle16,),
                              ],
                            ),
                          ):
                          Expanded(
                            child: ListView.separated(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) => LiveItem(cubit: cubit,index: index),
                                separatorBuilder: (context, index) => SizedBox(height: height * 0.02),
                                itemCount: cubit.lives.length),
                          )
                    ]),
              ));
        }
      )
    );
  }
}
