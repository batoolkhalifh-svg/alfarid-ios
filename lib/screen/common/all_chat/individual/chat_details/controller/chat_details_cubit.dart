import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../../../core/local/app_cached.dart';
import '../../../../../../core/local/cache_helper.dart';
import '../../../../../../core/widgets/push_notification_service.dart';
import '../../../../../../generated/locale_keys.g.dart';
import 'chat_details_states.dart';

class ChatDetailsCubit extends Cubit<ChatDetailsStates>{
  ChatDetailsCubit():super(ChatDetailsInitState());


  TextEditingController msgCtrl=TextEditingController();
  List<Map<String, dynamic>> messagingList=[];
  /// ------------------------------- fetch cache ----------------------------------------
  String myId=CacheHelper.getData(key: AppCached.id).toString();
  String myName=CacheHelper.getData(key: AppCached.name);
  String myImg=CacheHelper.getData(key: AppCached.image);


  Future<void> deleteMessage({required int receiverId,required String messageId,required int myId}) async {
    String senderId=CacheHelper.getData(key: AppCached.role)==AppCached.teacher ?'user_id_t_$myId':'user_id_s_$myId';
    String receiverIdType=CacheHelper.getData(key: AppCached.role)==AppCached.teacher ?'receiver_id_s_$receiverId':'receiver_id_t_$receiverId';
    await FirebaseFirestore.instance.collection('users')
        .doc(senderId).collection('chats').doc(receiverIdType).collection('messages').doc(messageId)  // استخدام نفس messageId لحذف الوثيقة
        .delete();

  }
  int? msgCount;
  int? msgCountMe;

  Stream<List<Map<String, dynamic>>> fetchMessages({required String receiverId}) {
    String senderId=CacheHelper.getData(key: AppCached.role)==AppCached.teacher ?'user_id_t_$myId':'user_id_s_$myId';
    // String receiverIdType=CacheHelper.getData(key: AppCached.role)==AppCached.teacher ?'receiver_id_s_$receiverId':'receiver_id_t_$receiverId';
    print("5555555555");
    print(receiverId);
    markUnreadMessagesAsRead(receiverId);
    return FirebaseFirestore.instance.collection('users')
        .doc(senderId).collection('chats').doc('receiver_id_$receiverId').collection('messages').orderBy('time').snapshots().map((snapshot) {
      List<Map<String, dynamic>> messages = [];
      for (var doc in snapshot.docs) {
        var data = doc.data();
        if (data['isRead'] == false && data['sender_id'] != "${CacheHelper.getData(key: AppCached.role)==AppCached.teacher?"t_":"s_"}$myId") {
          doc.reference.update({"isRead": true});
        }
        messages.add(data);}
      return messages;});
  }
  Future<void> markUnreadMessagesAsRead(String receiverId) async {

    QuerySnapshot unreadMessages = await FirebaseFirestore.instance
        .collection('users')
        .doc('user_id_$receiverId')
        .collection('chats')
        .doc('receiver_id_$myId')
        .collection('messages')
        .where('isRead', isEqualTo: false)
        .get();
    // تحديث كل رسالة غير مقروءة إلى مقروءة
    for (var doc in unreadMessages.docs) {
      if (doc.data() != null ) {
        doc.reference.update({"isRead": true});
      }
    }
    var userChatDoc = FirebaseFirestore.instance.collection('users').doc('user_id_$myId').collection('chats').doc('receiver_id_$receiverId');
    userChatDoc.update({"msg_count":0});

  }
  /// number massage anRead
  Future<int> countMessagesAnRead({required String receiverId, required String id}) async {
    QuerySnapshot unreadMessages = await FirebaseFirestore.instance
        .collection('users')
        .doc('user_id_$receiverId')
        .collection('chats')
        .doc('receiver_id_$id')
        .collection('messages')
        .where('isRead', isEqualTo: false).where("sender_id" ,isEqualTo:"${CacheHelper.getData(key: AppCached.role)==AppCached.teacher?"s_":"t_"}$receiverId")
        .get();
    return unreadMessages.size;
  }



  Future<void> sendMessage({required String recId, required String recName, required BuildContext context}) async {
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

    countMessagesAnRead(receiverId: recId,id: myId).then((value) {
      msgCount=value;

    },);
    countMessagesAnRead(id: recId,receiverId:myId ).then((value) {
      msgCountMe=value;

    },);
    try {
      String? messageContent = msgCtrl.text;
      msgCtrl.clear();

      final newMessage = {
        "sender_id": "${CacheHelper.getData(key: AppCached.role)==AppCached.teacher?"t_":"s_"}$myId" ,
        "message": messageContent,
        "time": DateTime.now().toString(),
        "isRead": false,
        "messageId": messageId,
      };

      final userChatDoc = FirebaseFirestore.instance.collection('users').doc('user_id_${CacheHelper.getData(key: AppCached.role)==AppCached.teacher?"t_":"s_"}$myId').collection('chats').doc('receiver_id_$recId');
      final receiverChatDoc = FirebaseFirestore.instance.collection('users').doc('user_id_$recId').collection('chats').doc('receiver_id_${CacheHelper.getData(key: AppCached.role)==AppCached.teacher?"t_":"s_"}$myId');

      // إضافة الرسالة في مجموعات الدردشة للمُرسل والمستقبل
      await Future.wait([
        userChatDoc.collection('messages').doc(messageId).set(newMessage),
        receiverChatDoc.collection('messages').doc(messageId).set(newMessage),
      ]);

      final chatSummary = {
        'id':recId ,
        'name': recName,
        'image_url': recImg,
        "last_message_time": DateTime.now().toString(),
        "last_message": messageContent,
        "msg_count": msgCount,
      };

      DocumentSnapshot<Map<String, dynamic>> receiverCollection = await FirebaseFirestore.instance.collection('users').doc('user_id_$recId').get();

      await Future.wait([
        userChatDoc.set(chatSummary),
        receiverChatDoc.set({
          'id': CacheHelper.getData(key: AppCached.role)==AppCached.teacher? 't_$myId':'s_$myId',
          'name': myName,
          'image_url': myImg,
          "last_message_time": DateTime.now().toString(),
          "last_message": messageContent,
          "msg_count": msgCountMe,
        }),
        markUnreadMessagesAsRead(recId),
        // إرسال إشعار للمستقبل
       /* PushNotificationsService.sendNotification(
          msg: messageContent,
          token: receiverCollection["fire_token"],
          name: myName,
        ),*/
      ]);
      FocusScope.of(context).unfocus();
      scrollToBottom();
    } catch (e) {
      emit(ChatDetailsFailedState(error: e.toString()));
    }
  }

// دالة للتحقق من الاتصال بالإنترنت
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