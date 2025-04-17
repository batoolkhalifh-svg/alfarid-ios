import 'package:alfarid/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/remote/my_dio.dart';
import '../model/current_courses.dart';



class MyCoursesCubit extends Cubit<BaseStates> {
  MyCoursesCubit() : super(BaseStatesInitState());

  static MyCoursesCubit get(context) => BlocProvider.of(context);

  List myCourses=[
    LocaleKeys.currentCourses.tr(),
    LocaleKeys.completedCourses.tr(),
  ];
  bool isCurrent=true;
  void changeCourse(current){
    isCurrent=current;
    dataComplete=[];
    emit(BaseStatesChangeState());
  }

  ///Current Courses
  int currentPage=1;
  List<Items> data=[];

  CurrentCoursesModel? myCurrentCoursesModel;
  Future<void> getCurrentCourses()async{
    currentPage==1? emit(BaseStatesLoadingState()):null;
    Map<dynamic,dynamic> response =await myDio(endPoint:'${AppConfig.myCourses}${AppConfig.current}&page=$currentPage',
        dioType: DioType.get);
    debugPrint(response.toString());
    if(response["status"]==true){
      myCurrentCoursesModel = CurrentCoursesModel.fromJson(response);
      data.addAll(myCurrentCoursesModel!.data!.items!);
      emit(BaseStatesSuccessState());
    }else{
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }

  Future<void> nextCurrentCourses()async{
    emit(BaseStatesLoadingState2());
    currentPage++;
    await getCurrentCourses();
  }

///Completed Courses

  int currentPageComplete=1;
  List<Items> dataComplete=[];

  CurrentCoursesModel? myCompleteCoursesModel;
  Future<void> getCompleteCourses()async{
    currentPageComplete==1? emit(BaseStatesLoadingState3()):null;
    Map<dynamic,dynamic> response =await myDio(endPoint:'${AppConfig.myCourses}${AppConfig.completed}&page=$currentPageComplete',
        dioType: DioType.get);
    debugPrint(response.toString());
    if(response["status"]==true){
      myCompleteCoursesModel = CurrentCoursesModel.fromJson(response);
      dataComplete.addAll(myCompleteCoursesModel!.data!.items!);
      emit(BaseStatesSuccessState());
    }else{
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }

  Future<void> nextCompleteCourses()async{
    emit(BaseStatesLoadingState2());
    currentPageComplete++;
    await getCurrentCourses();
  }
}