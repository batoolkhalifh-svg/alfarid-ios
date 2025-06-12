import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
import '../../../../../core/widgets/user_model.dart';
import '../../../../student/bottom_nav_student/view/bottom_nav_screen.dart';
import '../../../../trainer/bottom_nav_teacher/view/bottom_nav_screen.dart';
import '../model/classroom_model.dart';
import '../model/subject_model.dart';

class RegisterCubit extends Cubit<BaseStates> {
  RegisterCubit() : super(BaseStatesInitState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  String? phone;
  String phoneKeyCode = 'QA';
  String phoneKeyNumber = '974';

  void getPhone(String phoneNumber) {
    phone = phoneNumber;
    emit(BaseStatesChangeState());
  }

  void getPhoneKey(String phoneKeyCountryCode, String phoneKeyNum) {
    phoneKeyCode = phoneKeyCountryCode;
    phoneKeyNumber = phoneKeyNum;
    emit(BaseStatesChangeState());
  }

  String? subjectId;

  void changeSubjectId(value) {
    subjectId = value;
    emit(BaseStatesChangeState());
  }

  SubjectModel? subjectsModel;

  Future<void> fetchSubjects() async {
    emit(BaseStatesLoadingState2());
    Map<dynamic, dynamic> response = await myDio(endPoint: AppConfig.subjects, dioType: DioType.get);
    debugPrint(response.toString());
    if (response["status"] == true) {
      subjectsModel = SubjectModel.fromJson(response);
      await fetchClassroom();
      emit(BaseStatesSuccessState());
    } else {
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }

  ClassroomsModel? classroomModel;

  Future<void> fetchClassroom() async {
    emit(BaseStatesLoadingState2());
    Map<dynamic, dynamic> response = await myDio(endPoint: AppConfig.classrooms, dioType: DioType.get);
    debugPrint(response.toString());
    if (response["status"] == true) {
      classroomModel = ClassroomsModel.fromJson(response);
      emit(BaseStatesSuccessState());
    } else {
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }

  String? fireToken;

  getFireToken() async {
    fireToken = await FirebaseMessaging.instance.getToken();
    debugPrint("$fireToken");
  }

  UserModel? registerModel;

  Future<void> register() async {
    emit(BaseStatesLoadingState());
    await getFireToken();
    final formDataStudent = ({
      "register_type": "student",
      "name": nameController.text,
      "email": emailController.text,
      'phone_key': phoneKeyNumber,
      'phone': phone,
      'password': passController.text,
      'classroom_id': selectedClassroomIds.first,
      'device_id': await getDeviceId(),
      'firebase_token': fireToken
    });
    Map<String, dynamic> formDataTeacher = {
      "register_type": "teacher",
      "name": nameController.text,
      "email": emailController.text,
      "phone_key": phoneKeyNumber,
      "phone": phone,
      "password": passController.text,
      "subject_id": [subjectId],
      "classroom_id": selectedClassroomIds,
      "device_id": await getDeviceId(),
      "firebase_token": fireToken,
    };
    debugPrint(CacheHelper.getData(key: AppCached.role) == AppCached.student ? formDataStudent.toString() : formDataTeacher.toString());
    Map<dynamic, dynamic> response = await myDio(
        endPoint: AppConfig.register,
        dioType: DioType.post,
        dioBody: CacheHelper.getData(key: AppCached.role) == AppCached.student ? formDataStudent : formDataTeacher);
    debugPrint(response.toString());
    if (response["status"]) {
      registerModel = UserModel.fromJson(response);
      // navigateTo(widget:  PinCodeScreen(fromRegister: true, token: response["data"]["token"], email:emailController.text,));
      CacheHelper.saveData(key: AppCached.token, value: response["data"]["token"]);
      CacheHelper.saveData(key: AppCached.phoneKeyCode, value: phoneKeyCode);
      CacheHelper.saveData(key: AppCached.name, value: registerModel!.data!.user!.name);
      CacheHelper.saveData(key: AppCached.id, value: registerModel!.data!.user!.id);
      CacheHelper.saveData(key: AppCached.email, value: registerModel!.data!.user!.email);
      CacheHelper.saveData(key: AppCached.image, value: registerModel!.data!.user!.image);
      CacheHelper.saveData(key: AppCached.isNotify, value: registerModel!.data!.user!.isNotified);
      CacheHelper.saveData(key: AppCached.isApple, value: registerModel!.data!.user!.isApple);
      await createUsers(
          id: registerModel!.data!.user!.id!, image: registerModel!.data!.user!.image!, name: registerModel!.data!.user!.name.toString());
      CacheHelper.getData(key: AppCached.role) == AppCached.student
          ? navigateAndFinish(widget: const BottomNavScreen())
          : navigateAndFinish(widget: const BottomNavTeacherScreen());
      emit(BaseStatesSuccessState());
    } else {
      showToast(text: response["message"], state: ToastStates.error);
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }

  ///create user in firebase

  Future<void> createUsers({required int id, required String name, required String image}) async {
    String typeId = CacheHelper.getData(key: AppCached.role) == AppCached.teacher ? 'user_id_t_$id' : 'user_id_s_$id';
    final userCollection = FirebaseFirestore.instance.collection('users').doc(typeId);
    final user = await userCollection.get();
    if (user.exists) {
      await FirebaseFirestore.instance.collection('users').doc(typeId).update({
        'id': CacheHelper.getData(key: AppCached.role) == AppCached.teacher ? 't_$id' : 's_$id',
        'name': name,
        'image_url': image,
        "is_online": true,
        "lastSeen": DateTime.now().toString(),
        "fire_token": fireToken,
      });
    } else {
      userCollection.set({
        'id': CacheHelper.getData(key: AppCached.role) == AppCached.teacher ? 't_$id' : 's_$id',
        'name': name,
        'image_url': image,
        "is_online": true,
        "lastSeen": DateTime.now().toString(),
        "fire_token": fireToken
      });
    }
  }

  List<int> selectedClassroomIds = [];
  List<String> selectedClassroomNames = [];

  void changeSelectedClassrooms({required int id, required String name}) {
    final isStudent = CacheHelper.getData(key: AppCached.role) == AppCached.student;

    if (isStudent) {
      selectedClassroomIds..clear()..add(id);

      selectedClassroomNames..clear()..add(name);
    } else {
      if (selectedClassroomIds.contains(id)) {
        selectedClassroomIds.remove(id);
        selectedClassroomNames.remove(name);
      } else {
        selectedClassroomIds.add(id);
        selectedClassroomNames.add(name);
      }
    }

    emit(BaseStatesChangeState());
  }
}
