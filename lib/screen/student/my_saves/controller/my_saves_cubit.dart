import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/remote/my_dio.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../model/saves_model.dart';



class MySavesCubit extends Cubit<BaseStates> {
  MySavesCubit() : super(BaseStatesInitState());

  static MySavesCubit get(context) => BlocProvider.of(context);


  ///get Saved data
  SavedModel? savedModel;
  fetchSaved()async{
    emit(BaseStatesLoadingState());
    Map<dynamic,dynamic> response = await myDio(endPoint: AppConfig.saved, dioType: DioType.get);
    debugPrint(response.toString());
    if(response["status"]==true){
      savedModel = SavedModel.fromJson(response);
      emit(BaseStatesSuccessState());
    }else{
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }
  ///toggle Saved
  toggleSaved({required int id})async{
    Map<dynamic,dynamic> response = await myDio(endPoint: AppConfig.saved, dioType: DioType.post,
        dioBody: {
         "course_id":id
        });
    debugPrint(response.toString());
    if(response["status"]==true){
      showToast(text: response["message"], state: ToastStates.success);
      savedModel!.data!.items!.removeWhere((element) => element.id==id,);
      emit(BaseStatesSuccessState());
    }else{
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }
}