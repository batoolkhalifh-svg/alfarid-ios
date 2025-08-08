import 'package:alfarid/screen/common/auth/new_pass/view/new_pass_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/local/app_cached.dart';
import '../../../../../core/local/app_config.dart';
import '../../../../../core/local/cache_helper.dart';
import '../../../../../core/remote/my_dio.dart';
import '../../../../../core/utils/my_navigate.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_toast.dart';



class ForgetPassCubit extends Cubit<BaseStates> {
  ForgetPassCubit() : super(BaseStatesInitState());

  static ForgetPassCubit get(context) => BlocProvider.of(context);

  TextEditingController emailController = TextEditingController();

  Future<void> forgetPass()async{
    emit(BaseStatesLoadingState());
    Map<dynamic,dynamic> response = await myDio(endPoint: AppConfig.forgetPassword, dioType: DioType.post,
        dioBody: {
          "register_type" :CacheHelper.getData(key: AppCached.role)==AppCached.student?"student":"teacher",
          "email" :kDebugMode?'kamalabozyed0@gmail.com':emailController.text,
        });
    debugPrint(response.toString());
    if(response["status"]) {
      showToast(text: response["message"], state: ToastStates.success);
       // navigateTo(widget:  PinCodeScreen(fromRegister: false, token: '', email:  emailController.text));
       navigateTo(widget:  NewPassScreen(email:  emailController.text));
      emit(BaseStatesSuccessState());
    }else{
      showToast(text: response["message"], state: ToastStates.error);
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }

}