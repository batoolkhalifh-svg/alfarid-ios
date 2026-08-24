import 'package:alfarid/screen/trainer/start_vr/view/widgets/student_selector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../controller/start_vr_states.dart';
import '../../../../core/utils/colors.dart';
import '../controller/start_vr_cubit.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:alfarid/generated/locale_keys.g.dart';
import '../model/student_model.dart';

class StartVrBody extends StatelessWidget {
  const StartVrBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartVrCubit, StartVrStates>(
        builder: (context, state) {

          final cubit = StartVrCubit.get(context);

          return Scaffold(
            backgroundColor: const Color(0xFFF5F7FB),

            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [

              /// ==========================
              /// Header
              /// ==========================
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.mainColor,
                      AppColors.blackColor2,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.r),
                    bottomRight: Radius.circular(30.r),
                  ),
                ),
                child: Column(
                  children: [

                    SizedBox(height: 10.h),

                    CircleAvatar(
                      radius: 35.r,
                      backgroundColor: Colors.white.withOpacity(.15),
                      child: Icon(
                        Icons.view_in_ar,
                        color: Colors.white,
                        size: 38.sp,
                      ),
                    ),

                    SizedBox(height: 18.h),

                    Text(
                      LocaleKeys.l3.tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Text(
                      LocaleKeys.l4.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14.sp,
                      ),
                    ),

                    SizedBox(height: 18.h),
                  ],
                ),
              ),

              SizedBox(height: 25.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// المادة
                    Text(
                      "📚 المادة",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10.h),

                  DropdownButtonFormField<String>(
                    value: cubit.selectedSubject,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    hint: const Text("اختر المادة"),
                    items: cubit.subjects.map((subject) {
                      return DropdownMenuItem<String>(
                        value: subject,
                        child: Text(subject),
                      );
                    }).toList(),
                    onChanged: cubit.selectSubject,
                  ),

                    SizedBox(height: 22.h),

                    /// المختبر
                    Text(
                      "🧪 المختبر",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10.h),

                  DropdownButtonFormField<String>(
                    value: cubit.selectedLab,

                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),

                    hint: const Text("اختر المختبر"),

                    items: cubit.selectedSubject == null
                        ? []
                        : cubit.labs[cubit.selectedSubject]!
                        .map(
                          (lab) => DropdownMenuItem<String>(
                        value: lab,
                        child: Text(lab),
                      ),
                    )
                        .toList(),

                    onChanged: cubit.selectLab,
                  ),
                    SizedBox(height: 22.h),

                    StudentSelector(),

                    SizedBox(height: 22.h),
                    Text(
                      "📅 تاريخ الحصة",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10.h),

                    TextField(
                      controller: cubit.dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: "اختر التاريخ",
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: const Icon(
                          Icons.calendar_today,
                          color: AppColors.mainColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),

                      onTap: () async {

                        final value = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );

                        if(value != null){
                          cubit.selectDate(value);
                        }

                      },
                    ),
                    SizedBox(height: 20.h),

                    Text(
                      "⏰ وقت الحصة",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10.h),

                    TextField(
                      controller: cubit.timeController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: "اختر الوقت",
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: const Icon(
                          Icons.access_time,
                          color: AppColors.mainColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),

                      onTap: () async {

                        final value = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if(value != null){
                          cubit.selectTime(value);
                        }

                      },
                    ),

                    SizedBox(height: 22.h),

                    /// عنوان الحصة
                    Text(
                      "📝 عنوان الحصة",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10.h),

                    TextField(
                        controller: cubit.titleController,
                        decoration: InputDecoration(
                        hintText: "مثال: الذرات والجزيئات",

                        filled: true,
                        fillColor: Colors.white,

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    SizedBox(height: 35.h),

                    SizedBox(
                      width: double.infinity,
                      height: 55.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        onPressed: () {

                          final title = cubit.titleController.text.trim();

                          if (title.length < 4) {

                            showToast(
                              text: "عنوان الحصة يجب أن يكون 4 أحرف على الأقل",
                              state: ToastStates.warning,
                            );

                            return;
                          }

                          cubit.createVrLive();

                        },

                          child: state is StartVrLoadingState
                              ? const SizedBox(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                              : Text(
                            "🚀 بدء المختبر",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ),
                    ),

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
                  ],
                ),
              ),
            ),
          );
        },
    );
  }
}


