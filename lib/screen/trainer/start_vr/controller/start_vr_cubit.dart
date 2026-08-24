import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'start_vr_states.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/remote/my_dio.dart';
import '../model/student_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../core/local/cache_helper.dart';

class StartVrCubit extends Cubit<StartVrStates> {
  StartVrCubit() : super(StartVrInitialState());

  StudentsModel? studentsModel;

  List<DataS> selectedStudent = [];

  List<int> selectedId = [];

  static StartVrCubit get(context) => BlocProvider.of(context);

  final TextEditingController titleController = TextEditingController();

  final TextEditingController dateController = TextEditingController();

  final TextEditingController timeController = TextEditingController();

  final TextEditingController notesController = TextEditingController();

  final List<String> subjects = [
    "الكيمياء",
    "الفيزياء",
    "الأحياء",
    "الرياضيات",
    "الجغرافيا",
  ];

  final Map<String, List<String>> labs = {
    "الكيمياء": [
      "الذرات والجزيئات",
      "التفاعلات الكيميائية",
      "الجدول الدوري",
    ],
    "الفيزياء": [
      "الحركة والقوى",
      "الكهرباء",
      "الضوء",
    ],
    "الأحياء": [
      "الخلية",
      "جسم الإنسان",
      "المجهر",
    ],
    "الرياضيات": [
      "الهندسة ثلاثية الأبعاد",
      "الأشكال الهندسية",
      "الإحداثيات",
    ],
    "الجغرافيا": [
      "الكرة الأرضية",
      "التضاريس",
      "النظام الشمسي",
    ],
  };

  String? selectedSubject;
  String? selectedLab;
  String? vrModel;

  void selectSubject(String? value) {
    selectedSubject = value;
    selectedLab = null;

    emit(StartVrChangeState());
  }

  void selectLab(String? value) {
    selectedLab = value;

    switch (value) {

    // الكيمياء
      case "الذرات والجزيئات":
        vrModel = "atoms";
        break;

      case "التفاعلات الكيميائية":
        vrModel = "chemical_reactions";
        break;

      case "الجدول الدوري":
        vrModel = "periodic_table";
        break;

    // الفيزياء
      case "الحركة والقوى":
        vrModel = "motion";
        break;

      case "الكهرباء":
        vrModel = "electricity";
        break;

      case "الضوء":
        vrModel = "light";
        break;

    // الأحياء
      case "الخلية":
        vrModel = "cell";
        break;

      case "جسم الإنسان":
        vrModel = "human_body";
        break;

      case "المجهر":
        vrModel = "microscope";
        break;

    // الرياضيات
      case "الهندسة ثلاثية الأبعاد":
        vrModel = "geometry3d";
        break;

      case "الأشكال الهندسية":
        vrModel = "shapes";
        break;

      case "الإحداثيات":
        vrModel = "coordinates";
        break;

    // الجغرافيا
      case "الكرة الأرضية":
        vrModel = "earth";
        break;

      case "التضاريس":
        vrModel = "terrain";
        break;

      case "النظام الشمسي":
        vrModel = "solar_system";
        break;

      default:
        vrModel = null;
    }

    emit(StartVrChangeState());
  }

  void selectVrModel(String value) {
    vrModel = value;

    emit(StartVrChangeState());
  }

  DateTime? date;

  void selectDate(DateTime value) {
    date = value;

    dateController.text =
    "${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}";

    emit(StartVrChangeState());
  }

  String formatTimeOfDay(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');

    return "$hours:$minutes";
  }

  void selectTime(TimeOfDay value) {
    timeController.text = formatTimeOfDay(value);

    emit(StartVrChangeState());
  }

  void addSelectedList(List<DataS> list) {
    selectedStudent = list;

    selectedId = [];

    for (final student in list) {
      selectedId.add(student.id!);
    }

    emit(StartVrChangeState());
  }

  Future<void> fetchStudents() async {
    emit(StartVrLoadingState());

    try {
      Map<dynamic, dynamic> response = await myDio(
        endPoint: AppConfig.tStudents,
        dioType: DioType.get,
      );

      if (response["status"] == true) {
        studentsModel = StudentsModel.fromJson(response);

        emit(StartVrSuccessState());
      } else {
        emit(StartVrErrorState(response["message"]));
      }
    } catch (e) {
      emit(StartVrErrorState(e.toString()));
    }
  }

  bool validateVrLive() {
    print("title = ${titleController.text}");
    print("subject = $selectedSubject");
    print("lab = $selectedLab");
    print("vrModel = $vrModel");
    print("date = $date");
    print("time = ${timeController.text}");
    print("students = $selectedId");

    if (titleController.text.isEmpty) {
      return false;
    }

    if (selectedSubject == null) {
      return false;
    }

    if (selectedLab == null) {
      return false;
    }

    if (vrModel == null) {
      return false;
    }

    if (date == null) {
      return false;
    }

    if (timeController.text.isEmpty) {
      return false;
    }

    if (selectedId.isEmpty) {
      return false;
    }

    return true;
  }

  Map<String, dynamic> getVrLiveData() {
    return {
      "name": titleController.text,

      "type": "vr",

      "vr_model": vrModel,

      "subject": selectedSubject,

      "lab_name": selectedLab,

      "date": dateController.text,

      "time": timeController.text,

      "notes": notesController.text,

      "student_ids": selectedId,
    };
  }

  Future<void> createVrLive() async {
    print("createVrLive");

    print("validate = ${validateVrLive()}");

    if (!validateVrLive()) {
      emit(StartVrErrorState("يرجى تعبئة جميع الحقول"));
      return;
    }

    emit(StartVrLoadingState());

    try {
      final response = await myDio(
        endPoint: AppConfig.liveStream,
        dioType: DioType.post,
        dioBody: getVrLiveData(),
      );

      if (response["status"] == true) {

        /*
        |--------------------------------------------------------------------------
        | الحصول على بيانات الحصة التي أنشأها Laravel
        |--------------------------------------------------------------------------
        */

        final livestream = response["data"]["livestream"];

        /*
        |--------------------------------------------------------------------------
        | رابط Jitsi الذي أنشأه Laravel
        |--------------------------------------------------------------------------
        */

        final String jitsiUrl = livestream["url"];

        print("VR Livestream ID: ${livestream["id"]}");

        print("Jitsi URL: $jitsiUrl");

        /*
        |--------------------------------------------------------------------------
        | حفظ بيانات VR في Firestore
        |--------------------------------------------------------------------------
        */

        await FirebaseFirestore.instance
            .collection('lives')
            .doc()
            .set({

          "type": "vr",

          "active": false,

          "finished": false,

          "live_name": titleController.text,

          "teacher_name":
          CacheHelper.getData(key: AppCached.name),

          "teacher_photo":
          CacheHelper.getData(key: AppCached.image),

          "date": dateController.text,

          "time": timeController.text,

          "details": notesController.text,

          "subject": selectedSubject,

          "lab_name": selectedLab,

          "vr_model": vrModel,

          "slug": vrModel,

          /*
          |--------------------------------------------------------------------------
          | رابط مختبر VR
          |--------------------------------------------------------------------------
          */

          "link":
          "https://alfarid.info/vr/$vrModel.html",

          /*
          |--------------------------------------------------------------------------
          | رابط Jitsi للصوت والصورة
          |--------------------------------------------------------------------------
          */

          "url": jitsiUrl,

          /*
          |--------------------------------------------------------------------------
          | رقم الحصة من Laravel
          |--------------------------------------------------------------------------
          */

          "livestream_id": livestream["id"],

          "user_id":
          CacheHelper.getData(key: AppCached.id).toString(),

          "student_ids": selectedId,
        });

        emit(StartVrSuccessState());

      } else {

        emit(
          StartVrErrorState(
            response["message"],
          ),
        );
      }

    } catch (e) {

      print("Create VR Error: $e");

      emit(
        StartVrErrorState(
          e.toString(),
        ),
      );
    }
  }
}