import 'package:alfarid/core/remote/my_dio.dart';
import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:alfarid/core/widgets/custom_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/widgets/base_state.dart';
import '../../../../../../core/local/app_cached.dart';
import '../../../../../../core/local/app_config.dart';
import '../../../../../../core/local/cache_helper.dart';
import '../../../../../trainer/start_live/model/student_model.dart';



class ChatTeacherCubit extends Cubit<BaseStates> {
  ChatTeacherCubit() : super(BaseStatesInitState());

  static ChatTeacherCubit get(context) => BlocProvider.of(context);

  int tab = 0 ;
  void changeTabs(tabNum){
    tab = tabNum;
    emit(BaseStatesChangeState());
  }

  int id=CacheHelper.getData(key: AppCached.id);

  TextEditingController groupName=TextEditingController();


  Stream<List<Map<String, dynamic>>> getTeacherGroups()  {
    return FirebaseFirestore.instance
        .collection('groups')
        .where('teacherId', isEqualTo: "t_$id")
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((doc) => doc.data()).toList());
  }


  Stream<List<Map<String, dynamic>>> fetchStudentGroups() {
    return FirebaseFirestore.instance
        .collection('groups')
        .where('students', arrayContains: "s_$id")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }
  bool showBtn=true;

  Future<void> createGroup({required List students}) async {
    emit(BaseStatesLoadingState());

    var groupCollection = await FirebaseFirestore.instance.collection("groups").doc("Group${groupName.text}TeacherId_$id").get();
    if (groupCollection.exists) {
      showToast(text: "The Group Exist", state: ToastStates.error);
    } else {
      await FirebaseFirestore.instance
          .collection('groups').doc("Group${groupName.text}TeacherId_$id").set({
        'teacherId': "t_$id",
        'groupName': groupName.text,
        'students': students,
        "groupId":"Group${groupName.text}TeacherId_$id"
      });
      showBtn=true;
      emit(BaseStatesSuccessState());
    }
    groupName.clear();
    navigatorPop();
  }


  ///****fetch Students*******
  List<DataS> selectedStudent=[];
  List<String> selectedId=[];
  void addSelectedList(list){
    selectedId=[];
    selectedStudent=list;
    selectedStudent.forEach((e){
      selectedId.add("s_${e.id!}");
    });
    emit(BaseStatesChangeState());
  }
  StudentsModel? studentsModel;
  Future<void> fetchStudents()async{
    emit(BaseStatesLoadingState2());
    getTeacherGroups().listen((groups) {
      if (groups.isEmpty) {
        showBtn=false;
        print("No groups found.");
      } else {
        showBtn=true;
        print("Groups: $groups");
      }
    });
    Map<dynamic,dynamic> response =await myDio(endPoint: AppConfig.tStudents, dioType: DioType.get);
    debugPrint(response.toString());
    if(response["status"]==true){
      studentsModel = StudentsModel.fromJson(response);
      emit(BaseStatesSuccessState());
    }else{
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }
}