import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../local/app_cached.dart';
import '../local/cache_helper.dart';


class UserStatusService with WidgetsBindingObserver {
  static final UserStatusService _instance = UserStatusService._internal();
  // late String _userId;

  factory UserStatusService() {
    return _instance;
  }

  UserStatusService._internal();

  void init() {
    // _userId = userId;
    WidgetsBinding.instance.addObserver(this);
    _setUserOnlineStatus(true);

  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  void _setUserOnlineStatus(bool isOnline) async {
    String typeId=CacheHelper.getData(key: AppCached.role)==AppCached.teacher?'user_id_t_${CacheHelper.getData(key: AppCached.id)}':'user_id_s_${CacheHelper.getData(key: AppCached.id)}';
    final docRef = FirebaseFirestore.instance.collection("users").doc(typeId);
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      await docRef.update({
        'is_online': isOnline,
        'lastSeen': DateTime.now().toString(),
      });
     }
    // else {
    //   await docRef.set({
    //     'is_online': isOnline,
    //     'lastSeen': DateTime.now().toString(),
    //   });
    // }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _setUserOnlineStatus(false);
    } else if (state == AppLifecycleState.resumed) {
      _setUserOnlineStatus(true);
    }
  }
}
