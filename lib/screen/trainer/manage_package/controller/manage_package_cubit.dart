import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/remote/my_dio.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../model/package_model.dart';



class ManagePackageCubit extends Cubit<BaseStates> {
  ManagePackageCubit() : super(BaseStatesInitState());

  static ManagePackageCubit get(context) => BlocProvider.of(context);

  MyPackageModel? packageModel;
  Future<void> fetchPackages()async{
    emit(BaseStatesLoadingState2());
    Map<dynamic,dynamic> response =await myDio(endPoint: AppConfig.teacherSubscribe, dioType: DioType.get);
    debugPrint(response.toString());
    if(response["status"]==true){
      packageModel = MyPackageModel.fromJson(response);
      emit(BaseStatesSuccessState());
    }else{
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }

  Future<void> reNewPackage()async{
    emit(BaseStatesLoadingState());
    Map<dynamic,dynamic> response = await myDio(endPoint: AppConfig.reNewPackage, dioType: DioType.post);
    debugPrint(response.toString());
    if(response["status"]) {
      showToast(text: response["message"], state: ToastStates.success);
      emit(BaseStatesSuccessState());
    }else{
      showToast(text: response["message"], state: ToastStates.error);
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }


}