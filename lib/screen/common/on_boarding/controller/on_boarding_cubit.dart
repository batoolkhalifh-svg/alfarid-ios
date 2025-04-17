import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/remote/my_dio.dart';
import '../model/on_boarding_model.dart';
import 'on_boarding_states.dart';


class OnBoardingCubit extends Cubit<OnBoardingStates>{
  OnBoardingCubit():super(OnBoardingInitialState());

  // List images=[
  //   "assets/images/on_bording_test.png",
  //   "assets/images/on_bording_test.png",
  //   "assets/images/on_bording_test.png",
  // ];
  ///change page num
  int index = 0;
  final pageViewController = PageController();
  void pageChanged({required int i}) {
    index = i;
    if (index == onBoardingModel!.data!.length-1) {
      changeIsLastFun(true);
    }else{
      changeIsLastFun(false);
    }
    if(index== onBoardingModel!.data!.length-2){
      changeIsSecPage(true);
    }else{
      changeIsSecPage(false);
    }
    emit(OnBoardingChangedState());
  }

  ///is last & sec page on onBoarding
  bool isLast = false;
  void changeIsLastFun(bool value){
    isLast = value;
    emit(ChangeIsLastState());
  }

  bool isSecPage= false;
  void changeIsSecPage(bool value){
    isSecPage = value;
    emit(ChangeIsSecPageState());
  }

  ///get onboard data
  OnBoardingModel? onBoardingModel;
  fetchOnBoarding()async{
    emit(OnBoardingLoadingState());
    Map<dynamic,dynamic> response = await myDio(endPoint: AppConfig.onBoarding, dioType: DioType.get);
    debugPrint(response.toString());
    if(response["status"]==true){
      onBoardingModel = OnBoardingModel.fromJson(response);
      emit(OnBoardingSuccessState());
    }else{
      emit(OnBoardingFailedState(msg: response["message"]));
    }
  }
}