import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../../screen/common/splash/splash_screen.dart';
import '../local/app_cached.dart';
import '../local/app_config.dart';
import '../local/cache_helper.dart';
import '../utils/my_navigate.dart';

enum DioType { get, post, delete ,put}

myDio({required String endPoint,
  required DioType dioType,
  dynamic dioBody,
  String? token,
  String? lang}) async {
  Response? response;
  final connectivityResult = await (Connectivity().checkConnectivity());

  BaseOptions options = BaseOptions(
      connectTimeout: const Duration(seconds: 11),
      baseUrl: AppConfig.baseUrl,
      validateStatus: (int? status) => status! >= 200 && status <= 500,
      headers: {
        "Accept": "application/json",
        "Accept-Language": lang ?? navigatorKey.currentState!.context.locale.languageCode,
        'Authorization' : token != null ?"Bearer $token":
        CacheHelper.getData(key: AppCached.token) != null ? "Bearer ${CacheHelper.getData(key: AppCached.token)}":null,
      });
  if (connectivityResult == ConnectivityResult.none) {
    return responseMap(
        status: false,
        message: noInternet(navigatorKey.currentState!.context.locale.languageCode),
        data: null);
  } else {
    log(AppConfig.baseUrl+endPoint);
    try {
      if (dioType == DioType.get) {
        response = await Dio(options).get(
          endPoint,
          queryParameters: dioBody,
        ).catchError((onError) {
          return onError;
        });
      } else if (dioType == DioType.post) {
        response = await Dio(options).post(
          endPoint,
          data: dioBody,
        ).catchError((onError) {
          return onError;
        });
      }
      else if(dioType == DioType.delete){
        response = await Dio(options).delete(
          endPoint,
          data: dioBody,
        ).catchError((onError) {
          return onError;
        });
      }
      else if (dioType == DioType.put) {
        response = await Dio(options).put(
          endPoint,
          data: dioBody,
        )
            .catchError((onError) {
          return onError;
        });
      }
      debugPrint('Response is >>> ${response!.statusCode}');

      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        return responseMap(
            status: response.data['success'],
            message: response.data['message'],
            data: response.data['data']);
      } else if (response.statusCode! >= 500) {
        return responseMap(
            status: false, message: serverError(navigatorKey.currentState!.context.locale.languageCode));
      } else if (response.statusCode == 401 || response.statusCode == 302) {
        debugPrint(
            "-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
        CacheHelper.deleteData(key: AppCached.token);
        navigateAndFinish(widget: const SplashScreen());
      } else if (response.statusCode! >= 400 && response.statusCode! <= 499) {
        return responseMap(
            status: false,
            message: response.data['message'],
            data: response.data['data']);
      } else {
        return responseMap(
            status: false,
            message: globalError(navigatorKey.currentState!.context.locale.languageCode),
            data: null);
      }
    } catch (e) {
      debugPrint('global Dio Error Weak Internet $e');
      return responseMap(
          status: false,
          message: globalError(navigatorKey.currentState!.context.locale.languageCode),
          data: null);
    }
  }
}

String noInternet(String appLanguage) {
  return appLanguage == 'ar'
      ? 'لا يوجد انترنت , برجاء الاتصال بالانترنت أولا'
      : 'There is no internet, please connect to the internet first';
}

String globalError(String appLanguage) {
  return appLanguage == 'ar'
      ? ' حدث خطأ يرجي التأكد من الانترنت اولا !'
      : 'An error occurred, please check the internet first !';
}

String serverError(String appLanguage) {
  return appLanguage == 'ar'
      ? 'حدث خطأ بالسيرفر , برجاء مراجعه اداره التطبيق'
      : 'A server error occurred, please see the application administration';
}

Map<dynamic, dynamic> responseMap(
    {bool? status, String? message, dynamic data}) {
  return {"status": status, "message": message.toString(), "data": data};
}