import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/local/cache_helper.dart';
import '../../../../core/remote/my_dio.dart';
import '../../../../core/utils/my_navigate.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../auth/register_as/view/register_as_screen.dart';



class ProfileCubit extends Cubit<BaseStates> {
  ProfileCubit() : super(BaseStatesInitState());

  static ProfileCubit get(context) => BlocProvider.of(context);

  void changeLang(context){
    context.locale.languageCode=="ar"?context.setLocale(const Locale("en")): context.setLocale(const Locale("ar"));
    emit(BaseStatesChangeState());
  }

  ///logout
  Future<void> userLogout()async{
    emit(BaseStatesLoadingState());
    Map<dynamic,dynamic> response = await myDio(
      endPoint: AppConfig.logout,
      dioType: DioType.get,
    );
    if(response["status"]==true){
      showToast(text: response['message'], state: ToastStates.success);
      // await FirebaseFirestore.instance.collection('users').doc('user_id_${CacheHelper.getData(key: AppCached.role)==AppCached.teacher?"t_":"s_"}${CacheHelper.getData(key: AppCached.id)}').update({
      //   "is_online" :false,
      //   "fire_token" : null,
      // });
      CacheHelper.deleteData(key: AppCached.id);
      CacheHelper.deleteData(key: AppCached.token);
      CacheHelper.deleteData(key: AppCached.role);
      CacheHelper.deleteData(key: AppCached.name);
      navigateAndFinish(widget: const RegisterASScreen());
      emit(BaseStatesSuccessState());
    }else{
      showToast(text: response['message'], state: ToastStates.error);
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }

  ///logout
  Future<void> delAccount()async{
    emit(BaseStatesLoadingState3());
    Map<dynamic,dynamic> response = await myDio(
      endPoint: AppConfig.delAccount,
      dioType: DioType.get,
    );
    if(response["status"]==true){
      showToast(text: response['message'], state: ToastStates.success);
      // await FirebaseFirestore.instance.collection('users').doc('user_id_${CacheHelper.getData(key: AppCached.role)==AppCached.teacher?"t_":"s_"}${CacheHelper.getData(key: AppCached.id)}').update({
      //   "is_online" :false,
      //   "fire_token" : null,
      // });
      CacheHelper.deleteData(key: AppCached.id);
      CacheHelper.deleteData(key: AppCached.token);
      navigateAndFinish(widget: const RegisterASScreen());
      emit(BaseStatesSuccessState());
    }else{
      showToast(text: response['message'], state: ToastStates.error);
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }
  ///**** Change Image*****
  ///pick user image
  File? imageFile;
  String? imagePicked;
  Future<void> pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery,imageQuality: 70);
      if(pickedImage != null) {
        imageFile = File(pickedImage.path);
        imagePicked=imageFile!.path;
        await  changImage();
        emit(BaseStatesChangeState());
      } else {
        debugPrint("User didn't pick any image.");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  Future<void> pickImageFromCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedImage = await picker.pickImage(source: ImageSource.camera,imageQuality: 70);
      if(pickedImage != null) {
        imageFile = File(pickedImage.path);
        imagePicked=imageFile!.path;
        await   changImage();
        emit(BaseStatesChangeState());
      } else {
        debugPrint("User didn't pick any image.");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  changImage()async{
    print("55555555555555555");
    emit(BaseStatesLoadingState2());
    FormData body= FormData.fromMap({
      "image" : imageFile!=null ? await MultipartFile.fromFile(imageFile!.path): null,
    });
    Map<dynamic,dynamic> response = await myDio(endPoint:CacheHelper.getData(key: AppCached.role)==AppCached.student? AppConfig.updateStudentImage: AppConfig.updateTeacherImage,
        dioType: DioType.post,dioBody: body);
    debugPrint(response.toString());
    if(response["status"]==true){
      showToast(text: response["message"], state: ToastStates.success);
      CacheHelper.saveData(key: AppCached.image, value: response["data"]["image"]);
      emit(BaseStatesSuccessState());
    }else{
      showToast(text: response["message"], state: ToastStates.error);
      emit(BaseStatesError2State());
    }
  }

}