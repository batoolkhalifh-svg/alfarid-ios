import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:alfarid/core/widgets/custom_toast.dart';
import 'package:alfarid/screen/trainer/timetable/controller/timetable_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/remote/my_dio.dart';
import '../../../../generated/locale_keys.g.dart';
import '../model/teacher_profile_model.dart';

class TeacherProfileCubit extends Cubit<BaseStates> {
  TeacherProfileCubit() : super(BaseStatesInitState());

  static TeacherProfileCubit get(context) => BlocProvider.of(context);

  /// Tabs
  int tab = 0;
  void changeTabs(int tabNum) {
    tab = tabNum;
    emit(BaseStatesChangeState());
  }

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
    emit(BaseStatesChangeState());
  }

  /// Firebase user creation
  Future<void> createUsers({required int id, required String name, required String image}) async {
    var userCollection = await FirebaseFirestore.instance.collection("users").doc("user_id_t_$id").get();
    if (!userCollection.exists) {
      await FirebaseFirestore.instance.collection('users').doc('user_id_t_$id').set({
        'id': 't_$id',
        'name': name,
        'image_url': image,
        "is_online": false,
        "lastSeen": DateTime.now().toString(),
        "fire_token": "",
      });
    }
  }

  TeacherProfileModel? teacherProfileModel;

  /// Fetch teacher profile
  Future<void> fetchTeacherProfile({required int id}) async {
    emit(BaseStatesLoadingState());

    try {
      Map<dynamic, dynamic> response = await myDio(
        endPoint: "${AppConfig.teachers}/$id",
        dioType: DioType.get,
      );
      debugPrint(response.toString());

      if (response["status"] == true) {
        teacherProfileModel = TeacherProfileModel.fromJson(response);

        availableDays.clear();

        final availabilityList = teacherProfileModel?.data?.availability;
        if (availabilityList != null && availabilityList.isNotEmpty) {
          availableDays.clear();

          for (var availability in availabilityList) {
            if (availability.days != null) {
              for (var dayItem in availability.days!) {
                final slug = dayItem.slug ?? '';
                final dayName = dayItem.day ?? '';

                if (slug.isNotEmpty) {
                  availableDays.add(DayModel(day: dayName, key: slug));
                }
              }
            }
          }
        }


        emit(BaseStatesSuccessState());
      } else {
        emit(BaseStatesErrorState(msg: response["message"] ?? "حدث خطأ"));
      }
    } catch (e) {
      debugPrint("fetchTeacherProfile error: $e");
      emit(BaseStatesErrorState(msg: "حدث خطأ أثناء جلب بيانات المعلم"));
    }
  }


  /// Direct reservation
  Future<void> directReserve({required int id}) async {
    emit(BaseStatesLoadingState2());

    // يجب إرسال list فيها Map لكل يوم
    List<Map<String, dynamic>> slotsList = selectedDays.map((day) {
      return {
        "day": day.key,
        "time_from": startTime.text,
        "time_to": endTime.text,
      };
    }).toList();

    Map<dynamic, dynamic> response = await myDio(
      endPoint: "${AppConfig.directReserve}$id",
      dioType: DioType.post,
      dioBody: {
        "slots": slotsList,   // ← هنا الحل الحقيقي
      },
    );

    debugPrint(response.toString());

    if (response["status"] == true) {
      navigatorPop();
      showToast(text: response["message"], state: ToastStates.success);
      emit(BaseStatesSuccessState());
    } else {
      showToast(text: response["message"], state: ToastStates.error);
      emit(BaseStatesErrorState(msg: response["message"] ?? "Unknown error"));
    }
  }




  /// Toggle saved courses
  Future<void> toggleSaved({required int id, required int index}) async {
    Map<dynamic, dynamic> response = await myDio(
      endPoint: AppConfig.saved,
      dioType: DioType.post,
      dioBody: {"course_id": id},
    );
    debugPrint(response.toString());

    if (response["status"] == true) {
      showToast(text: response["message"], state: ToastStates.success);
      final courses = teacherProfileModel?.data?.courses;
      if (courses != null && courses.length > index) {
        courses[index].isFavorite = !(courses[index].isFavorite ?? false);
      }
      emit(BaseStatesSuccessState());
    } else {
      emit(BaseStatesErrorState(msg: response["message"] ?? "Unknown error"));
    }
  }

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

  /// Weekdays reference
  final List<DayModel> weekDays = [
    DayModel(day: LocaleKeys.saturday.tr(), key: 'saturday'),
    DayModel(day: LocaleKeys.sunday.tr(), key: 'sunday'),
    DayModel(day: LocaleKeys.monday.tr(), key: 'monday'),
    DayModel(day: LocaleKeys.tuesday.tr(), key: 'tuesday'),
    DayModel(day: LocaleKeys.wednesday.tr(), key: 'wednesday'),
    DayModel(day: LocaleKeys.thursday.tr(), key: 'thursday'),
    DayModel(day: LocaleKeys.friday.tr(), key: 'friday'),
  ];
}