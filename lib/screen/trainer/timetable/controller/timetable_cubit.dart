import 'package:alfarid/core/local/app_cached.dart';
import 'package:alfarid/core/local/cache_helper.dart';
import 'package:alfarid/core/widgets/custom_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../core/remote/my_dio.dart';
import '../../../../generated/locale_keys.g.dart';
import '../model/time_table_model.dart';

class TimetableCubit extends Cubit<BaseStates> {
  TimetableCubit() : super(BaseStatesInitState());

  static TimetableCubit get(context) => BlocProvider.of(context);

  List<DayModel> weekDays = [
    DayModel(day: LocaleKeys.saturday.tr(), key: 'saturday'),
    DayModel(day: LocaleKeys.sunday.tr(), key: 'sunday'),
    DayModel(day: LocaleKeys.monday.tr(), key: 'monday'),
    DayModel(day: LocaleKeys.tuesday.tr(), key: 'tuesday'),
    DayModel(day: LocaleKeys.wednesday.tr(), key: 'wednesday'),
    DayModel(day: LocaleKeys.thursday.tr(), key: 'thursday'),
    DayModel(day: LocaleKeys.friday.tr(), key: 'friday'),
  ];
  List<DayModel> days = [];
  late bool isUpdate;

  void addDay({required DayModel v}) {
    if (days.contains(v)) {
      days.remove(v);
    } else {
      days.add(v);
    }
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

  sendTime() async {
    emit(BaseStatesLoadingState2());
    final List backDays = [];
    days.forEach((element) => backDays.add(element.key));
    Map<dynamic, dynamic> response = await myDio(
        endPoint: isUpdate ? 'teacher/availabilities/update' : 'teacher/availabilities',
        dioType: DioType.post,
        dioBody: {'days': backDays, 'time_from': startTime.text, 'time_to': endTime.text});
    if (response["status"] == true) {
      showToast(text: response['message'], state: ToastStates.success);
      emit(BaseStatesSuccessState());
    } else {
      showToast(text: response['message'], state: ToastStates.error);
      emit(BaseStatesError2State());
    }
  }

  late TimeTableModel model;

  fetchTimeTable() async {
    emit(BaseStatesLoadingState());
    Map<dynamic, dynamic> response = await myDio(endPoint: 'teacher/availabilities', dioType: DioType.get);
    if (response["status"] == true) {
      if (response['data'] is List) {
        isUpdate = false;
      } else {
        model = TimeTableModel.fromJson(response['data']);
        /// fill days from response
        final List<String> responseDays = model.days ?? [];
        if (responseDays.isNotEmpty) {
          days = weekDays.where((v) => responseDays.contains(v.key)).toList();
          startTime.text = model.timeFrom.toString();
          endTime.text = model.timeTo.toString();
        }
        isUpdate = true;
      }
      emit(BaseStatesSuccessState());
    } else {
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }
}

class DayModel {
  final String day;
  final String key;

  DayModel({required this.day, required this.key});
}
