import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:alfarid/core/widgets/empty_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/utils/images.dart';
import '../../../../../../../core/utils/size.dart';
import '../../../../../../../core/widgets/custom_loading.dart';
import '../../../../../../../generated/locale_keys.g.dart';
import '../../../chat_details/view/chat_details_screen.dart';
import '../../controller/chat_cubit.dart';
import '../../controller/chat_states.dart';
import 'chat_item.dart';

class ChatBody extends StatelessWidget {
  const ChatBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(),
      child: BlocBuilder<ChatCubit,ChatStates>(
        builder: (context,state) {
          ChatCubit cubit =BlocProvider.of(context);
          return SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  SizedBox(height: height*0.02),
                  Expanded(
                    child: Container(
                      margin: EdgeInsetsDirectional.symmetric(horizontal: width*0.06),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(AppRadius.r10),topLeft: Radius.circular(AppRadius.r10))
                      ),
                      child: StreamBuilder(
                          stream: cubit.fetchMyUsers(),
                          builder: (context,snapshot) {
                            if(snapshot.connectionState==ConnectionState.waiting){
                              return const CustomLoading(fullScreen: true,);
                            }else if(snapshot.hasError){
                              return  Center(child: Text("${LocaleKeys.error.tr()}${snapshot.error}"),);
                            }else if( !snapshot.hasData || snapshot.data!.isEmpty){
                              return  Center(child: EmptyList(img:AppImages.emptyChat,text: LocaleKeys.noChat.tr()),);
                            }else{
                              final users = snapshot.data!;
                              print("3333333333");
                              print(users);
                              return Padding(
                                padding: EdgeInsets.only(left: width*.05,right: width*.05,top: height*.03),
                                child: ListView.separated(
                                  itemBuilder: (context, index) => ChatItem(
                                    onTapItem: (){
                                      print(users[index]["id"]);
                                      print(users[index]["name"]);
                                      print(users[index]["image_url"]);
                                      navigateTo(widget:
                                      ChatDetailsScreen(id: users[index]["id"],receiverName:users[index]["name"] ,
                                        recImg: users[index]["image_url"]??"https://alfarid.tarmez.top/app/images/user.png",));
                                    },
                                    img: users[index]["image_url"] ?? "https://alfarid.tarmez.top/app/images/user.png",
                                    name: users[index]["name"],
                                    msg: users[index]["last_message"],
                                    time: users[index]["last_message_time"],
                                    msgCount: users[index]["msg_count"].toString(),
                                  ),
                                  separatorBuilder: (context, index) => SizedBox(height: height*.01,),
                                  itemCount: users.length,
                                ),
                              );
                            }

                          }
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
