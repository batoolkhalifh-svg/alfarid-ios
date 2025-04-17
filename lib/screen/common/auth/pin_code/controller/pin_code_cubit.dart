import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/local/app_cached.dart';
import '../../../../../core/local/app_config.dart';
import '../../../../../core/local/cache_helper.dart';
import '../../../../../core/remote/my_dio.dart';
import '../../../../../core/utils/my_navigate.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_toast.dart';
import '../../../../student/bottom_nav_student/view/bottom_nav_screen.dart';
import '../../../../trainer/bottom_nav_teacher/view/bottom_nav_screen.dart';
import '../../new_pass/view/new_pass_screen.dart';



class PinCodeCubit extends Cubit<BaseStates> {
  PinCodeCubit() : super(BaseStatesInitState());

  static PinCodeCubit get(context) => BlocProvider.of(context);

  TextEditingController codeController = TextEditingController();

  // VerifyCodeModel? verifyModel;

  Future<void> verifyCode({required String token, required bool fromRegister,required String email})async{
    emit(BaseStatesLoadingState());
    Map<dynamic,dynamic> response = await myDio(
        endPoint: AppConfig.verifyCode,
        dioType: DioType.post,
        token: token,
        dioBody: {
          "register_type" :CacheHelper.getData(key: AppCached.role)==AppCached.student?"student":"teacher",
          "email" : email,
          "code" : codeController.text,
        }
    );
    debugPrint(response.toString());
    if(response["status"]) {
      // verifyModel = VerifyCodeModel.fromJson(response);
      showToast(text: response["message"], state: ToastStates.success);
      if(fromRegister == true ){
        CacheHelper.saveData(key: AppCached.token, value: token);
        CacheHelper.getData(key: AppCached.role)==AppCached.student?
        navigateAndFinish(widget: const BottomNavScreen()):navigateAndFinish(widget: const BottomNavTeacherScreen());}
      else{
        navigateAndReplace(widget: NewPassScreen(email:email));
      }
      emit(BaseStatesSuccessState());
    }else{
      showToast(text: response["message"], state: ToastStates.error);
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }

  Future<void> resendVerifyCode({required String email})async{
    emit(BaseStatesChangeState());
    Map<dynamic,dynamic> response = await myDio(endPoint: AppConfig.forgetPassword, dioType: DioType.post,
        dioBody: {
      "register_type" :CacheHelper.getData(key: AppCached.role)==AppCached.student?"student":"teacher",
      "email" : email,
    });
    debugPrint(response.toString());
    if(response["status"]) {
      showToast(text: response["message"], state: ToastStates.success);
      emit(BaseStatesSuccessState());
    }else{
      showToast(text: response["message"], state: ToastStates.error);
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }




}