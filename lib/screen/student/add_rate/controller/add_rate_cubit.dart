import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/remote/my_dio.dart';
import '../../../../core/widgets/custom_toast.dart';



class AddRateCubit extends Cubit<BaseStates> {
  AddRateCubit() : super(BaseStatesInitState());

  static AddRateCubit get(context) => BlocProvider.of(context);
  TextEditingController commentCtrl=TextEditingController();

  ///comment rating
  dynamic commentRating=0.0;
  void changeCommentRate(rate){
    commentRating = rate;
    emit(BaseStatesChangeState());
  }

  Future<void> addRate({required int id})async{
    emit(BaseStatesLoadingState());
    Map<dynamic,dynamic> response = await myDio(endPoint: "${AppConfig.addRate}$id", dioType: DioType.post,
        dioBody: {
          "rate" :commentRating,
          "comment" : commentCtrl.text,
        });
    debugPrint(response.toString());
    if(response["status"]) {
      showToast(text: response["message"], state: ToastStates.success);
      navigatorPop();
      emit(BaseStatesSuccessState());
    }else{
      showToast(text: response["message"], state: ToastStates.error);
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }


}