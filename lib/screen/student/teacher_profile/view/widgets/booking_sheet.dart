import 'dart:io';

import 'package:alfarid/core/widgets/custom_btn.dart';
import 'package:alfarid/core/widgets/custom_textfield.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_loading.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../controller/teacher_profile_cubit.dart';

class BookingSheet extends StatefulWidget {
  final String? classroomType;
  const BookingSheet({super.key, this.classroomType});

  @override
  State<BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<BookingSheet> {
  List<File> selectedFiles = [];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TeacherProfileCubit>();
    cubit.classroomType = widget.classroomType;

    /// جلب السعر من API أول ما تفتح الشاشة
    if (widget.classroomType != null && cubit.basePrice == null) {
      cubit.getPriceFromAPI(schoolType: widget.classroomType!);
    }

    return BlocBuilder<TeacherProfileCubit, BaseStates>(
        builder: (context, state) {
          final availability = cubit.teacherProfileModel?.data?.availability;
          final firstDay =
          (availability != null && availability.isNotEmpty) ? availability.first.days?.first : null;
          final slots = firstDay?.slots ?? [];

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Text(
                      LocaleKeys.bookingPrivateSession.tr(),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                    )),

                /// السعر الأساسي
                if (cubit.basePrice != null)
                  Text("سعر الساعة: ${cubit.basePrice} دينار",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),

                /// السعر النهائي
                if (cubit.finalPrice != null)
                  Text("السعر حسب المدة: ${cubit.finalPrice!.toStringAsFixed(2)} ريال",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16.sp)),

                SizedBox(height: 10.h),
                Text(LocaleKeys.availableDays.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
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
                            border: Border.all(
                                color: cubit.selectedDays.contains(cubit.availableDays[index])
                                    ? AppColors.mainColor
                                    : Colors.grey)),
                        child: Text(
                          cubit.availableDays[index].day,
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: cubit.selectedDays.contains(cubit.availableDays[index])
                                  ? AppColors.mainColor
                                  : Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10.h),
                Text(LocaleKeys.availableTimes.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                Row(
                  children: [
                    Expanded(
                        child:
                        Text('${LocaleKeys.from.tr()}: ${slots.isNotEmpty ? slots.first : '-'}')),
                    Expanded(
                        child:
                        Text('${LocaleKeys.to.tr()}: ${slots.isNotEmpty ? slots.last : '-'}')),
                  ],
                ),

                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        ctrl: cubit.startTime,
                        readOnly: true,
                        onTap: () => showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        ).then((value) {
                          if (value != null) cubit.getTime(val: value, ctrl: cubit.startTime);
                        }),
                        hint: LocaleKeys.startTime.tr(),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: CustomTextField(
                        ctrl: cubit.endTime,
                        readOnly: true,
                        onTap: () => showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        ).then((value) {
                          if (value != null) cubit.getTime(val: value, ctrl: cubit.endTime);
                        }),
                        hint: LocaleKeys.endTime.tr(),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 15.h),
                /// زر اختيار الملفات
                ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      allowMultiple: true,
                      type: FileType.custom,
                      allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'txt','jpg','jpeg','png'],
                    );
                    if (result != null) {
                      setState(() {
                        selectedFiles = result.paths.map((path) => File(path!)).toList();
                      });
                    }
                  },
                  child: Text(selectedFiles.isEmpty
                      ? "اختر الملفات"
                      : "${selectedFiles.length} ملف/ملفات مختارة"),
                ),

                /// عرض الملفات المختارة
                if (selectedFiles.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: selectedFiles
                        .map((file) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: Text("- ${file.path.split('/').last}",
                          style: TextStyle(fontSize: 14.sp)),
                    ))
                        .toList(),
                  ),

                SizedBox(height: 20.h),
                state is BaseStatesLoadingState2
                    ? const Center(child: CustomLoading())
                    : CustomButton(
                  text: LocaleKeys.directBooking.tr(),
                  onPressed: () {
                    // ✅ إنشاء الـ Map للملفات لكل يوم
                    Map<String, List<File>> filesPerDay = {
                      for (var day in cubit.selectedDays) day.key: selectedFiles
                    };

                    // ✅ استدعاء دالة الحجز
                    cubit.directReserve(
                      id: cubit.teacherProfileModel!.data!.id!,
                      filesPerDay: filesPerDay,
                    );
                  },
                  widthBtn: double.infinity,
                )

              ],
            ),
          );
        });
  }
}
