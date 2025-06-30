import 'package:alfarid/core/local/app_cached.dart';
import 'package:alfarid/core/local/cache_helper.dart';
import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/remote/my_dio.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../core/widgets/teacher_model.dart';
import '../../auth/register/model/classroom_model.dart';
import '../../auth/register/model/subject_model.dart';
import '../model/user_model.dart';

class EditProfileCubit extends Cubit<BaseStates> {
  EditProfileCubit() : super(BaseStatesInitState());

  static EditProfileCubit get(context) => BlocProvider.of(context);

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

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

  SubjectModel? subjectsModel;

  Future<void> fetchSubjects() async {
    // emit(BaseStatesLoadingState2());
    Map<dynamic, dynamic> response = await myDio(endPoint: AppConfig.subjects, dioType: DioType.get);
    debugPrint(response.toString());
    if (response["status"] == true) {
      subjectsModel = SubjectModel.fromJson(response);
      // emit(BaseStatesSuccessState());
    } else {
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }

  ClassroomsModel? classroomModel;

  Future<void> fetchClassroom() async {
    // emit(BaseStatesLoadingState2());
    Map<dynamic, dynamic> response = await myDio(endPoint: AppConfig.classrooms, dioType: DioType.get);
    debugPrint(response.toString());
    if (response["status"] == true) {
      classroomModel = ClassroomsModel.fromJson(response);
      // emit(BaseStatesSuccessState());
    } else {
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }

  UserModel? userModel;

  Future<void> fetchUser() async {
    emit(BaseStatesLoadingState());
    Map<dynamic, dynamic> response = await myDio(endPoint: AppConfig.studentData, dioType: DioType.get);
    debugPrint(response.toString());
    if (response["status"] == true) {
      userModel = UserModel.fromJson(response);
      await fetchClassroom();
      nameController.text = userModel!.data!.name.toString();
      emailController.text = userModel!.data!.email.toString();
      phoneController.text = userModel!.data!.phone.toString();
      phone = userModel!.data!.phone.toString();
      phoneKeyNumber = userModel!.data!.phoneKey.toString();
      phoneKeyCode = CacheHelper.getData(key: AppCached.phoneKeyCode);
      // classroomId=userModel!.data!.classroom!.id.toString();
      selectedClassroomNames.add(userModel!.data!.classroom!.name.toString());
      selectedClassroomIds.add(userModel!.data!.classroom!.id!);
      classRoomCtrl.text = selectedClassroomNames.first;
      emit(BaseStatesSuccessState());
    } else {
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }

  TextEditingController classRoomCtrl = TextEditingController();
  TextEditingController subjectCtrl = TextEditingController();
  TeacherModel? teacherModel;

  Future<void> fetchTeacher() async {
    emit(BaseStatesLoadingState());
    Map<dynamic, dynamic> response = await myDio(endPoint: AppConfig.teacherData, dioType: DioType.get);
    debugPrint(response.toString());
    if (response["status"] == true) {
      teacherModel = TeacherModel.fromJson(response);
      await fetchClassroom();
      await fetchSubjects();
      nameController.text = teacherModel!.data!.name.toString();
      emailController.text = teacherModel!.data!.email.toString();
      phoneController.text = teacherModel!.data!.phone.toString();
      phone = teacherModel!.data!.phone.toString();
      phoneKeyNumber = teacherModel!.data!.phoneKey ?? '974';
      phoneKeyCode = CacheHelper.getData(key: AppCached.phoneKeyCode);
      teacherModel!.data!.classrooms!.forEach(
        (element) {
          selectedClassroomNames.add(element.name.toString());
          selectedClassroomIds.add(element.id!);
        },
      );
      classRoomCtrl.text = selectedClassroomNames.join(' , ');
      teacherModel!.data!.subjects!.forEach(
        (element) {
          subjectNames.add(element.name.toString());
          subjectIds.add(element.id!);
        },
      );
      subjectCtrl.text = subjectNames.join(' , ');
      emit(BaseStatesSuccessState());
    } else {
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }

  Future<void> profileEdits() async {
    emit(BaseStatesLoadingState2());
    final formData = ({
      "name": nameController.text,
      "email": emailController.text,
      'phone_key': phoneKeyNumber,
      'phone': phone,
      'classroom_id': selectedClassroomIds.first,
    });
    final formDataT = ({
      "name": nameController.text,
      "email": emailController.text,
      'phone_key': phoneKeyNumber,
      'phone': phone,
      'subject_id': subjectIds,
      'classroom_id': selectedClassroomIds,
    });
    debugPrint(formData.toString());
    debugPrint(formDataT.toString());
    Map<dynamic, dynamic> response = await myDio(
        endPoint: CacheHelper.getData(key: AppCached.role) == AppCached.student ? AppConfig.updateStudentData : AppConfig.updateTeacherData,
        dioType: DioType.post,
        dioBody: CacheHelper.getData(key: AppCached.role) == AppCached.student ? formData : formDataT);
    debugPrint(response.toString());
    if (response["status"]) {
      showToast(text: response["message"], state: ToastStates.success);
      CacheHelper.saveData(key: AppCached.phoneKeyCode, value: phoneKeyCode);
      CacheHelper.saveData(key: AppCached.name, value: nameController.text);
      CacheHelper.saveData(key: AppCached.email, value: emailController.text);
      navigatorPop();
      emit(BaseStatesSuccessState());
    } else {
      showToast(text: response["message"], state: ToastStates.error);
      emit(BaseStatesError2State());
    }
  }

  List<int> selectedClassroomIds = [];
  List<String> selectedClassroomNames = [];

  void changeSelectedClassrooms({required int id, required String name}) {
    final isStudent = CacheHelper.getData(key: AppCached.role) == AppCached.student;

    if (isStudent) {
      selectedClassroomIds
        ..clear()
        ..add(id);

      selectedClassroomNames
        ..clear()
        ..add(name);
    } else {
      if (selectedClassroomIds.contains(id)) {
        selectedClassroomIds.remove(id);
        selectedClassroomNames.remove(name);
      } else {
        selectedClassroomIds.add(id);
        selectedClassroomNames.add(name);
      }
    }
    classRoomCtrl.text = selectedClassroomNames.join(' , ');
    emit(BaseStatesChangeState());
  }
  List<int> subjectIds = [];
  List<String> subjectNames = [];

  void changeSelectedSubjects({required int id, required String name}) {
    final isStudent = CacheHelper.getData(key: AppCached.role) == AppCached.student;

    if (isStudent) {
      subjectIds
        ..clear()
        ..add(id);

      subjectNames
        ..clear()
        ..add(name);
    } else {
      if (subjectIds.contains(id)) {
        subjectIds.remove(id);
        subjectNames.remove(name);
      } else {
        subjectIds.add(id);
        subjectNames.add(name);
      }
    }
    subjectCtrl.text = subjectNames.join(' , ');
    emit(BaseStatesChangeState());
  }
}
