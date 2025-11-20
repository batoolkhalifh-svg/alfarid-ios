import 'package:alfarid/core/widgets/custom_btn.dart';
import 'package:alfarid/core/widgets/custom_textfield.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_loading.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../controller/teacher_profile_cubit.dart';

class BookingSheet extends StatelessWidget {
  const BookingSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherProfileCubit, BaseStates>(builder: (context, state) {
      final cubit = context.read<TeacherProfileCubit>();
      final availability = cubit.teacherProfileModel?.data?.availability;
      final firstDay = (availability != null && availability.isNotEmpty)
          ? availability.first.days?.first
          : null;
      final slots = firstDay?.slots ?? [];
      return SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          spacing: 9.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text(LocaleKeys.bookingPrivateSession.tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp))),
            Text(LocaleKeys.availableDays.tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
            Wrap(
              spacing: 11.w,
              runSpacing: 11.w,
              children: List.generate(
                cubit.availableDays.length,
                (index) => InkWell(
                  splashColor: Colors.transparent,
                  onTap: () => cubit.addDay(v: cubit.availableDays[index]),
                  child: Container(
                    padding: EdgeInsets.all(7.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13.r),
                        border: Border.all(color: cubit.selectedDays.contains(cubit.availableDays[index]) ? AppColors.mainColor : Colors.grey)),
                    child: Text(
                      cubit.availableDays[index].day,
                      style: TextStyle(
                          fontSize: 16.sp, color: cubit.selectedDays.contains(cubit.availableDays[index]) ? AppColors.mainColor : Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            Text(LocaleKeys.availableTimes.tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
            Row(
              children: [
                Expanded(child: Text('${LocaleKeys.from.tr()}: ${slots.isNotEmpty ? slots.first : '-'}')),
                Expanded(child: Text('${LocaleKeys.to.tr()}: ${slots.isNotEmpty ? slots.last : '-'}')),
              ],
            ),
            Row(
              spacing: 13.w,
              children: [
                Expanded(
                  child: CustomTextField(
                    ctrl: cubit.startTime,
                    readOnly: true,
                    onTap: () => showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    ).then((value) {
                      cubit.getTime(val: value!, ctrl: cubit.startTime);
                    }),
                    hint: LocaleKeys.startTime.tr(),
                  ),
                ),
                Expanded(
                  child: CustomTextField(
                    ctrl: cubit.endTime,
                    readOnly: true,
                    onTap: () => showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    ).then((value) {
                      cubit.getTime(val: value!, ctrl: cubit.endTime);
                    }),
                    hint: LocaleKeys.endTime.tr(),
                  ),
                ),
              ],
            ),
            Text(LocaleKeys.noteMustBeInRange.tr(), style: TextStyle(color: Colors.red, fontSize: 14.sp)),
            state is BaseStatesLoadingState2
                ? const Center(child: CustomLoading()) :
            CustomButton(
                text: LocaleKeys.directBooking.tr(),
                onPressed: () => cubit.directReserve(id: cubit.teacherProfileModel!.data!.id!),
                widthBtn: double.infinity)
          ],
        ),
      );
    });
  }
}
