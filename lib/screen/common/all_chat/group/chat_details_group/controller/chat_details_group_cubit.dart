import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../../../core/local/app_cached.dart';
import '../../../../../../core/local/cache_helper.dart';
import '../../../../../../generated/locale_keys.g.dart';
import 'chat_details_states.dart';




class ChatDetailsGroupCubit extends Cubit<ChatDetailsStates>{
  ChatDetailsGroupCubit():super(ChatDetailsStates());


  TextEditingController msgCtrl=TextEditingController();
  List<Map<String, dynamic>> messagingList=[];
  /// ------------------------------- fetch cache ----------------------------------------
  int myId=CacheHelper.getData(key: AppCached.id);
  String myName=CacheHelper.getData(key: AppCached.name);
  String myImg=CacheHelper.getData(key: AppCached.image);



  int? msgCount;
  int? msgCountMe;

  Stream<List<Map<String, dynamic>>> fetchGroupMessages({required String groupId}) {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('time') // ترتيب الرسائل حسب الوقت
        .snapshots()
        .map((snapshot) {
      List<Map<String, dynamic>> messages = [];
      for (var doc in snapshot.docs) {
        var data = doc.data();
        if (data['isRead'] == false && data['sender_id'] != myId) {
          doc.reference.update({"isRead": true});
        }
        messages.add(data);
      }
      return messages;
    });
  }


  Future<void> sendGroupMessage({required String groupId, required BuildContext context,}) async {
    bool isConnected = await checkInternetConnection();
    if (isConnected==true) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(LocaleKeys.noInternet.tr()),
            content: Text(LocaleKeys.noChat.tr()),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();},
                child: Text(LocaleKeys.ok.tr()),
              ),
            ],
          );
        },
      );
      return;
    }

    var uuid = const Uuid();
    String messageId = uuid.v4();

    try {
      String? messageContent = msgCtrl.text;
      msgCtrl.clear();

      // إنشاء الرسالة الجديدة
      final newMessage = {
        "sender_id":"${CacheHelper.getData(key: AppCached.role)==AppCached.teacher?"t_":"s_"}$myId",
        "sender_name": myName,
        "message": messageContent,
        "time": DateTime.now().toString(),
        "isRead": false,
        "messageId": messageId,
      };

      final groupChatDoc = FirebaseFirestore.instance.collection('groups').doc(groupId);
      await groupChatDoc.collection('messages').doc(messageId).set(newMessage);

      final groupSummary = {
        "last_message": messageContent,
        "last_message_time": DateTime.now().toString(),
      };

      await groupChatDoc.update(groupSummary);

      FocusScope.of(context).unfocus();
      scrollToBottom();
    } catch (e) {
      emit(ChatDetailsFailedState(error: e.toString()));
    }
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult.first == ConnectivityResult.none;
  }

  /// ------------------------------- scroll to bottom of chat ---------------------------
  ScrollController scrollCtrl = ScrollController();
  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollCtrl.hasClients) {
        scrollCtrl.animateTo(
          scrollCtrl.position.extentTotal+1500,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }

    });

  }
  String? recImg;
  /// ------------------------------- get user status online/offline ---------------------
  Stream<Map<String, dynamic>> getUserOnlineStatus({required int receiverId}) {
    return FirebaseFirestore.instance.collection('users').doc('user_id_${CacheHelper.getData(key: AppCached.role)==AppCached.teacher?"t_":"s_"}$receiverId').snapshots()
        .map((snapshot) {
      return snapshot.data() ?? {}; // Returns all fields in the document
    });
  }
  @override
  Future<void> close() {
    scrollCtrl.dispose();
    return super.close();
  }
}