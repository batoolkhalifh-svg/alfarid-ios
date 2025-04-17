import 'package:hive_flutter/hive_flutter.dart';

class CacheHelper {

  static var hive = Hive.box("AppData");

  static Future<void> initCache() async {
    await Hive.openBox("AppData");
  }

  static saveData({required String key, required dynamic value}) async {
    await hive.put(key, value);
  }

  static dynamic getData({required String key}) {
    return hive.get(key);
  }

  static  dynamic deleteData({required String key}) {
    return hive.delete(key);
  }

}