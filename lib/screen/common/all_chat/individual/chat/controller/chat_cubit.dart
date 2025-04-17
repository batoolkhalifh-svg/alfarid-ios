
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/local/app_cached.dart';
import '../../../../../../core/local/cache_helper.dart';
import 'chat_states.dart';


class ChatCubit extends Cubit<ChatStates>{
  ChatCubit():super(ChatStates());



  int id=CacheHelper.getData(key: AppCached.id);

  Stream<List<Map<String, dynamic>>> fetchMyUsers() {
    String typeId=CacheHelper.getData(key: AppCached.role)==AppCached.teacher?'user_id_t_$id':'user_id_s_$id';
    return FirebaseFirestore.instance.collection("users").doc(typeId).collection("chats").orderBy("last_message_time",descending: true).snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      return doc.data();
    }).toList());
  }

}

