import 'package:alfarid/core/utils/colors.dart';
import 'package:alfarid/core/widgets/base_state.dart';
import 'package:alfarid/core/widgets/custom_btn.dart';
import 'package:alfarid/core/widgets/custom_error.dart';
import 'package:alfarid/core/widgets/custom_loading.dart';
import 'package:alfarid/screen/trainer/timetable/controller/timetable_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../generated/locale_keys.g.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(LocaleKeys.timetable.tr())),
      body: BlocProvider(
        create: (context) => TimetableCubit()..fetchTimeTable(),
        child: BlocBuilder<TimetableCubit, BaseStates>(builder: (context, state) {
          final cubit = context.read<TimetableCubit>();
          if (state is BaseStatesLoadingState) {
            return const Center(child: CustomLoading());
          } else if (state is BaseStatesErrorState) {
            return CustomError(title: state.msg, onPressed: () => cubit.fetchTimeTable());
          } else {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 10.h,
                children: [
                  Text(LocaleKeys.days.tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
                  Wrap(
                    spacing: 11.w,
                    runSpacing: 11.w,
                    children: List.generate(
                      cubit.weekDays.length,
                      (index) => InkWell(
                        splashColor: Colors.transparent,
                        onTap: () => cubit.addDay(v: cubit.weekDays[index]),
                        child: Container(
                          padding: EdgeInsets.all(7.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13.r),
                              border: Border.all(color: cubit.days.contains(cubit.weekDays[index]) ? AppColors.mainColor : Colors.grey)),
                          child: Text(
                            cubit.weekDays[index].day,
                            style: TextStyle(
                                fontSize: 16.sp, color: cubit.days.contains(cubit.weekDays[index]) ? AppColors.mainColor : Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextField(
                    controller: cubit.startTime,
                    readOnly: true,
                    onTap: () => showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    ).then((value) {
                      cubit.getTime(val: value!, ctrl: cubit.startTime);
                    }),
                    decoration: InputDecoration(hintText: LocaleKeys.startTime.tr()),
                  ),
                  TextField(
                    controller: cubit.endTime,
                    readOnly: true,
                    onTap: () => showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    ).then((value) {
                      cubit.getTime(val: value!, ctrl: cubit.endTime);
                    }),
                    decoration: InputDecoration(hintText: LocaleKeys.endTime.tr()),
                  ),
                  SizedBox(height: 70.h),
                  CustomButton(text: LocaleKeys.send.tr(), onPressed: () => cubit.sendTime(), widthBtn: double.infinity)
                ],
              ),
            );
          }
        }),
      ),
    );
  }
}
