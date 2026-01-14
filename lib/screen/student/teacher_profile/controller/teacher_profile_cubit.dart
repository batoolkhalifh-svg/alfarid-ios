import 'dart:io';

import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:alfarid/core/widgets/custom_toast.dart';
import 'package:alfarid/screen/trainer/timetable/controller/timetable_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/remote/my_dio.dart';
import '../../../../generated/locale_keys.g.dart';
import '../model/teacher_profile_model.dart';
import 'dart:convert';

class TeacherProfileCubit extends Cubit<BaseStates> {
  TeacherProfileCubit() : super(BaseStatesInitState());

  static TeacherProfileCubit get(context) => BlocProvider.of(context);

  int tab = 0;
  void changeTabs(int tabNum) {
    tab = tabNum;
    emit(BaseStatesChangeState());
  }

  /// نوع المدرسة القادم من BookingSheet
  String? classroomType;

  /// Time formatting
  String formatTimeOfDay12h(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a', 'en').format(dt);
  }

  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();

  void getTime({required TimeOfDay val, required TextEditingController ctrl}) {
    ctrl.text = formatTimeOfDay12h(val);
    calculatePrice();
    emit(BaseStatesChangeState());
  }

  TeacherProfileModel? teacherProfileModel;

  /// Days selection
  List<DayModel> availableDays = [];
  List<DayModel> selectedDays = [];

  void addDay({required DayModel v}) {
    if (selectedDays.contains(v)) {
      selectedDays.remove(v);
    } else {
      selectedDays.add(v);
    }
    emit(BaseStatesChangeState());
  }

  /// API PRICE
  double? basePrice;     // سعر الساعة حسب النوع
  double? finalPrice;    // سعر الحصة حسب المدة

  Future<void> getPriceFromAPI({required String schoolType}) async {
    emit(BaseStatesLoadingState());

    try {
      Map response = await myDio(
        endPoint: "${AppConfig.coursePrice}?school_type=$schoolType",
        dioType: DioType.get,
      );

      if (response["status"] == true) {
        basePrice = double.tryParse(response["data"]["price"].toString());

        print("نوع المدرسة: $schoolType");
        print("السعر اللي راح يروح للفاتورة: $basePrice");
      }

      emit(BaseStatesSuccessState());
    } catch (e) {
      emit(BaseStatesErrorState(msg: "خطأ أثناء جلب السعر"));
    }
  }

  /// حساب السعر حسب الدقائق
  void calculatePrice() {
    if (startTime.text.isEmpty || endTime.text.isEmpty || basePrice == null) {
      finalPrice = null;
      return;
    }

    try {
      DateFormat format = DateFormat("hh:mm a");
      DateTime start = format.parse(startTime.text);
      DateTime end = format.parse(endTime.text);

      int minutes = end.difference(start).inMinutes;

      if (minutes <= 0) {
        finalPrice = null;
        emit(BaseStatesChangeState());
        return;
      }

      finalPrice = (minutes / 60) * basePrice!;
      emit(BaseStatesChangeState());
    } catch (e) {
      finalPrice = null;
    }
  }

  /// Fetch teacher profile
  Future<void> fetchTeacherProfile({required int id}) async {
    emit(BaseStatesLoadingState());

    try {
      Map response = await myDio(
        endPoint: "${AppConfig.teachers}/$id",
        dioType: DioType.get,
      );

      if (response["status"] == true) {
        teacherProfileModel = TeacherProfileModel.fromJson(response);
        availableDays.clear();

        final availabilityList = teacherProfileModel?.data?.availability;
        if (availabilityList != null) {
          for (var availability in availabilityList) {
            if (availability.days != null) {
              for (var dayItem in availability.days!) {
                if (dayItem.slug != null) {
                  availableDays.add(DayModel(day: dayItem.day!, key: dayItem.slug!));
                }
              }
            }
          }
        }

        emit(BaseStatesSuccessState());
      } else {
        emit(BaseStatesErrorState(msg: response["message"]));
      }
    } catch (e) {
      emit(BaseStatesErrorState(msg: "خطأ في جلب بيانات المعلم"));
    }
  }

  /// Direct reservation
  Future<void> directReserve({required int id, required Map<String, List<File>> filesPerDay}) async {
    emit(BaseStatesLoadingState2());

    // التحقق من الحقول الأساسية
    if (selectedDays.isEmpty || startTime.text.isEmpty || endTime.text.isEmpty || classroomType == null) {
      showToast(text: "يرجى التحقق من جميع الحقول", state: ToastStates.error);
      emit(BaseStatesErrorState(msg: "الحقول ناقصة"));
      return;
    }

    // تجهيز الـ slots
    List<Map<String, dynamic>> slots = selectedDays.map((day) {
      return {
        "day": day.key.toLowerCase().trim(),
        "time_from": startTime.text.trim(),
        "time_to": endTime.text.trim(),
        "class_type": classroomType!.trim(),
      };
    }).toList();

    // إنشاء FormData فارغ
    FormData formData = FormData();

    // إضافة كل slot مع الملفات بشكل متوافق مع Laravel
    for (int i = 0; i < slots.length; i++) {
      var slot = slots[i];

      // إضافة الحقول العادية
      formData.fields.add(MapEntry('slots[$i][day]', slot['day']));
      formData.fields.add(MapEntry('slots[$i][time_from]', slot['time_from']));
      formData.fields.add(MapEntry('slots[$i][time_to]', slot['time_to']));
      formData.fields.add(MapEntry('slots[$i][class_type]', slot['class_type']));

      // إضافة الملفات لكل slot إذا موجودة
      var files = filesPerDay[slot['day']] ?? [];
      for (int j = 0; j < files.length; j++) {
        formData.files.add(
          MapEntry(
            'slots[$i][uploaded_files][]',
            await MultipartFile.fromFile(files[j].path, filename: files[j].path.split('/').last),
          ),
        );
      }
    }

    try {
      Map response = await myDio(
        endPoint: "${AppConfig.directReserve}$id",
        dioType: DioType.post,
        dioBody: formData,
      );

      if (response["status"] == true) {
        navigatorPop();
        showToast(text: response["message"], state: ToastStates.success);
        emit(BaseStatesSuccessState());
      } else {
        showToast(text: response["message"], state: ToastStates.error);
        emit(BaseStatesErrorState(msg: response["message"]));
      }
    } catch (e) {
      showToast(text: "حدث خطأ أثناء إرسال الحجز", state: ToastStates.error);
      emit(BaseStatesErrorState(msg: e.toString()));
    }
  }









}

class DayModel {
  final String day;
  final String key;

  DayModel({required this.day, required this.key});
}


