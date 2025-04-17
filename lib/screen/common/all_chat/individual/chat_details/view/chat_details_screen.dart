import 'package:alfarid/screen/common/all_chat/individual/chat_details/view/widgets/chat_details_body.dart';
import 'package:flutter/material.dart';

class ChatDetailsScreen extends StatelessWidget {
  const ChatDetailsScreen({super.key, required this.id, required this.receiverName, required this.recImg});
  final String id;
  final String receiverName;
  final String recImg;


  @override
  Widget build(BuildContext context) {
    return  ChatDetailsBody(id: id,receiverName: receiverName,recImg: recImg);
  }
}
