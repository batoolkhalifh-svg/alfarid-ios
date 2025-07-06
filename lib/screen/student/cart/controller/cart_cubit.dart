import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/remote/my_dio.dart';
import '../../../../core/utils/my_navigate.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../main.dart';
import '../../bottom_nav_student/view/bottom_nav_screen.dart';
import '../../web_view.dart';
import '../model/my_cart_model.dart';

class CartCubit extends Cubit<BaseStates> {
  CartCubit() : super(BaseStatesInitState());

  static CartCubit get(context) => BlocProvider.of(context);
  TextEditingController discountCtrl = TextEditingController();

  MyCartModel? myMyCartModel;

  Future<void> getMyCart() async {
    emit(BaseStatesLoadingState());
    Map<dynamic, dynamic> response = await myDio(endPoint: AppConfig.myCart, dioType: DioType.get);
    debugPrint(response.toString());
    if (response["status"] == true) {
      myMyCartModel = MyCartModel.fromJson(response);
      emit(BaseStatesSuccessState());
    } else {
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }

  Future<void> deleteCart({required int itemId}) async {
    emit(BaseStatesChangeState());
    final formData = ({
      "item_id": itemId,
    });
    debugPrint(formData.toString());
    Map<dynamic, dynamic> response = await myDio(dioBody: formData, endPoint: AppConfig.deleteFromCart, dioType: DioType.post);
    debugPrint(response.toString());
    if (response['status'] == true) {
      showToast(text: response['message'], state: ToastStates.success);
      getMyCart();
      emit(BaseStatesSuccessState());
    } else {
      showToast(text: response['message'], state: ToastStates.error);
      emit(BaseStatesErrorState(msg: response['message']));
    }
  }

  Future<void> applyDiscount() async {
    emit(BaseStatesLoadingState2());
    final formData = ({
      "discount_code": discountCtrl.text,
    });
    debugPrint(formData.toString());
    Map<dynamic, dynamic> response = await myDio(dioBody: formData, endPoint: AppConfig.applyDiscount, dioType: DioType.post);
    debugPrint(response.toString());
    if (response['status'] == true) {
      showToast(text: response['message'], state: ToastStates.success);
      emit(BaseStatesSuccessState());
    } else {
      showToast(text: response['message'], state: ToastStates.error);
      emit(BaseStatesError2State());
    }
  }

  Future<void> buyBookFromCart() async {
    emit(BaseStatesLoadingState3());
    Map<dynamic, dynamic> response = await myDio(endPoint: AppConfig.buyBookFromCart, dioType: DioType.get);
    debugPrint(response.toString());
    if (response["status"] == true) {
      Navigator.push(
        navigatorKey.currentState!.context,
        MaterialPageRoute(
          builder: (context) => WebViewPaymentScreen(paymentUrl: response['data']['payment_url']),
        ),
      ).then((value) => getMyCart());
      emit(BaseStatesSuccessState());
    } else {
      showToast(text: response['message'], state: ToastStates.error);
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }
}
