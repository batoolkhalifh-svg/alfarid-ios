import 'package:flutter/material.dart';

import 'widgets/chat_details_body_group.dart';

class ChatDetailsGroupScreen extends StatelessWidget {
  const ChatDetailsGroupScreen({super.key, required this.id, required this.receiverName});
  final String id;
  final String receiverName;


  @override
  Widget build(BuildContext context) {
    return  ChatDetailsGroupBody(id: id,receiverName: receiverName);
  }
}
