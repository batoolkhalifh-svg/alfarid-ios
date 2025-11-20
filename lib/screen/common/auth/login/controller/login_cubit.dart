import 'package:alfarid/core/widgets/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/local/app_cached.dart';
import '../../../../../core/local/app_config.dart';
import '../../../../../core/local/cache_helper.dart';
import '../../../../../core/remote/my_dio.dart';
import '../../../../../core/utils/my_navigate.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_toast.dart';
import '../../../../../core/widgets/device_id.dart';
import '../../../../student/bottom_nav_student/view/bottom_nav_screen.dart';
import '../../../../trainer/bottom_nav_teacher/view/bottom_nav_screen.dart';



class LoginCubit extends Cubit<BaseStates> {
  LoginCubit() : super(BaseStatesInitState());

  static LoginCubit get(context) => BlocProvider.of(context);

  TextEditingController passController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  String? fireToken;
  getFireToken()async{
    fireToken = await FirebaseMessaging.instance.getToken();
    debugPrint("$fireToken");
  }

  ///login data
  UserModel? loginModel;

  Future<void> login()async{
    emit(BaseStatesLoadingState());
    await getFireToken();
    final formDataStudent = ({
      "register_type": "student",
      "email": emailController.text.trim(),
      "password": passController.text.trim(),
      "firebase_token": fireToken,
      "device_id": await getDeviceId(),
    });

    final formDataTeacher = ({
      "register_type": "teacher",
      "email": emailController.text.trim(),
      "password": passController.text.trim(),
      "firebase_token": fireToken,
      "device_id": await getDeviceId(),
    });

    debugPrint(CacheHelper.getData(key: AppCached.role)==AppCached.student? formDataStudent.toString():formDataTeacher.toString());
    Map<dynamic, dynamic> loginResponse = await myDio(
        dioBody: CacheHelper.getData(key: AppCached.role)==AppCached.student? formDataStudent:formDataTeacher,
        endPoint: AppConfig.login,
        dioType: DioType.post);
    debugPrint(loginResponse.toString());
    if(loginResponse['status'] ==true){
      loginModel = UserModel.fromJson(loginResponse);
      // if(loginModel!.data!.user!.isVerified==true){
      showToast(text: loginResponse['message'], state: ToastStates.success);
      CacheHelper.saveData(key: AppCached.token, value: loginModel!.data!.token);
      CacheHelper.saveData(key: AppCached.id, value: loginModel!.data!.user!.id);
      CacheHelper.saveData(key: AppCached.name, value: loginModel!.data!.user!.name);
      CacheHelper.saveData(key: AppCached.email, value:  loginModel!.data!.user!.email);
      CacheHelper.saveData(key: AppCached.image, value:  loginModel!.data!.user!.image);
      CacheHelper.saveData(key: AppCached.isNotify, value:  loginModel!.data!.user!.isNotified);
      CacheHelper.getData(key:AppCached.phoneKeyCode ) == null ?
      CacheHelper.saveData(key: AppCached.phoneKeyCode, value: 'QA'):null;
      // FocusScope.of(navigatorKey.currentContext!).unfocus();
      CacheHelper.getData(key: AppCached.role)==AppCached.student? navigateAndFinish(widget:const BottomNavScreen()):navigateAndFinish(widget:const BottomNavTeacherScreen());
      CacheHelper.saveData(key: AppCached.isApple, value:  loginModel!.data!.user!.isApple);

      // }
      // else{
      //   navigateTo(widget: PinCodeScreen(fromRegister: true, token: loginModel!.data!.token.toString(), email: loginModel!.data!.user!.email.toString()));
      // }
      String typeId=CacheHelper.getData(key: AppCached.role)==AppCached.teacher?'user_id_t_${loginModel!.data!.user!.id}':'user_id_s_${loginModel!.data!.user!.id}';

      var userCollection = await FirebaseFirestore.instance.collection("users").doc(typeId).get();
      if (userCollection.exists) {
        await FirebaseFirestore.instance.collection('users').doc(typeId).update({
          'id': CacheHelper.getData(key: AppCached.role)==AppCached.teacher ? 't_${loginModel!.data!.user!.id}':'s_${loginModel!.data!.user!.id}',
          'name': loginModel!.data!.user!.name,
          'image_url': loginModel!.data!.user!.image,
          "is_online" : true,
          "lastSeen" : DateTime.now().toString(),
          "fire_token" : fireToken,
        });
      } else {
        await FirebaseFirestore.instance
            .collection('users').doc(typeId).set({
          'id': CacheHelper.getData(key: AppCached.role)==AppCached.teacher ? 't_${loginModel!.data!.user!.id}':'s_${loginModel!.data!.user!.id}',
          'name': loginModel!.data!.user!.name,
          'image_url': loginModel!.data!.user!.image,
          "is_online" : true,
          "lastSeen" : DateTime.now().toString(),
          "fire_token" : fireToken,
        });
      }



      emit(BaseStatesSuccessState());
    }else{
      showToast(text: loginResponse['message'], state: ToastStates.error);
      emit(BaseStatesErrorState(msg: loginResponse['message']));
    }}

}