import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import '../../../../../core/local/app_cached.dart';
import '../../../../../core/local/cache_helper.dart';
import '../../../../../core/widgets/custom_toast.dart';
import '../../../trainer/start_vr/view/vr_viewer_screen.dart';
import '../model/live_model.dart';
import 'package:url_launcher/url_launcher.dart';


// ================= States =================

abstract class StudentLiveStates {}

class StudentLiveInitial extends StudentLiveStates {}

class GetStudentLivesLoading extends StudentLiveStates {}

class GetStudentLivesSuccess extends StudentLiveStates {
  final List<LiveModel> lives;
  GetStudentLivesSuccess(this.lives);
}

class GetStudentLivesError extends StudentLiveStates {
  final String error;
  GetStudentLivesError(this.error);
}

// ================= Cubit =================

class StudentLiveCubit extends Cubit<StudentLiveStates> {
  StudentLiveCubit() : super(StudentLiveInitial());

  List<LiveModel> lives = [];
  int? currentLiveIndex;

  /// ============= جلب البثوث =============
  Future<void> fetchStudentLives() async {
    emit(GetStudentLivesLoading());

    try {
      final studentId = CacheHelper.getData(key: AppCached.id);
      if (studentId == null) {
        emit(GetStudentLivesError('لم يتم تسجيل الدخول'));
        return;
      }

      String formattedId = '"[$studentId]"';
      final response = await http.get(Uri.parse(
        'https://app.alfarid.info/api/student/get_student_lives?student_id=$formattedId',
      ));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> items = data['data']['items'];
        lives = items.map((e) => LiveModel.fromJson(e)).toList();
        lives.sort((a, b) {
          DateTime dateA = DateTime.parse("${a.date} ${a.time}");
          DateTime dateB = DateTime.parse("${b.date} ${b.time}");

          return dateB.compareTo(dateA);
        });
        if (lives.isEmpty) {
          emit(GetStudentLivesError('لا يوجد بث مباشر الآن'));
        } else {
          emit(GetStudentLivesSuccess(lives));
        }
      } else {
        emit(GetStudentLivesError('فشل في جلب البيانات'));
      }
    } catch (e) {
      emit(GetStudentLivesError(e.toString()));
    }
  }

  /// ============= نص الزر حسب الوقت =============
  String text({required int index}) {
    final live = lives[index];

    DateTime now = DateTime.now();
    DateTime liveDate = DateTime.parse(live.date);
    TimeOfDay liveTime = TimeOfDay(
      hour: int.parse(live.time.split(":")[0]),
      minute: int.parse(live.time.split(":")[1]),
    );

    DateTime liveDateTime = DateTime(
      liveDate.year,
      liveDate.month,
      liveDate.day,
      liveTime.hour,
      liveTime.minute,
    );

    if (now.isBefore(liveDateTime)) {
      return "لم يحن الوقت";
    } else if (now.isAfter(liveDateTime.add(const Duration(hours: 2)))) {
      return "انتهى البث";
    } else {
      return "دخول للبث";
    }
  }

  /// ============= عند الضغط على الزر =============
  void onClick({required BuildContext context, required int index}) async {
    currentLiveIndex = index;

    final live = lives[index];
    DateTime now = DateTime.now();
    DateTime liveDate = DateTime.parse(live.date);
    TimeOfDay liveTime = TimeOfDay(
      hour: int.parse(live.time.split(":")[0]),
      minute: int.parse(live.time.split(":")[1]),
    );

    DateTime liveDateTime = DateTime(
      liveDate.year,
      liveDate.month,
      liveDate.day,
      liveTime.hour,
      liveTime.minute,
    );

    if (now.isBefore(liveDateTime)) {
      showToast(text: "لم يحن الوقت بعد", state: ToastStates.warning);
      return;
    } else if (now.isAfter(liveDateTime.add(const Duration(hours: 2)))) {
      showToast(text: "انتهى البث", state: ToastStates.warning);
      return;
    }

    // استخدم live.url كـ roomText
    if (live.type == "vr") {

      if (live.vrModel != null &&
          live.vrModel!.isNotEmpty &&
          live.url != null &&
          live.url!.isNotEmpty) {

        final vrUrl =
            "https://alfarid.info/vr/${live.vrModel}.html"
            "?room=${Uri.encodeComponent(live.url!)}";

        debugPrint("VR URL: $vrUrl");

        /*Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VrViewerScreen(
              url: vrUrl,
            ),
          ),
        );*/
        final uri = Uri.parse(vrUrl);

        if (await canLaunchUrl(uri)) {
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
        }

      } else {

        showToast(
          text: "رابط الحصة أو المختبر غير موجود",
          state: ToastStates.error,
        );

      }

    } else {

      if (live.url != null && live.url!.isNotEmpty) {

        joinMeeting(
          roomText: live.url!,
          context: context,
        );

      } else {

        showToast(
          text: "لا يوجد رابط للبث",
          state: ToastStates.error,
        );

      }

    }
  }


  /// ============= فتح البث بواسطة Jitsi =============
  void joinMeeting({
    required String roomText,
    required BuildContext context,
  }) async {

    String roomName = roomText.trim();

    // إذا كان المخزن في قاعدة البيانات رابط كامل
    // https://meet.jit.si/Enff0iM8upEOP0FGxmkf
    // نستخرج فقط اسم الغرفة
    if (roomName.startsWith('http://') ||
        roomName.startsWith('https://')) {
      final uri = Uri.tryParse(roomName);

      if (uri != null && uri.pathSegments.isNotEmpty) {
        roomName = uri.pathSegments.last;
      }
    }

    debugPrint("=================================");
    debugPrint("Original Jitsi URL: $roomText");
    debugPrint("Final Jitsi Room: $roomName");
    debugPrint("=================================");

    if (roomName.isEmpty) {
      showToast(
        text: "رابط الحصة غير صحيح",
        state: ToastStates.error,
      );
      return;
    }

    final options = JitsiMeetConferenceOptions(
      serverURL: "https://meet.jit.si",
      room: roomName,

      configOverrides: {
        "startWithAudioMuted": false,
        "startWithVideoMuted": false,
      },

      featureFlags: {
        "unsaferoomwarning.enabled": false,
      },

      userInfo: JitsiMeetUserInfo(
        displayName:
        CacheHelper.getData(key: AppCached.name)?.toString() ?? "",
        email:
        CacheHelper.getData(key: AppCached.email)?.toString() ?? "",
        avatar:
        CacheHelper.getData(key: AppCached.image)?.toString() ?? "",
      ),
    );

    final jitsiMeet = JitsiMeet();

    await jitsiMeet.join(
      options,
      JitsiMeetEventListener(

        conferenceJoined: (message) {
          debugPrint("=================================");
          debugPrint("JOINED JITSI SUCCESSFULLY");
          debugPrint("Message: $message");
          debugPrint("Room: $roomName");
          debugPrint("=================================");
        },

        conferenceTerminated: (url, error) {
          debugPrint("=================================");
          debugPrint("JITSI TERMINATED");
          debugPrint("URL: $url");
          debugPrint("ERROR: $error");
          debugPrint("=================================");
        },

        conferenceWillJoin: (message) {
          debugPrint("JITSI WILL JOIN: $message");
        },
      ),
    );
  }
}
