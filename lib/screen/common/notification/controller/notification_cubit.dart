import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/remote/my_dio.dart';
import '../model/notification_model.dart';



class NotificationCubit extends Cubit<BaseStates> {
  NotificationCubit() : super(BaseStatesInitState());

  static NotificationCubit get(context) => BlocProvider.of(context);

  int currentPage=1;
  List<Items> data=[];


  NotificationModel? myNotificationModel;
  Future<void> getNotification()async{
    currentPage==1? emit(BaseStatesLoadingState()):null;
    Map<dynamic,dynamic> response =await myDio(endPoint:'${AppConfig.notifications}?page=$currentPage',
        dioType: DioType.get);
    debugPrint(response.toString());
    if(response["status"]==true){
      myNotificationModel = NotificationModel.fromJson(response);
      data.addAll(myNotificationModel!.data!.items!);
      emit(BaseStatesSuccessState());
    }else{
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }

  Future<void> nextNotification()async{
    emit(BaseStatesChangeState());
    currentPage++;
    await getNotification();
  }

}