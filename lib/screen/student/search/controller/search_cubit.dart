import 'package:alfarid/core/widgets/custom_toast.dart';
import 'package:alfarid/screen/student/search/model/search_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/remote/my_dio.dart';



class SearchCubit extends Cubit<BaseStates> {
  SearchCubit() : super(BaseStatesInitState());

  static SearchCubit get(context) => BlocProvider.of(context);
  TextEditingController searchCtrl=TextEditingController();

  bool isCurrent=true;
  void changeCourse(current){
    isCurrent=current;
    emit(BaseStatesChangeState());
  }


  SearchModel? searchModel;
  Future<void> search()async{
    emit(BaseStatesLoadingState());
    Map<dynamic,dynamic> response =await myDio(endPoint: "${AppConfig.search}${searchCtrl.text}", dioType: DioType.get);
    debugPrint(response.toString());
    if(response["status"]==true){
      searchModel = SearchModel.fromJson(response);
      emit(BaseStatesSuccessState());
    }else{
      showToast(text: response["message"], state: ToastStates.error);
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }

  ///toggle Saved
  toggleSaved({required int id, required int index})async{
    Map<dynamic,dynamic> response = await myDio(endPoint: AppConfig.saved, dioType: DioType.post,
        dioBody: {
          "course_id":id
        });
    debugPrint(response.toString());
    if(response["status"]==true){
      showToast(text: response["message"], state: ToastStates.success);
      searchModel!.data!.courses!.items![index].isFavorite= !searchModel!.data!.courses!.items![index].isFavorite!;
      emit(BaseStatesSuccessState());
    }else{
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }
}