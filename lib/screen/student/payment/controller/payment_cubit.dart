
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/remote/my_dio.dart';
import '../../../../core/utils/my_navigate.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../bottom_nav_student/view/bottom_nav_screen.dart';
import 'payment_states.dart';

class PaymentCubit extends Cubit<PaymentStates> {
  PaymentCubit() :super(PaymentInitialState());
  Future<void> buyBookFromCart()async{
    emit(LoadingPaymentState());
    Map<dynamic,dynamic> response =await myDio(endPoint: AppConfig.buyBookFromCart, dioType: DioType.get);
    debugPrint(response.toString());
    if(response["status"]==true){
      showToast(text: response['message'], state: ToastStates.success);
      navigateAndFinish(widget: const BottomNavScreen());
      emit(SuccessPaymentState());
    }else{
      showToast(text: response['message'], state: ToastStates.error);
      emit(ErrorPaymentState(msg: response["message"]));
    }
  }

}