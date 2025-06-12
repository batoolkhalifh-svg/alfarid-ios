import 'package:alfarid/core/local/cache_helper.dart';
import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:alfarid/screen/student/payment/view/payment_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pod_player/pod_player.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/remote/my_dio.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../main.dart';
import '../../bottom_nav_student/view/bottom_nav_screen.dart';
import '../../web_view.dart';
import '../model/course_details_model.dart';

part 'course_details_states.dart';

class CourseDetailsCubit extends Cubit<CourseDetailsStates> {
  CourseDetailsCubit() : super(CourseDetailsInitialState());

  static CourseDetailsCubit get(context) => BlocProvider.of(context);

  ///tabs
  int tab = 0;

  void changeTabs(tabNum) {
    tab = tabNum;
    emit(ChangeTabsState());
  }

  CourseDetailsModel? courseDetailsModel;

  Future<void> getCourseDetails({required int id}) async {
    emit(CourseDetailsLoadingState());
    print('fghjm,.');
    Map<dynamic, dynamic> response = await myDio(endPoint: '${AppConfig.courseDetails}$id', dioType: DioType.get);
    debugPrint(response.toString());
    if (response["status"] == true) {
      courseDetailsModel = CourseDetailsModel.fromJson(response);
      emit(CourseDetailsSuccessState());
    } else {
      emit(CourseDetailsErrorState(msg: response["message"]));
    }
  }

  int currentSection = 0;
  int currentLesson = 0;

  void changeVideo({indexSection, indexLesson, id}) {
    currentLesson == indexLesson ? null : emit(CourseDetailsSChangeVideoState());
    currentLesson = indexLesson;
    currentSection = indexSection;
    if (currentSection == courseDetailsModel!.data!.sections!.length - 1 &&
        currentLesson == courseDetailsModel!.data!.sections![indexSection].lessons!.length - 1) {
      completeLastLesson(id: id);
    }

    Future.delayed(const Duration(seconds: 2)).then((value) => emit(DoneChangeState()));
  }

  Future<void> subScribe({required int id}) async {
    emit(SubscribeLoadingState());
    Map<dynamic, dynamic> response = await myDio(endPoint: AppConfig.subScribeCourse, dioType: DioType.post, dioBody: {
      "course_id": id,
    });
    debugPrint(response.toString());
    if (response["status"]) {
      if (CacheHelper.getData(key: AppCached.isApple) == true) {
        navigateAndFinish(widget: const BottomNavScreen());
      } else {
        Navigator.push(
          navigatorKey.currentState!.context,
          MaterialPageRoute(
            builder: (context) => WebViewPaymentScreen(paymentUrl: response['data']['payment_url']),
          ),
        ).then((value) => getCourseDetails(id: courseDetailsModel!.data!.id!));
      }
      emit(CourseDetailsSuccessState());
    } else {
      showToast(text: response["message"], state: ToastStates.error);
      emit(CourseDetailsErrorState(msg: response["message"]));
    }
  }

  Future<void> completeLastLesson({required int id}) async {
    emit(ChangeTabsState());
    Map<dynamic, dynamic> response = await myDio(endPoint: "${AppConfig.completeLastLesson}$id", dioType: DioType.get);
    debugPrint(response.toString());
    if (response["status"]) {
      showToast(text: response["message"], state: ToastStates.success);
      emit(CourseDetailsSuccessState());
    } else {
      showToast(text: response["message"], state: ToastStates.error);
      emit(CourseDetailsErrorState(msg: response["message"]));
    }
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

  Future<void> finishCourse({required int lessonId}) async {
    emit(ChangeTabsState());
    Map<dynamic, dynamic> response = await myDio(endPoint: AppConfig.finishLesson, dioType: DioType.post, dioBody: {
      "lesson_id": lessonId,
    });
    if (response["status"]) {
      // showToast(text: response["message"], state: ToastStates.success);
      emit(CourseDetailsSuccessState());
    } else {
      // showToast(text: response["message"], state: ToastStates.error);
      emit(CourseDetailsErrorState(msg: response["message"]));
    }
  }
}
