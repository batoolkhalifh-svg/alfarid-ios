import 'dart:io';
import 'package:alfarid/core/widgets/custom_btn.dart';
import 'package:alfarid/core/widgets/custom_loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/widgets/base_state.dart';
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

    if (widget.classroomType != null && cubit.basePrice == null) {
      cubit.getPriceFromAPI(schoolType: widget.classroomType!);
    }

    return BlocBuilder<TeacherProfileCubit, BaseStates>(
      builder: (context, state) {
        // ⏰ جلب الأوقات المتاحة
        final availability = cubit.teacherProfileModel?.data?.availability;
        final firstDay =
        (availability != null && availability.isNotEmpty)
            ? availability.first.days?.first
            : null;
        final slots = firstDay?.slots ?? [];

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🟢 Drag Indicator
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 15.h),

              /// 🧾 Title
              Center(
                child: Text(
                  LocaleKeys.bookingPrivateSession.tr(),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              /// 💰 السعر الأساسي
              if (cubit.basePrice != null)
                _cardSection(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("سعر الساعة"),
                      Text(
                        "${cubit.basePrice} دينار",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),

              /// 💰 السعر النهائي
              if (cubit.finalPrice != null)
                _cardSection(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("السعر النهائي"),
                      Text(
                        "${cubit.finalPrice!.toStringAsFixed(2)} ريال",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 15.h),

              /// 📅 الأيام
              Text(
                LocaleKeys.availableDays.tr(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
              ),
              SizedBox(height: 10.h),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: cubit.availableDays.map((day) {
                  final selected = cubit.selectedDays.contains(day);

                  return GestureDetector(
                    onTap: () => cubit.addDay(v: day),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.mainColor : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        day.day,
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 15.h),

              /// ⏰ الأوقات المتاحة للمعلم
              if (slots.isNotEmpty)
                _cardSection(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${LocaleKeys.from.tr()}: ${slots.first}'),
                      Text('${LocaleKeys.to.tr()}: ${slots.last}'),
                    ],
                  ),
                ),

              SizedBox(height: 15.h),

              /// ⏰ اختيار الوقت الشخصي
              Text(
                LocaleKeys.availableTimes.tr(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: _timeField(
                      hint: LocaleKeys.from.tr(),
                      ctrl: cubit.startTime,
                      onTap: () async {
                        final value = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (value != null) cubit.getTime(val: value, ctrl: cubit.startTime);
                      },
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _timeField(
                      hint: LocaleKeys.to.tr(),
                      ctrl: cubit.endTime,
                      onTap: () async {
                        final value = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (value != null) cubit.getTime(val: value, ctrl: cubit.endTime);
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              /// 📎 رفع الملفات
              Text(
                "إرفاق ملفات",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
              ),
              SizedBox(height: 10.h),
              GestureDetector(
                onTap: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    allowMultiple: true,
                    type: FileType.custom,
                    allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'txt', 'jpg', 'jpeg', 'png'],
                  );

                  if (result != null) {
                    setState(() {
                      selectedFiles = result.paths.map((e) => File(e!)).toList();
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.upload_file),
                      const SizedBox(width: 10),
                      Text(
                        selectedFiles.isEmpty
                            ? "رفع ملفات"
                            : "${selectedFiles.length} ملف/ملفات مختارة",
                      ),
                    ],
                  ),
                ),
              ),

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

              SizedBox(height: 25.h),

              /// 🚀 زر الحجز المباشر بتصميم حديث
              state is BaseStatesLoadingState2
                  ? const Center(child: CustomLoading())
                  : Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF0089A6),
                      Color(0xFF004A59),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: MaterialButton(
                  onPressed: () {
                    Map<String, List<File>> filesPerDay = {
                      for (var day in cubit.selectedDays) day.key: selectedFiles
                    };

                    cubit.directReserve(
                      id: cubit.teacherProfileModel!.data!.id!,
                      filesPerDay: filesPerDay,
                    );
                  },
                  child: const Text(
                    "تأكيد الحجز",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 💎 Card Section
  Widget _cardSection({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
          )
        ],
      ),
      child: child,
    );
  }

  /// ⏰ Time Field
  Widget _timeField({
    required String hint,
    required TextEditingController ctrl,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          ctrl.text.isEmpty ? hint : ctrl.text,
        ),
      ),
    );
  }
}