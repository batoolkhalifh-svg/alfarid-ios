import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:alfarid/screen/common/auth/login/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/local/app_cached.dart';
import '../../../../../core/local/app_config.dart';
import '../../../../../core/local/cache_helper.dart';
import '../../../../../core/remote/my_dio.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_toast.dart';



class NewPassCubit extends Cubit<BaseStates> {
  NewPassCubit() : super(BaseStatesInitState());

  static NewPassCubit get(context) => BlocProvider.of(context);

  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  Future<void> resetPassword({required String email})async{
    emit(BaseStatesLoadingState());
    Map<dynamic,dynamic> response = await myDio(endPoint: AppConfig.resetPassword, dioType: DioType.post,
        dioBody: {
          "register_type" :CacheHelper.getData(key: AppCached.role)==AppCached.student?"student":"teacher",
          "email" : email,
          "new_password":passController.text,
          "new_password_confirmation":confirmPassController.text
        });
    debugPrint({
      "register_type" :CacheHelper.getData(key: AppCached.role)==AppCached.student?"student":"teacher",
      "email" : email,
      "new_password":passController.text,
      "new_password_confirmation":confirmPassController.text
    }.toString());
    debugPrint(response.toString());
    if(response["status"]) {
      showToast(text: response["message"], state: ToastStates.success);
      navigateAndFinish(widget: const LoginScreen());
      emit(BaseStatesSuccessState());
    }else{
      showToast(text: response["message"], state: ToastStates.error);
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }


}