import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/remote/my_dio.dart';
import '../model/help_support_model.dart';



class HelpAndSupportCubit extends Cubit<BaseStates> {
  HelpAndSupportCubit() : super(BaseStatesInitState());

  static HelpAndSupportCubit get(context) => BlocProvider.of(context);


  HelpAndSupportModel? helpAndSupportModel;
  Future<void> helpAndSupport()async{
    emit(BaseStatesLoadingState());
    Map<dynamic,dynamic> response =await myDio(endPoint:AppConfig.helpAndSupport,
        dioType: DioType.get);
    debugPrint(response.toString());
    if(response["status"]==true){
      helpAndSupportModel = HelpAndSupportModel.fromJson(response);
      emit(BaseStatesSuccessState());
    }else{
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }


  Future<void> launcher({required String path}) async {
    final Uri url = Uri.parse(path);
    if (await launchUrl(url)) {}
  }
}