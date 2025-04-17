import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/remote/my_dio.dart';
import '../model/my_point_model.dart';


class MyPointsCubit extends Cubit<BaseStates> {
  MyPointsCubit() : super(BaseStatesInitState());

  static MyPointsCubit get(context) => BlocProvider.of(context);


  bool isWeek=true;
  void changeCPoints(current){
    isWeek=current;
    emit(BaseStatesChangeState());
  }


  MyPointModel? myPointModel;
  Future<void> getMyPoints()async{
    emit(BaseStatesLoadingState());
    Map<dynamic,dynamic> response =await myDio(endPoint: AppConfig.myPoints, dioType: DioType.get);
    debugPrint(response.toString());
    if(response["status"]==true){
      myPointModel = MyPointModel.fromJson(response);
      emit(BaseStatesSuccessState());
    }else{
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }



}