import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/remote/my_dio.dart';
import '../../../../core/utils/my_navigate.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../exam/view/exam_screen.dart';
import '../model/my_lieutenant_model.dart';



class LieutenantCubit extends Cubit<BaseStates> {
  LieutenantCubit() : super(BaseStatesInitState());

  static LieutenantCubit get(context) => BlocProvider.of(context);

  bool isExplore=true;
  void changeExplore(current){
    isExplore=current;
    emit(BaseStatesChangeState());
  }

  AllLieutenantModel? allLieutenantModel;
  Future<void> getAllLieutenant()async{
    Map<dynamic,dynamic> response =await myDio(endPoint: AppConfig.allLieutenant, dioType: DioType.get);
    debugPrint(response.toString());
    if(response["status"]==true){
      allLieutenantModel = AllLieutenantModel.fromJson(response);
    }else{
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }

  AllLieutenantModel? myAllLieutenantModel;
  Future<void> getMyLieutenant()async{
    Map<dynamic,dynamic> response =await myDio(endPoint: AppConfig.myAllLieutenant, dioType: DioType.get);
    debugPrint(response.toString());
    if(response["status"]==true){
      myAllLieutenantModel = AllLieutenantModel.fromJson(response);
    }else{
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }
  fetchLieutenants()async{
    emit(BaseStatesLoadingState());
    await Future.wait([getAllLieutenant(),getMyLieutenant()]);
    state is BaseStatesErrorState ? null : emit(BaseStatesSuccessState());
  }

  ///AddToCart
  Future<void> addToCart({required int bookId})async{
    emit(BaseStatesChangeState());
    final formData= ({
      "type":"notes",
      "item_id" : bookId,
    });
    debugPrint(formData.toString());
    Map<dynamic, dynamic> response = await myDio(
        dioBody: formData,
        endPoint: AppConfig.addToCart,
        dioType: DioType.post);
    debugPrint(response.toString());
    if(response['status'] ==true){
      showToast(text: response['message'], state: ToastStates.success);
      emit(BaseStatesSuccessState());
    }else{
      showToast(text: response['message'], state: ToastStates.error);
      emit(BaseStatesError2State());
    }}
  ///Get Exam
  Future<void> getLieutenantExam({required int id})async{
    Map<dynamic,dynamic> response =await myDio(endPoint: '${AppConfig.lieutenantExam}$id', dioType: DioType.get);
    debugPrint(response.toString());
    if(response["status"]==true){
      navigateTo(widget: ExamScreen(id: id, isLieutenant: true));
    }else{
      showToast(text:  response["message"], state: ToastStates.error);
      emit(BaseStatesError2State());
    }
  }

}