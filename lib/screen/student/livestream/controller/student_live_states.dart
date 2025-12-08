import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../../core/local/app_cached.dart';
import '../../../../../core/local/cache_helper.dart';
import '../model/live_model.dart';
import '../student_livestream_detail_page.dart';

abstract class StudentLiveStates {}

class StudentLiveInitial extends StudentLiveStates {}
class GetStudentLivesLoading extends StudentLiveStates {}
class GetStudentLivesSuccess extends StudentLiveStates {
  final List<LiveModel> lives;
  GetStudentLivesSuccess({required this.lives});
}
class GetStudentLivesError extends StudentLiveStates {
  final String error;
  GetStudentLivesError({required this.error});
}

class StudentLiveCubit extends Cubit<StudentLiveStates> {
  StudentLiveCubit() : super(StudentLiveInitial());

  List<LiveModel> lives = [];

  Future<void> fetchStudentLives() async {
    emit(GetStudentLivesLoading());

    try {
      final studentId = CacheHelper.getData(key: AppCached.id);
      if (studentId == null) {
        emit(GetStudentLivesError(error: 'لم يتم تسجيل الدخول'));
        return;
      }

      final response = await http.get(Uri.parse(
        'https://app.alfarid.info/api/student/get_student_lives?student_id=$studentId',
      ));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> items = data['data']['items'];
        lives = items.map((e) => LiveModel.fromJson(e)).toList();

        if (lives.isEmpty) {
          emit(GetStudentLivesError(error: 'لا يوجد بث مباشر الآن'));
        } else {
          emit(GetStudentLivesSuccess(lives: lives));
        }
      } else {
        emit(GetStudentLivesError(error: 'فشل في جلب البيانات'));
      }
    } catch (e) {
      emit(GetStudentLivesError(error: e.toString()));
    }
  }

  /// نص الزر حسب وقت البث
  String text({required int index}) {
    final live = lives[index];
    DateTime now = DateTime.now();
    DateTime liveDate = DateTime.parse(live.date);
    TimeOfDay liveTime = TimeOfDay(
      hour: int.parse(live.time.split(":")[0]),
      minute: int.parse(live.time.split(":")[1]),
    );
    TimeOfDay nowTime = TimeOfDay.fromDateTime(now);

    if (now.isBefore(DateTime(liveDate.year, liveDate.month, liveDate.day, liveTime.hour, liveTime.minute))) {
      return "لم يحن وقت البث";
    } else if (now.isAfter(DateTime(liveDate.year, liveDate.month, liveDate.day, liveTime.hour, liveTime.minute + 60))) {
      // نفترض البث مدة ساعة واحدة
      return "انتهى البث";
    } else {
      return "دخول للبث الآن";
    }
  }

  void onClick({required BuildContext context, required int index}) {
    final live = lives[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentLivestreamDetailPage(
          id: live.id,
          name: live.name,
          date: live.date,
          time: live.time,
          url: live.url,
        ),
      ),
    );
  }
}
