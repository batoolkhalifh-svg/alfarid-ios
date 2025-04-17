import 'package:alfarid/core/widgets/custom_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/remote/my_dio.dart';
import '../model/teacher_profile_model.dart';



class TeacherProfileCubit extends Cubit<BaseStates> {
  TeacherProfileCubit() : super(BaseStatesInitState());

  static TeacherProfileCubit get(context) => BlocProvider.of(context);

  ///tabs
  int tab = 0 ;
  void changeTabs(tabNum){
    tab = tabNum;
    emit(BaseStatesChangeState());
  }

  Future<void> createUsers({required int id,required String name,required String image}) async {

    var userCollection = await FirebaseFirestore.instance.collection("users").doc("user_id_t_$id").get();
    if (userCollection.exists) {
    } else {
      await FirebaseFirestore.instance
          .collection('users').doc('user_id_t_$id').set({
        'id': 't_$id',
        'name': name,
        'image_url': image,
        "is_online": false,
        "lastSeen": DateTime.now().toString(),
        "fire_token" : "",
      });
    }
  }

  TeacherProfileModel? teacherProfileModel;
  Future<void> fetchTeacherProfile({required int id})async{
    emit(BaseStatesLoadingState());
    Map<dynamic,dynamic> response =await myDio(endPoint: "${AppConfig.teachers}/$id", dioType: DioType.get);
    debugPrint(response.toString());
    if(response["status"]==true){
      teacherProfileModel = TeacherProfileModel.fromJson(response);
     emit(BaseStatesSuccessState());
    }else{
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }

  Future<void> directReserve({required int id})async{
    emit(BaseStatesLoadingState2());
    Map<dynamic,dynamic> response =await myDio(endPoint: "${AppConfig.directReserve}$id", dioType: DioType.get);
    debugPrint(response.toString());
    if(response["status"]==true){
      showToast(text: response["message"], state: ToastStates.success);
     emit(BaseStatesSuccessState());
    }else{
      showToast(text: response["message"], state: ToastStates.error);
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }

  toggleSaved({required int id, required int index})async{
    Map<dynamic,dynamic> response = await myDio(endPoint: AppConfig.saved, dioType: DioType.post,
        dioBody: {
          "course_id":id
        });
    debugPrint(response.toString());
    if(response["status"]==true){
      showToast(text: response["message"], state: ToastStates.success);
      teacherProfileModel!.data!.courses![index].isFavorite=!teacherProfileModel!.data!.courses![index].isFavorite!;
      emit(BaseStatesSuccessState());
    }else{
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }



}