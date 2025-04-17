
import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/remote/my_dio.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../result/view/result_screen.dart';
import '../model/exam_model.dart';



class ExamCubit extends Cubit<BaseStates> {
  ExamCubit() : super(BaseStatesInitState());

  static ExamCubit get(context) => BlocProvider.of(context);

   PageController pageController = PageController();
   int currentIndex = 0;
   void changeIndex(index){
     currentIndex=index;
     emit(BaseStatesChangeState());
   }



  ExamModel? myExamModel;
  Future<void> getExam({required int id,required bool isLieutenant})async{
    emit(BaseStatesLoadingState());
    Map<dynamic,dynamic> response =await myDio(endPoint:isLieutenant==true?'${AppConfig.lieutenantExam}$id':'${AppConfig.getExam}$id', dioType: DioType.get);
    debugPrint(response.toString());
    if(response["status"]==true){
      myExamModel = ExamModel.fromJson(response);
      emit(BaseStatesSuccessState());
    }else{
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }

  int? selectedAnswer;
  List<Map<String, int>> answers=[];
void addAnswer(currentAnswer,currentQuestion){
  selectedAnswer=currentAnswer;
  answers.add(
    {"question_id": currentQuestion, "answer_id": currentAnswer}
  );
  print("3333333");
  print(answers.toString());
  emit(BaseStatesChangeState());
}


  Future<void> submitExam(String examId, bool isLieutenant )async{
  print("445555");
    emit(BaseStatesLoadingState());
    Map<String, dynamic> formDataMap = {};

    for (int i = 0; i < answers.length; i++) {
      formDataMap["answers[$i][question_id]"] = answers[i]["question_id"].toString();
      formDataMap["answers[$i][answer_id]"] = answers[i]["answer_id"].toString();
    }

    FormData formData = FormData.fromMap(formDataMap);
    Map<dynamic,dynamic> response = await myDio(endPoint:isLieutenant==true? AppConfig.submitExamLieutenant+examId : AppConfig.submitExam+examId, dioType: DioType.post,
        dioBody: formData);
    debugPrint(response.toString());
    if(response["status"]) {
      showToast(text: response["message"], state: ToastStates.success);

      navigateAndReplace(widget: ResultScreen(totalQuestion:response["data"]["total_questions"].toString(),correctAnswer: response["data"]["correct_answers"].toString(),finalScore: response["data"]["final_score"].toString(),
        duration:myExamModel!.data!.duration.toString(),));
      emit(BaseStatesSuccessState());
    }else{
      showToast(text: response["message"], state: ToastStates.error);
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }


}