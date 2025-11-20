import 'package:alfarid/core/local/app_cached.dart';
import 'package:alfarid/core/local/cache_helper.dart';
import 'package:alfarid/core/utils/colors.dart';
import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:alfarid/main.dart';
import 'package:alfarid/screen/student/home/view/model/banner_model.dart';
import 'package:alfarid/screen/student/home/view/model/offers_model.dart';
import 'package:alfarid/screen/student/home/view/model/subject_model.dart';
import 'package:alfarid/screen/student/home/view/model/teacher_model.dart';
import 'package:alfarid/screen/student/search/model/search_model.dart';
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

  List titles = [
    LocaleKeys.importantCourses.tr(),
    LocaleKeys.distinguishedTeachers.tr()
  ];
  ScrollController scrollController = ScrollController();

  int? currentCourse = 0;
  int? subId;

  void changeCourses({required int index, required int curSubId}) {
    currentCourse = index;
    subId = curSubId;
    data = [];
    dataTeacher = [];
    currentPage = 1;
    currentPageTeacher = 1;
    emit(HomeChangeState());
  }

  BannersModel? bannersModel;
  Future<void> fetchBanners() async {
    print("📡 Fetching banners...");
    Map<dynamic, dynamic> response =
    await myDio(endPoint: AppConfig.banners, dioType: DioType.get);
    print("✅ Banners response: $response");
    if (response["status"] == true) {
      bannersModel = BannersModel.fromJson(response);
    } else {
      print("❌ Banners error: ${response["message"]}");
      emit(ErrorHomeState(msg: response["message"]));
    }
  }

  late List<OffersModel> offersModel = [];
  Future<void> fetchOffers() async {
    print("📡 Fetching offers...");
    Map<dynamic, dynamic> response =
    await myDio(endPoint: AppConfig.offers, dioType: DioType.get);
    print("✅ Offers response: $response");
    if (response["status"] == true) {
      offersModel = List.from(response['data']['items'])
          .map((e) => OffersModel.fromJson(e))
          .toList();
    } else {
      print("❌ Offers error: ${response["message"]}");
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

    print("📡 Subscribing to offer ID: $id");
    Map<dynamic, dynamic> response = await myDio(
        endPoint: AppConfig.subscribeOffers,
        dioType: DioType.post,
        dioBody: {'offer_id': id});
    print("✅ Subscribe Offer response: $response");

    navigatorPop();
    emit(SuccessHomeState());

    if (response["status"] == true) {
      Navigator.push(
        navigatorKey.currentState!.context,
        MaterialPageRoute(
          builder: (context) =>
              WebViewPaymentScreen(paymentUrl: response['data']['payment_url']),
        ),
      ).then((value) => fetchHomeReq());
    } else {
      showToast(text: response["message"], state: ToastStates.error);
    }
  }

  SubjectModel? subjectsModel;
  Future<void> fetchSubjects() async {
    print("📡 Fetching subjects...");
    Map<dynamic, dynamic> response =
    await myDio(endPoint: AppConfig.subjects, dioType: DioType.get);
    print("✅ Subjects response: $response");
    if (response["status"] == true) {
      subjectsModel = SubjectModel.fromJson(response);
    } else {
      print("❌ Subjects error: ${response["message"]}");
      emit(ErrorHomeState(msg: response["message"]));
    }
  }

  // ==================== Courses ====================
  int currentPage = 1;
  List<Items> data = [];
  CoursesModel? coursesModel;

  Future<void> fetchCourse({bool first = true}) async {
    if (!first) emit(LoadingHomeState2());
    print("📡 Fetching courses... subId=$subId page=$currentPage");

    Map<dynamic, dynamic> response = await myDio(
      endPoint: subId == null
          ? AppConfig.studentsCourses
          : "${AppConfig.studentsCourses}?subject_id=$subId&page=$currentPage",
      dioType: DioType.get,
    );

    print("✅ Courses response: $response");

    try {
      if (response["status"] == true && response["data"] != null) {
        coursesModel = CoursesModel.fromJson(response);
        if (currentPage == 1) {
          data = coursesModel?.data?.items ?? [];
        } else {
          data.addAll(coursesModel?.data?.items ?? []);
        }
      } else {
        print("❌ Courses API returned null or error, creating empty model");
        coursesModel = CoursesModel(data: CoursesData(items: []));
        if (currentPage == 1) data = [];
      }
    } catch (e) {
      print("❌ Error parsing courses: $e");
      coursesModel = CoursesModel(data: CoursesData(items: []));
      if (currentPage == 1) data = [];
    }

    if (!first) emit(SuccessHomeState());
  }

  Future<void> nextCourses() async {
    currentPage++;
    await fetchCourse(first: false);
  }

  // ==================== Teachers ====================
  int currentPageTeacher = 1;
  List<ItemsT> dataTeacher = [];
  TeacherModel? teacherModel;

  Future<void> fetchTeacher({bool first = true}) async {
    if (!first) emit(LoadingHomeState2());
    print("📡 Fetching teachers... subId=$subId page=$currentPageTeacher");

    Map<dynamic, dynamic> response = await myDio(
      endPoint: subId == null
          ? AppConfig.teachers
          : "${AppConfig.teachers}?subject_id=$subId&page=$currentPageTeacher",
      dioType: DioType.get,
    );

    print("✅ Teachers response: $response");

    try {
      if (response["status"] == true && response["data"] != null) {
        teacherModel = TeacherModel.fromJson(response);
        if (currentPageTeacher == 1) {
          dataTeacher = teacherModel?.data?.items ?? [];
        } else {
          dataTeacher.addAll(teacherModel?.data?.items ?? []);
        }
      } else {
        print("❌ Teachers API returned null or error, skipping...");
        if (currentPageTeacher == 1) dataTeacher = [];
      }
    } catch (e) {
      print("❌ Error parsing teachers: $e");
      if (currentPageTeacher == 1) dataTeacher = [];
    }

    if (!first) emit(SuccessHomeState());
  }

  Future<void> nextTeachers() async {
    currentPageTeacher++;
    await fetchTeacher(first: false);
  }

  // ==================== Home Request ====================
  fetchHomeReq() async {
    print("🏠 Starting fetchHomeReq...");
    emit(LoadingHomeState());
    await Future.wait([
      fetchBanners(),
      fetchSubjects(),
      fetchCourse(),
      fetchTeacher(),
      if (CacheHelper.getData(key: AppCached.token) != null) fetchOffers(),
    ]);
    print("🏁 Finished fetchHomeReq.");

    state is ErrorHomeState
        ? print("❌ One of the requests failed.")
        : print("✅ Home data loaded successfully!");

    state is ErrorHomeState ? null : emit(SuccessHomeState());
  }

  // ==================== Toggle Saved ====================
  toggleSaved({required int id, required int index}) async {
    print("🔖 Toggling saved course ID=$id");
    Map<dynamic, dynamic> response = await myDio(
        endPoint: AppConfig.saved, dioType: DioType.post, dioBody: {"course_id": id});
    print("✅ Toggle saved response: $response");

    if (response["status"] == true) {
      showToast(text: response["message"], state: ToastStates.success);
      data[index].isFavourite = !(data[index].isFavourite ?? false);
      emit(SuccessHomeState());
    } else {
      print("❌ Toggle saved error: ${response["message"]}");
      emit(ErrorHomeState(msg: response["message"]));
    }
  }
}
