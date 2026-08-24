import 'package:alfarid/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/base_state.dart';
import '../../../../core/widgets/custom_error.dart';
import '../controller/timetable_cubit.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onBoardingBgColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Timetable",
          style: TextStyle(
            color: AppColors.mainColorBold,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: BlocProvider(
        create: (context) => TimetableCubit()..fetchTimeTable(),
        child: BlocBuilder<TimetableCubit, BaseStates>(
          builder: (context, state) {
            final cubit = context.read<TimetableCubit>();

            if (state is BaseStatesLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BaseStatesErrorState) {
              return CustomError(
                title: state.msg,
                onPressed: () => cubit.fetchTimeTable(),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 📅 SECTION TITLE
                  Text(
                    "Select Days",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.mainColorBold,
                    ),
                  ),

                  SizedBox(height: 12.h),

                  /// 🔵 DAYS (Premium Chips)
                  Wrap(
                    spacing: 10.w,
                    runSpacing: 10.w,
                    children: List.generate(
                      cubit.weekDays.length,
                          (index) {
                        final day = cubit.weekDays[index];
                        final selected = cubit.days.contains(day);

                        return GestureDetector(
                          onTap: () => cubit.addDay(v: day),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.mainColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: selected
                                    ? AppColors.mainColor
                                    : AppColors.borderColor,
                              ),
                              boxShadow: selected
                                  ? [
                                BoxShadow(
                                  color: AppColors.mainColor
                                      .withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                )
                              ]
                                  : [],
                            ),
                            child: Text(
                              day.day,
                              style: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : AppColors.blackColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 25.h),

                  /// ⏰ TIME SECTION CARD
                  _timeCard(
                    context,
                    title: "Start Time",
                    controller: cubit.startTime,
                    onTap: () => _pickTime(context, cubit.startTime, cubit),
                  ),

                  SizedBox(height: 12.h),

                  _timeCard(
                    context,
                    title: "End Time",
                    controller: cubit.endTime,
                    onTap: () => _pickTime(context, cubit.endTime, cubit),
                  ),

                  SizedBox(height: 40.h),

                  /// 🚀 BUTTON PREMIUM
                  Container(
                    width: double.infinity,
                    height: 52.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.r),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.mainColor,
                          AppColors.mainColor2,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.mainColor.withOpacity(0.25),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        )
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () => cubit.sendTime(),
                      child: Text(
                        "Send Schedule",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 15.sp,
                        ),
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

  Widget _timeCard(
      BuildContext context, {
        required String title,
        required TextEditingController controller,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time, color: AppColors.mainColor),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                controller.text.isEmpty ? title : controller.text,
                style: TextStyle(
                  color: controller.text.isEmpty
                      ? AppColors.grayColor
                      : AppColors.blackColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickTime(
      BuildContext context,
      TextEditingController ctrl,
      TimetableCubit cubit,
      ) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value != null) {
        cubit.getTime(val: value, ctrl: ctrl);
      }
    });
  }
}