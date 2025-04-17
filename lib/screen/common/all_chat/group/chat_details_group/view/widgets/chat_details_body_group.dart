import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../../../core/local/app_cached.dart';
import '../../../../../../../core/local/cache_helper.dart';
import '../../../../../../../core/utils/images.dart';
import '../../../../../../../core/utils/size.dart';
import '../../../../../../../core/widgets/custom_arrow.dart';
import '../../../../../../../core/widgets/custom_textfield.dart';
import '../../../../../../../generated/locale_keys.g.dart';
import '../../../../individual/chat_details/view/widgets/chat_message_item.dart';
import '../../controller/chat_details_group_cubit.dart';
import '../../controller/chat_details_states.dart';

class ChatDetailsGroupBody extends StatelessWidget {
  const ChatDetailsGroupBody({super.key, required this.id, required this.receiverName});
  final String id;
  final String receiverName;


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatDetailsGroupCubit(),
      child: BlocBuilder<ChatDetailsGroupCubit,ChatDetailsStates>(
        builder: (context,state) {
          ChatDetailsGroupCubit cubit =BlocProvider.of(context);
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  CustomArrow(text: LocaleKeys.messages.tr(),),
                  Expanded(
                    child: StreamBuilder<List<Map<String, dynamic>>>(
                      stream: cubit.fetchGroupMessages(groupId: id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text("${LocaleKeys.error.tr()} ${snapshot.error}"));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return  Center(child: Text(LocaleKeys.noMessageYet.tr()));
                        } else {
                          final messages = snapshot.data!;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            cubit.scrollToBottom();

                          });
                          return ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: width*0.06),
                            controller: cubit.scrollCtrl,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              final isMeChatting = message["sender_id"] == "${CacheHelper.getData(key: AppCached.role)==AppCached.teacher?"t_":"s_"}${cubit.myId}";
                              final isRead = message["isRead"] ?? false;

                              return ChatMessageItem(
                                tap:() {
                                  // cubit.deleteMessage(messageId:  message["messageId"],myId: CacheHelper.getData(key: AppCached.id), receiverId: id);
                                  // cubit.deleteMessage(messageId:  message["messageId"],receiverId: CacheHelper.getData(key: AppCached.id), myId: id);
                                  // navigatorPop();
                                } ,
                                isMeChatting: isMeChatting,
                                messageBody: message["message"],
                                time: "",
                                isRead: isRead, // تمرير حالة القراءة


                              );
                            },
                          );
                        }
                      },
                    ),
                  ),

                  Padding(
                    padding:EdgeInsets.symmetric(horizontal: width*0.058),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            type: TextInputType.text,
                            ctrl: cubit.msgCtrl,
                            suffixIcon: InkWell(
                                onTap: () {
                                  if (cubit.msgCtrl.text.isNotEmpty) {
                                    cubit.sendGroupMessage(groupId: id, context: context,);
                                  }
                                },
                                child: SvgPicture.asset(AppImages.sendIcn,height: height*.035,width: width*.035,fit: BoxFit.scaleDown,)),
                            hint: LocaleKeys.writeMsgHere.tr(),
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: height*.02,)
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
