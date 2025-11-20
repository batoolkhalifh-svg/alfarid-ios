import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:alfarid/screen/trainer/bottom_nav_teacher/view/widgets/bottom_nav_body.dart';
import 'package:alfarid/screen/trainer/timetable/controller/timetable_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/remote/my_dio.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../generated/locale_keys.g.dart';
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
      final List<String> responsDays = orderDetailsModel!.data!.slots.map((slot) => slot.day!).toList();
      daysList = weekDays.where((element) => responsDays.contains(element.key)).toList();

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

  late List<DayModel> daysList;
  List<DayModel> weekDays = [
    DayModel(day: LocaleKeys.saturday.tr(), key: 'saturday'),
    DayModel(day: LocaleKeys.sunday.tr(), key: 'sunday'),
    DayModel(day: LocaleKeys.monday.tr(), key: 'monday'),
    DayModel(day: LocaleKeys.tuesday.tr(), key: 'tuesday'),
    DayModel(day: LocaleKeys.wednesday.tr(), key: 'wednesday'),
    DayModel(day: LocaleKeys.thursday.tr(), key: 'thursday'),
    DayModel(day: LocaleKeys.friday.tr(), key: 'friday'),
  ];
  
}