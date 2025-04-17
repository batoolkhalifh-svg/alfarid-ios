import 'package:alfarid/core/local/app_cached.dart';
import 'package:alfarid/core/local/cache_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/utils/colors.dart';
import '../../../../../../../core/utils/my_navigate.dart';
import '../../../../../../../core/utils/size.dart';
import '../../../../../../../core/widgets/base_state.dart';
import '../../../../../../../core/widgets/custom_loading.dart';
import '../../../../../../../generated/locale_keys.g.dart';
import '../../../../individual/chat/view/widgets/chat_item.dart';
import '../../../chat_details_group/view/chat_details_group_screen.dart';
import '../../../../../../trainer/home_teacher/view/widgets/custom_blue_btn.dart';
import '../../controller/chat_teacher_cubit.dart';
import 'create_group_alert.dart';
import 'empty_group_chat.dart';


class GroupChatBody extends StatelessWidget {
  const GroupChatBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatTeacherCubit,BaseStates>(
        builder: (context,state) {
          ChatTeacherCubit cubit =BlocProvider.of(context);
          return SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: height*.02),
                    width: width,
                    height: 1,
                    color: AppColors.grayColor.withOpacity(.1),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsetsDirectional.symmetric(horizontal: width*0.06),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(AppRadius.r10),topLeft: Radius.circular(AppRadius.r10))
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: StreamBuilder(
                                stream: CacheHelper.getData(key: AppCached.role)==AppCached.student?cubit.fetchStudentGroups():cubit.getTeacherGroups(),
                                builder: (context,snapshot) {
                                  if(snapshot.connectionState==ConnectionState.waiting){
                                    return const CustomLoading(fullScreen: true,);
                                  }else if(snapshot.hasError){
                                    return  Center(child: Text("${LocaleKeys.error.tr()}${snapshot.error}"),);
                                  }else if( !snapshot.hasData || snapshot.data!.isEmpty){
                                    return CacheHelper.getData(key: AppCached.role)==AppCached.teacher?
                                      EmptyGroupChat(onTap: (){
                                      showDialog(context: context, builder: (ctx) {return BlocProvider.value(value: context.read<ChatTeacherCubit>(), child: const CreateGroupAlert());});
                                    }, isTeacher: true,):const EmptyGroupChat(isTeacher: false);
                                  }else{
                                    final groups  = snapshot.data!;
                                    print("3333333333");
                                    print(groups);
                                    return Padding(
                                      padding: EdgeInsets.only(left: width*.05,right: width*.05,top: height*.03),
                                      child: ListView.separated(
                                        itemBuilder: (context, index) => ChatItem(
                                          onTapItem: (){
                                            print("22222222222222");
                                            print( groups[index]["groupId"]);
                                            navigateTo(widget:  ChatDetailsGroupScreen(id: groups[index]["groupId"],receiverName:groups[index]["groupName"]));
                                          },
                                          name: groups[index]["groupName"],
                                          msg: groups[index]["last_message"]??"",
                                          time: groups[index]["last_message_time"] ??'',
                                          msgCount: "0",
                                        ),
                                        separatorBuilder: (context, index) => SizedBox(height: height*.01,),
                                        itemCount: groups.length,
                                      ),
                                    );
                                  }

                                }
                            ),
                          ),
                          CacheHelper.getData(key: AppCached.role)==AppCached.student?const SizedBox.shrink():
                          cubit.showBtn==true?
                          Padding(
                            padding:EdgeInsetsDirectional.only(bottom: width*0.02,end: width*0.02),
                            child: Align(
                              alignment: AlignmentDirectional.topEnd,
                              child: CustomBlueButton(text: LocaleKeys.startNewGroup.tr(),onTap: (){
                                showDialog(context: context, builder: (ctx)
                                {return BlocProvider.value(value: context.read<ChatTeacherCubit>(), child: const CreateGroupAlert());});
                              }),
                            ),
                          ):const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),


                ],
              ),
            ),
          );
        }
    );
  }
}
