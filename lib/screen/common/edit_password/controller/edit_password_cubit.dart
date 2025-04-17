import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/local/cache_helper.dart';
import '../../../../core/remote/my_dio.dart';
import '../../../../core/utils/my_navigate.dart';
import '../../../../core/widgets/custom_toast.dart';



class EditPasswordCubit extends Cubit<BaseStates> {
  EditPasswordCubit() : super(BaseStatesInitState());

  static EditPasswordCubit get(context) => BlocProvider.of(context);

  TextEditingController oldPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController confirmNewPassController = TextEditingController();

  Future<void> editPassword()async{
    emit(BaseStatesLoadingState());
    Map<dynamic,dynamic> response = await myDio(
        endPoint: CacheHelper.getData(key: AppCached.role)==AppCached.student?AppConfig.editPassStudent:AppConfig.editPasswordTeacher,
        dioType: DioType.post,
        dioBody: {
          "old_password" : oldPassController.text,
          "new_password" : newPassController.text,
          "new_password_confirmation" : confirmNewPassController.text
        }
    );
    if(response["status"]==true){
      showToast(text: response['message'], state: ToastStates.success);
      navigatorPop();
      emit(BaseStatesSuccessState());
    }else{
      showToast(text: response['message'], state: ToastStates.error);
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }

}