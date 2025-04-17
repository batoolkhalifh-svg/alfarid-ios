import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/remote/my_dio.dart';
import '../model/home_student_model.dart';
import 'home_teacher_states.dart';





class HomeTeacherCubit extends Cubit<HomeTeacherStates> {
  HomeTeacherCubit() : super(HomeInitialState());

  static HomeTeacherCubit get(context) => BlocProvider.of(context);

  StudentsHomeModel? studentHomeModel;
  fetchStudentHome()async{
    emit(LoadingHomeState());
    Map<dynamic,dynamic> response = await myDio(endPoint: AppConfig.studentHomeT, dioType: DioType.get);
    debugPrint(response.toString());
    if(response["status"]==true){
      studentHomeModel = StudentsHomeModel.fromJson(response);
      emit(SuccessHomeState());
    }else{
      emit(ErrorHomeState(msg: response["message"]));
    }
  }

}