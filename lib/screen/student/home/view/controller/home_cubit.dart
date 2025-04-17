import 'package:alfarid/screen/student/home/view/model/banner_model.dart';
import 'package:alfarid/screen/student/home/view/model/subject_model.dart';
import 'package:alfarid/screen/student/home/view/model/teacher_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/local/app_config.dart';
import '../../../../../core/remote/my_dio.dart';
import '../../../../../core/widgets/custom_toast.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../model/courses_model.dart';
import 'home_states.dart';


class HomeCubit extends Cubit<HomeStates>{
  HomeCubit():super(HomeInitialState());
  static HomeCubit get(context) => BlocProvider.of(context);

  int currentIndex=0;
  void changeIndex(int index){
    currentIndex = index;
    emit(HomeChangeState());
  }

  List titles = [LocaleKeys.importantCourses.tr() , LocaleKeys.distinguishedTeachers.tr()];
  ScrollController scrollController=ScrollController();


  int? currentCourse=0;
  int? subId;
  void changeCourses({required int index, required int curSubId}){
    currentCourse=index;
    subId=curSubId;
    data=[];
    dataTeacher=[];
    emit(HomeChangeState());
  }

  BannersModel? bannersModel;
  Future<void> fetchBanners()async{
    Map<dynamic,dynamic> response =await myDio(endPoint: AppConfig.banners, dioType: DioType.get);
    debugPrint(response.toString());
    if(response["status"]==true){
      bannersModel = BannersModel.fromJson(response);
    }else{
      emit(ErrorHomeState(msg: response["message"]));
    }
  }

  SubjectModel? subjectsModel;
  Future<void> fetchSubjects()async{
    Map<dynamic,dynamic> response =await myDio(endPoint: AppConfig.subjects, dioType: DioType.get);
    debugPrint(response.toString());
    if(response["status"]==true){
      subjectsModel = SubjectModel.fromJson(response);
    }else{
      emit(ErrorHomeState(msg: response["message"]));
    }
  }

  int currentPage=1;
  List<Items> data=[];
  CoursesModel? coursesModel;
  Future<void> fetchCourse({bool first=true})async{
    first==false? emit(LoadingHomeState2()):null;
    Map<dynamic,dynamic> response =await myDio(endPoint:
    subId==null?AppConfig.studentsCourses: "${AppConfig.studentsCourses}?subject_id=$subId&page=$currentPage", dioType: DioType.get);
    debugPrint(response.toString());
    if(response["status"]==true){
      coursesModel = CoursesModel.fromJson(response);
      data.addAll(coursesModel!.data!.items!);
      print(data.toString());
      print(subId);
      print(currentPage);
      first==false? emit(SuccessHomeState()):null;
    }else{
      emit(ErrorHomeState(msg: response["message"]));
    }
  }

  Future<void> nextCourses()async{
    emit(LoadingHomeState2());
    currentPage++;
    await fetchCourse(first: false);
  }

///Teachers
  int currentPageTeacher=1;
  List<ItemsT> dataTeacher=[];
  TeacherModel? teacherModel;
  Future<void> fetchTeacher({bool first=true})async{
    first==false? emit(LoadingHomeState2()):null;
    Map<dynamic,dynamic> response =await myDio(endPoint:
    subId==null?AppConfig.teachers: "${AppConfig.teachers}?subject_id=$subId&page=$currentPageTeacher", dioType: DioType.get);
    debugPrint(response.toString());
    if(response["status"]==true){
      teacherModel = TeacherModel.fromJson(response);
      dataTeacher.addAll(teacherModel!.data!.items!);
      print(dataTeacher.toString());
      print(subId);
      print(currentPageTeacher);
      first==false? emit(SuccessHomeState()):null;
    }else{
      emit(ErrorHomeState(msg: response["message"]));
    }
  }

  Future<void> nextTeachers()async{
    emit(LoadingHomeState2());
    currentPageTeacher++;
    await fetchTeacher(first: false);
  }

  fetchHomeReq()async{
    emit(LoadingHomeState());
    await Future.wait([fetchBanners(),fetchSubjects(),fetchCourse(),fetchTeacher()]);
    state is ErrorHomeState ? null : emit(SuccessHomeState());
  }

  toggleSaved({required int id, required int index})async{
    Map<dynamic,dynamic> response = await myDio(endPoint: AppConfig.saved, dioType: DioType.post,
        dioBody: {
          "course_id":id
        });
    debugPrint(response.toString());
    if(response["status"]==true){
      showToast(text: response["message"], state: ToastStates.success);
      data[index].isFavourite=!data[index].isFavourite!;
      emit(SuccessHomeState());
    }else{
      emit(ErrorHomeState(msg: response["message"]));
    }
  }
}