import 'dart:io';
import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/remote/my_dio.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../main.dart';
import 'package:http_parser/http_parser.dart';


class UploadFileCubit extends Cubit<BaseStates> {
  UploadFileCubit() : super(BaseStatesInitState());

  static UploadFileCubit get(context) => BlocProvider.of(context);

  TextEditingController nameFileController = TextEditingController();

  ///type is image | file
  List fileTypeList=[
    {"id":'image',"name":LocaleKeys.image.tr()},
    {"id":'file',"name":LocaleKeys.file.tr()}
  ];

  String? dropdownType;
  changeDropdownType({required String id}){
    dropdownType=id;
    pickFile();
    emit(BaseStatesChangeState());
  }

  File? selectedFile;
  String? fileType;
  String fileName = "file.pdf";

  Future<void> pickFile() async {
    selectedFile=null;
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions:dropdownType=='image'?['jpeg', 'png', 'jpg', 'gif', 'svg']:['pdf','docx','xlsx'],);
    if (result != null) {
      String? path = result.files.single.path;
      selectedFile = File(path!);
      fileType = result.files.single.extension;
      fileName = result.files.single.name;
      emit(BaseStatesChangeState());
    }
  }


  Future<void> openPDFOrImage() async {
       File? localFile;
      localFile = File(selectedFile!.path);

    if (localFile.path.endsWith("pdf") ) {
      await OpenFile.open(localFile.path);
    } else {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => AlertDialog(
          content: Image.file(localFile!),
        ),
      );
    }
  }


  Future<void> createFile() async {
    emit(BaseStatesLoadingState());
    try {
      String? mimeType = lookupMimeType(selectedFile!.path);
      print("🖼️ Detected MIME Type: $mimeType"); // طباعة نوع الملف الفعلي

      final body = FormData.fromMap({
        "name": nameFileController.text,
        "type": dropdownType,
        "file": selectedFile == null ? null : await MultipartFile.fromFile(selectedFile!.path, filename: fileName, contentType: mimeType != null ? MediaType.parse(mimeType) : null, // تعيين نوع المحتوى
        ),
      });
      Map<dynamic, dynamic> response = await myDio(
          dioBody: body,
          endPoint: AppConfig.teacherFiles,
          dioType: DioType.post);

      if (response['status'] == false) {
        debugPrint(response.toString());
        showToast(text: response['message'], state: ToastStates.error);
        emit(BaseStatesErrorState(msg: response['message']));
      } else {
        debugPrint(response.toString());
        showToast(text: response['message'], state: ToastStates.success);
        navigatorPop();
        emit(BaseStatesSuccessState());
      }
    } catch (e, s) {
      print("❌ Error: $e");
      print(s);
    }
  }}
