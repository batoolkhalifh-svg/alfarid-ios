import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/remote/my_dio.dart';
import '../model/notification_model.dart';

class NotificationCubit extends Cubit<BaseStates> {
  NotificationCubit() : super(BaseStatesInitState());

  static NotificationCubit get(context) => BlocProvider.of(context);

  int currentPage = 1;
  List<Items> data = [];

  NotificationModel? myNotificationModel;

  Future<void> getNotification() async {
    if (currentPage == 1) emit(BaseStatesLoadingState());

    Map<dynamic, dynamic> response = await myDio(
      endPoint: '${AppConfig.notifications}?page=$currentPage',
      dioType: DioType.get,
    );

    debugPrint("Full Response: $response");

    // تحويل Map<dynamic, dynamic> إلى Map<String, dynamic>
    Map<String, dynamic> jsonResponse = Map<String, dynamic>.from(response);

    if (jsonResponse["status"] == true) {
      // التحقق من وجود العناصر داخل response
      if (jsonResponse['data'] != null &&
          jsonResponse['data']['items'] != null) {
        for (var item in jsonResponse['data']['items']) {
          debugPrint('Item JSON: $item');
        }
      }

      // إنشاء الموديل بعد التحويل
      myNotificationModel = NotificationModel.fromJson(jsonResponse);
      data.addAll(myNotificationModel!.data!.items ?? []);

      emit(BaseStatesSuccessState());
    } else {
      emit(BaseStatesErrorState(msg: jsonResponse["message"] ?? 'حدث خطأ'));
    }
  }

  Future<void> nextNotification() async {
    emit(BaseStatesChangeState());
    currentPage++;
    await getNotification();
  }
}
