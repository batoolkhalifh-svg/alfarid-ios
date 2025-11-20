import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/base_state.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/remote/my_dio.dart';
import '../model/order_model.dart';

class OrderCubit extends Cubit<BaseStates> {
  OrderCubit() : super(BaseStatesInitState());

  static OrderCubit get(context) => BlocProvider.of(context);

  bool isCurrent = true;

  void changeCourse(bool current) {
    isCurrent = current;
    emit(BaseStatesChangeState());
  }

  OrdersModel? currentOrderModel;
  OrdersModel? doneOrderModel;

  fetchCurrentOrder() async {
    emit(BaseStatesLoadingState());
    try {
      final response = await myDio(
        endPoint: AppConfig.currentReservationOrder,
        dioType: DioType.get,
      );
      debugPrint('Response current >>> $response');

      if (response["status"] == true) {
        currentOrderModel = OrdersModel.fromJsonSafe(Map<String, dynamic>.from(response));
        await fetchDoneOrder();
      } else {
        emit(BaseStatesErrorState(msg: response["message"] ?? 'خطأ غير معروف'));
      }
    } catch (e) {
      emit(BaseStatesErrorState(msg: e.toString()));
    }
  }

  fetchDoneOrder() async {
    try {
      final response = await myDio(
        endPoint: AppConfig.doneReservationOrder,
        dioType: DioType.get,
      );
      debugPrint('Response done >>> $response');

      if (response["status"] == true) {
        doneOrderModel = OrdersModel.fromJsonSafe(Map<String, dynamic>.from(response));
        emit(BaseStatesSuccessState());
      } else {
        emit(BaseStatesErrorState(msg: response["message"] ?? 'خطأ غير معروف'));
      }
    } catch (e) {
      emit(BaseStatesErrorState(msg: e.toString()));
    }
  }
}
