
import 'package:alfarid/core/utils/size.dart';
import 'package:alfarid/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/utils/colors.dart';
import '../../../../../../../core/widgets/base_state.dart';
import '../../../../../../../core/widgets/custom_arrow.dart';
import '../../../../individual/chat/view/chat_screens.dart';
import '../../../../../../student/teacher_profile/view/widgets/tab_item.dart';
import '../../controller/chat_teacher_cubit.dart';
import 'group_chat.dart';

class ChatTeacherBody extends StatelessWidget {
  const ChatTeacherBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<ChatTeacherCubit>(
          create: (context) => ChatTeacherCubit()..fetchStudents(),
          child: BlocBuilder<ChatTeacherCubit, BaseStates>(
              builder: (context, state) {
            var cubit = ChatTeacherCubit.get(context);
            return SafeArea(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomArrow(text: LocaleKeys.messages.tr(),withArrow: false),
                  Expanded(
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: width*0.02,vertical: width*0.038),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                                children:[
                                  TabItem(
                                    onTap: (){
                                      cubit.changeTabs(0);
                                    },
                                    title: LocaleKeys.individualChat.tr(),
                                    isSelected: cubit.tab==0 ? true :false,),
                                  const Spacer(),
                                  TabItem(
                                    onTap: (){
                                      cubit.changeTabs(1);
                                    },
                                    title: LocaleKeys.groupChat.tr(),isSelected: cubit.tab==1 ? true :false,),
                                ]
                            ),
                            Container(
                              height: 1,
                              width: width,
                              color: AppColors.grayColor,
                            ),
                        
                            SizedBox(
                              height: height*0.722,
                              child: cubit.tab==0 ?const  ChatScreens(): BlocProvider.value(value: context.read<ChatTeacherCubit>(), child:  const GroupChatBody()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )


                ],
            ));
          })),
    );
  }
}
