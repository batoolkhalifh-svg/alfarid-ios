import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:alfarid/screen/trainer/bottom_nav_teacher/view/widgets/bottom_nav_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/remote/my_dio.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../model/order_details_model.dart';



class OrderDetailsCubit extends Cubit<BaseStates> {
  OrderDetailsCubit() : super(BaseStatesInitState());

  static OrderDetailsCubit get(context) => BlocProvider.of(context);

  OrdersDetailsModel? orderDetailsModel;
  fetchOrderDetails({required int id})async{
    emit(BaseStatesLoadingState());
    Map<dynamic,dynamic> response = await myDio(endPoint: "${AppConfig.orderDetails}$id", dioType: DioType.get);
    debugPrint(response.toString());
    if(response["status"]==true){
      orderDetailsModel = OrdersDetailsModel.fromJson(response);
      emit(BaseStatesSuccessState());
    }else{
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }

  changStatus({required int id, required String status})async{
    emit(BaseStatesLoadingState2());
    Map<dynamic,dynamic> response = await myDio(endPoint: "teacher/reservations/$id?_method=PUT", dioType: DioType.post,
        dioBody: {
          "status" :status,
        });
    debugPrint(response.toString());
    if(response["status"]==true){
      showToast(text: response["message"], state: ToastStates.success);
      navigateAndFinish(widget: const BottomNavBody());
      orderDetailsModel = OrdersDetailsModel.fromJson(response);
      emit(BaseStatesSuccessState());
    }else{
      emit(BaseStatesError2State());
    }
  }

}