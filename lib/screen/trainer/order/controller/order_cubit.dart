import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/remote/my_dio.dart';
import '../../../../generated/locale_keys.g.dart';
import '../model/order_model.dart';



class OrderCubit extends Cubit<BaseStates> {
  OrderCubit() : super(BaseStatesInitState());

  static OrderCubit get(context) => BlocProvider.of(context);


  List myOrders=[
    LocaleKeys.currentRequests.tr(),
    LocaleKeys.answered.tr(),
  ];
  bool isCurrent=true;
  void changeCourse(current){
    isCurrent=current;
    emit(BaseStatesChangeState());
  }

  OrdersModel? currentOrderModel;
  fetchCurrentOrder()async{
    emit(BaseStatesLoadingState());
    Map<dynamic,dynamic> response = await myDio(endPoint: AppConfig.currentReservationOrder, dioType: DioType.get);
    debugPrint(response.toString());
    if(response["status"]==true){
      currentOrderModel = OrdersModel.fromJson(response);
      await fetchDoneOrder();
      // emit(BaseStatesSuccessState());
    }else{
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }

  OrdersModel? doneOrderModel;
  fetchDoneOrder()async{
    // emit(BaseStatesLoadingState());
    Map<dynamic,dynamic> response = await myDio(endPoint: AppConfig.doneReservationOrder, dioType: DioType.get);
    debugPrint(response.toString());
    if(response["status"]==true){
      doneOrderModel = OrdersModel.fromJson(response);
      emit(BaseStatesSuccessState());
    }else{
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }

}