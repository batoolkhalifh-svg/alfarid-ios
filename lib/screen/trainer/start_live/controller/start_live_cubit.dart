import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/local/cache_helper.dart';
import '../../../../core/remote/my_dio.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../model/student_model.dart';
import '../view/link_live.dart';





class StartLiveCubit extends Cubit<BaseStates> {
  StartLiveCubit() : super(BaseStatesInitState());

  static StartLiveCubit get(context) => BlocProvider.of(context);

  TextEditingController liveTitleController = TextEditingController();
  TextEditingController liveDataController = TextEditingController();
  TextEditingController liveTimeController = TextEditingController();
  TextEditingController notesController = TextEditingController();


  List<DataS> selectedStudent=[];
  List<int> selectedId=[];
  void addSelectedList(list){
    selectedId=[];
    selectedStudent=list;
    selectedStudent.forEach((e){
      selectedId.add(e.id!);
    });
    emit(BaseStatesChangeState());
  }


  DateTime? date;
  void selectDate(value) {
    date=value;
    var format = DateFormat("yyyy-MM-dd", "en").format(value);
    liveDataController.text = format;
    emit(BaseStatesChangeState());
  }
  ///time
  String formatTimeOfDay(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return "$hours:$minutes";
  }
  void getTime({required TimeOfDay val}) {
    liveTimeController.text = formatTimeOfDay(val);
    emit(BaseStatesChangeState());
  }

  ///******************Get Students******************
  StudentsModel? studentsModel;
  Future<void> fetchStudents()async{
    emit(BaseStatesLoadingState2());
    Map<dynamic,dynamic> response =await myDio(endPoint: AppConfig.tStudents, dioType: DioType.get);
    debugPrint(response.toString());
    if(response["status"]==true){
      studentsModel = StudentsModel.fromJson(response);
      emit(BaseStatesSuccessState());
    }else{
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }
  var slug ;
  Future<void> createLive () async {
    emit(BaseStatesLoadingState());
    try {
      slug = FirebaseFirestore.instance.collection('lives').doc().id ;
      final body = {
        "name": liveTitleController.text,
        "url": "https://meet.jit.si/$slug",
        "date": liveDataController.text,
        "time": liveTimeController.text,
        "student_ids":selectedId
      };
      Map<dynamic, dynamic>  createLiveResponse = await myDio(
          dioBody: body,
          endPoint: AppConfig.liveStream,
          dioType: DioType.post);
      if (createLiveResponse['status'] == false) {
        debugPrint(createLiveResponse.toString());
        showToast(text: createLiveResponse['message'], state: ToastStates.error);
        emit(BaseStatesErrorState(msg: createLiveResponse['message']));
      } else {
        debugPrint(createLiveResponse.toString());
        await FirebaseFirestore.instance.collection('lives').doc().set({
          'active': false,
          'date': liveDataController.text,
          'details': notesController.text,
          'link' : "https://meet.jit.si/$slug",
          'slug':'$slug',
          'finished': false,
          'live_name': liveTitleController.text,
          'teacher_name': CacheHelper.getData(key: AppCached.name),
          'teacher_photo': CacheHelper.getData(key: AppCached.image),
          'time': liveTimeController.text,
          'user_id': CacheHelper.getData(key: AppCached.id).toString(),
          'student_ids': selectedId,
        });
        navigateAndReplace(widget: LinkLive(link: createLiveResponse['data']['url']));
        emit(BaseStatesSuccessState());
       }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

}
