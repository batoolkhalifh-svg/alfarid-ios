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

  ///tabs
  int tab = 0;

  void changeTabs(tabNum) {
    tab = tabNum;
    emit(BaseStatesChangeState());
  }

  ///time
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

  Future<void> createUsers({required int id, required String name, required String image}) async {
    var userCollection = await FirebaseFirestore.instance.collection("users").doc("user_id_t_$id").get();
    if (userCollection.exists) {
    } else {
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

  Future<void> fetchTeacherProfile({required int id}) async {
    emit(BaseStatesLoadingState());
    Map<dynamic, dynamic> response = await myDio(endPoint: "${AppConfig.teachers}/$id", dioType: DioType.get);
    debugPrint(response.toString());
    if (response["status"] == true) {
      teacherProfileModel = TeacherProfileModel.fromJson(response);
      if(teacherProfileModel!.data!.availability!.isNotEmpty) {
        final List<String> respDays = teacherProfileModel?.data!.availability?.first.days ?? [];
        if (respDays.isNotEmpty) {
          availableDays = weekDays.where((element) => respDays.contains(element.key)).toList();
        }
      }
      emit(BaseStatesSuccessState());
    } else {
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }

  Future<void> directReserve({required int id}) async {
    emit(BaseStatesLoadingState2());
    final List backDays = [];
    for (var element in selectedDays) {
      backDays.add(element.key);
    }
    Map<dynamic, dynamic> response = await myDio(
        endPoint: "${AppConfig.directReserve}$id",
        dioType: DioType.post,
        dioBody: {'days': backDays, 'time_from': startTime.text, 'time_to': endTime.text});
    debugPrint(response.toString());
    if (response["status"] == true) {
      navigatorPop();
      showToast(text: response["message"], state: ToastStates.success);
      emit(BaseStatesSuccessState());
    } else {
      showToast(text: response["message"], state: ToastStates.error);
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }

  toggleSaved({required int id, required int index}) async {
    Map<dynamic, dynamic> response = await myDio(endPoint: AppConfig.saved, dioType: DioType.post, dioBody: {"course_id": id});
    debugPrint(response.toString());
    if (response["status"] == true) {
      showToast(text: response["message"], state: ToastStates.success);
      teacherProfileModel!.data!.courses![index].isFavorite = !teacherProfileModel!.data!.courses![index].isFavorite!;
      emit(BaseStatesSuccessState());
    } else {
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }

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

  List<DayModel> weekDays = [
    DayModel(day: LocaleKeys.saturday.tr(), key: 'saturday'),
    DayModel(day: LocaleKeys.sunday.tr(), key: 'sunday'),
    DayModel(day: LocaleKeys.monday.tr(), key: 'monday'),
    DayModel(day: LocaleKeys.tuesday.tr(), key: 'tuesday'),
    DayModel(day: LocaleKeys.wednesday.tr(), key: 'wednesday'),
    DayModel(day: LocaleKeys.thursday.tr(), key: 'thursday'),
    DayModel(day: LocaleKeys.friday.tr(), key: 'friday'),
  ];
}
