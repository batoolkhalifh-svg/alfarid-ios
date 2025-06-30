import 'package:alfarid/core/local/app_cached.dart';
import 'package:alfarid/core/local/cache_helper.dart';
import 'package:alfarid/core/utils/colors.dart';
import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:alfarid/main.dart';
import 'package:alfarid/screen/student/home/view/model/banner_model.dart';
import 'package:alfarid/screen/student/home/view/model/offers_model.dart';
import 'package:alfarid/screen/student/home/view/model/subject_model.dart';
import 'package:alfarid/screen/student/home/view/model/teacher_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/local/app_config.dart';
import '../../../../../core/remote/my_dio.dart';
import '../../../../../core/widgets/custom_toast.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../web_view.dart';
import '../model/courses_model.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  void changeIndex(int index) {
    currentIndex = index;
    emit(HomeChangeState());
  }

  List titles = [LocaleKeys.importantCourses.tr(), LocaleKeys.distinguishedTeachers.tr()];
  ScrollController scrollController = ScrollController();

  int? currentCourse = 0;
  int? subId;

  void changeCourses({required int index, required int curSubId}) {
    currentCourse = index;
    subId = curSubId;
    data = [];
    dataTeacher = [];
    emit(HomeChangeState());
  }

  BannersModel? bannersModel;

  Future<void> fetchBanners() async {
    Map<dynamic, dynamic> response = await myDio(endPoint: AppConfig.banners, dioType: DioType.get);
    if (response["status"] == true) {
      bannersModel = BannersModel.fromJson(response);
    } else {
      emit(ErrorHomeState(msg: response["message"]));
    }
  }

  late List<OffersModel> offersModel = [];

  Future<void> fetchOffers() async {
    Map<dynamic, dynamic> response = await myDio(endPoint: AppConfig.offers, dioType: DioType.get);
    if (response["status"] == true) {
      offersModel = List.from(response['data']['items']).map((e) => OffersModel.fromJson(e)).toList();
    } else {
      emit(ErrorHomeState(msg: response["message"]));
    }
  }

  Future<void> subscribeOffer({required int id}) async {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (_) => const PopScope(
          canPop: false,
          child: CupertinoActivityIndicator(
            color: AppColors.mainColor,
          )),
    );
    Map<dynamic, dynamic> response = await myDio(endPoint: AppConfig.subscribeOffers, dioType: DioType.post, dioBody: {'offer_id': id});
    navigatorPop();
    emit(SuccessHomeState());
    if (response["status"] == true) {
      Navigator.push(
        navigatorKey.currentState!.context,
        MaterialPageRoute(
          builder: (context) => WebViewPaymentScreen(paymentUrl: response['data']['payment_url']),
        ),
      ).then((value) => fetchHomeReq());
    } else {
      showToast(text: response["message"], state: ToastStates.error);
    }
  }

  SubjectModel? subjectsModel;

  Future<void> fetchSubjects() async {
    Map<dynamic, dynamic> response = await myDio(endPoint: AppConfig.subjects, dioType: DioType.get);
    if (response["status"] == true) {
      subjectsModel = SubjectModel.fromJson(response);
    } else {
      emit(ErrorHomeState(msg: response["message"]));
    }
  }

  int currentPage = 1;
  List<Items> data = [];
  CoursesModel? coursesModel;

  Future<void> fetchCourse({bool first = true}) async {
    first == false ? emit(LoadingHomeState2()) : null;
    Map<dynamic, dynamic> response = await myDio(
        endPoint: subId == null ? AppConfig.studentsCourses : "${AppConfig.studentsCourses}?subject_id=$subId&page=$currentPage",
        dioType: DioType.get);
    if (response["status"] == true) {
      coursesModel = CoursesModel.fromJson(response);
      data.addAll(coursesModel!.data!.items!);
      first == false ? emit(SuccessHomeState()) : null;
    } else {
      emit(ErrorHomeState(msg: response["message"]));
    }
  }

  Future<void> nextCourses() async {
    emit(LoadingHomeState2());
    currentPage++;
    await fetchCourse(first: false);
  }

  ///Teachers
  int currentPageTeacher = 1;
  List<ItemsT> dataTeacher = [];
  TeacherModel? teacherModel;

  Future<void> fetchTeacher({bool first = true}) async {
    first == false ? emit(LoadingHomeState2()) : null;
    Map<dynamic, dynamic> response = await myDio(
        endPoint: subId == null ? AppConfig.teachers : "${AppConfig.teachers}?subject_id=$subId&page=$currentPageTeacher",
        dioType: DioType.get);
    if (response["status"] == true) {
      teacherModel = TeacherModel.fromJson(response);
      dataTeacher.addAll(teacherModel!.data!.items!);
      first == false ? emit(SuccessHomeState()) : null;
    } else {
      emit(ErrorHomeState(msg: response["message"]));
    }
  }

  Future<void> nextTeachers() async {
    emit(LoadingHomeState2());
    currentPageTeacher++;
    await fetchTeacher(first: false);
  }

  fetchHomeReq() async {
    emit(LoadingHomeState());
    await Future.wait([fetchBanners(), fetchSubjects(), fetchCourse(), fetchTeacher(), fetchOffers()]);
    state is ErrorHomeState ? null : emit(SuccessHomeState());
  }

  toggleSaved({required int id, required int index}) async {
    Map<dynamic, dynamic> response = await myDio(endPoint: AppConfig.saved, dioType: DioType.post, dioBody: {"course_id": id});
    if (response["status"] == true) {
      showToast(text: response["message"], state: ToastStates.success);
      data[index].isFavourite = !data[index].isFavourite!;
      emit(SuccessHomeState());
    } else {
      emit(ErrorHomeState(msg: response["message"]));
    }
  }
}
