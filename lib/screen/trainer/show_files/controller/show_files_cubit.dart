
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/remote/my_dio.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../model/file_model.dart';


class ShowFilesCubit extends Cubit<BaseStates> {
  ShowFilesCubit() : super(BaseStatesInitState());

  static ShowFilesCubit get(context) => BlocProvider.of(context);




  Future<void> launcher({required String path}) async {
    final Uri url = Uri.parse(path);
    if (await launchUrl(url)) {}
  }

  FileModel? fileModel;
  Future<void> getFiles() async {
    emit(BaseStatesLoadingState());
    try {
      Map<dynamic, dynamic> response = await myDio(
          endPoint: AppConfig.teacherFiles,
          dioType: DioType.get);

      if (response['status'] == false) {
        debugPrint(response.toString());
        showToast(text: response['message'], state: ToastStates.error);
        emit(BaseStatesErrorState(msg: response['message']));
      } else {
        debugPrint(response.toString());
        fileModel=FileModel.fromJson(response);
        emit(BaseStatesSuccessState());
      }
    } catch (e, s) {
      print("❌ Error: $e");
      print(s);
    }
  }

  Future<void> deleteFile({required int id}) async {
    emit(BaseStatesLoadingState2());
    try {
      Map<dynamic, dynamic> response = await myDio(
          endPoint: "${AppConfig.teacherFiles}/$id",
          dioType: DioType.delete);

      if (response['status'] == false) {
        debugPrint(response.toString());
        showToast(text: response['message'], state: ToastStates.error);
        emit(BaseStatesErrorState(msg: response['message']));
      } else {
        debugPrint(response.toString());
        showToast(text: response['message'], state: ToastStates.success);
        fileModel!.data!.items!.removeWhere((e)=>e.id==id);
        emit(BaseStatesSuccessState());
      }
    } catch (e, s) {
      print("❌ Error: $e");
      print(s);
    }
  }


}
