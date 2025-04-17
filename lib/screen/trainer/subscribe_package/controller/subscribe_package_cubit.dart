import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/remote/my_dio.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../bottom_nav_teacher/view/bottom_nav_screen.dart';
import '../model/package_model.dart';



class SubscribePackageCubit extends Cubit<BaseStates> {
  SubscribePackageCubit() : super(BaseStatesInitState());

  static SubscribePackageCubit get(context) => BlocProvider.of(context);

  PackagesModel? packageModel;
  Future<void> fetchPackages()async{
    emit(BaseStatesLoadingState2());
    Map<dynamic,dynamic> response =await myDio(endPoint: AppConfig.packages, dioType: DioType.get);
    debugPrint(response.toString());
    if(response["status"]==true){
      packageModel = PackagesModel.fromJson(response);
      emit(BaseStatesSuccessState());
    }else{
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }

  int? choosePackage;

  void changePackage({required int index}){
    choosePackage=index;
    emit(BaseStatesChangeState());
  }

  Future<void> subscribe()async{
    emit(BaseStatesLoadingState());
    Map<dynamic,dynamic> response = await myDio(endPoint: AppConfig.teacherSubscribe, dioType: DioType.post,
        dioBody: {
          "plan_id" :choosePackage,
        });
    debugPrint(response.toString());
    if(response["status"]) {
      showToast(text: response["message"], state: ToastStates.success);
      navigateAndFinish(widget: const BottomNavTeacherScreen());
      emit(BaseStatesSuccessState());
    }else{
      showToast(text: response["message"], state: ToastStates.error);
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }
}