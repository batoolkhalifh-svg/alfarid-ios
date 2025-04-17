import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/utils/colors.dart';
import '../../../../../../../core/utils/images.dart';
import '../../../../../../../core/utils/size.dart';
import '../../../../../../../core/utils/styles.dart';



class ChatMessageItem extends StatelessWidget {

  final bool isMeChatting;
  final Function() tap;
  final String messageBody , time;
  final String? img;
  final bool isRead;// إضافة حالة القراءة


  const ChatMessageItem({super.key,  required this.isMeChatting,  required this.messageBody,  this.img, required this.time,  this.isRead=false, required this.tap,});

  @override

  Widget build(BuildContext context) {

    return GestureDetector(
      onLongPress:() {
        // !isMeChatting?null:
        // showCupertinoModalPopup(context: context,
        //   barrierColor: Colors.transparent,
        //   builder: (context) => Container(
        //       color: Colors.transparent,
        //       padding: EdgeInsets.symmetric(vertical: height * .02, horizontal: width * .05),
        //       width: width,
        //       child: Column(
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             Row(
        //               children: [
        //                 Expanded(
        //                   child: CustomButton(
        //                       title: LocaleKeys.deleteMessage.tr(),
        //                       onTap: tap,
        //                       type: BtnType.withBorder,
        //                     deleteMessage: true,
        //
        //                   ),
        //                 ),
        //               ],
        //             ),])),);
      } ,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: height*0.01),
        child: Align(
          alignment: context.locale.languageCode == "ar"
              ? (!isMeChatting ? Alignment.centerLeft : Alignment.centerRight)
              : (!isMeChatting ? Alignment.centerRight : Alignment.centerLeft),
          child: SizedBox(
            width: width * .9,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment:
              !isMeChatting ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment:!isMeChatting? CrossAxisAlignment.end: CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: width * .8),
                      padding: EdgeInsets.all(width*0.025),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight:  Radius.circular(AppRadius.r20),
                            bottomRight: context.locale.languageCode == "ar" ?
                            (!isMeChatting ?  Radius.circular(AppRadius.r20) : const Radius.circular(0))
                            : (!isMeChatting ? const Radius.circular(0) :  Radius.circular(AppRadius.r20)),
                            topLeft:  Radius.circular(AppRadius.r20),
                            bottomLeft: context.locale.languageCode == "ar" ?
                            (!isMeChatting ? const Radius.circular(0) :  Radius.circular(AppRadius.r20))
                            : (!isMeChatting ?  Radius.circular(AppRadius.r20) : const Radius.circular(0))),
                        color:  !isMeChatting ? Colors.white : AppColors.myChatColor,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: width * .6,),
                                  child: Text(messageBody, style: Styles.textStyle14.copyWith(color: !isMeChatting ? AppColors.blackColor : AppColors.mainColor,fontFamily: AppFonts.almaraiRegular))),
                              // SizedBox(
                              //   height: height*.005,
                              // ),
                              // isMeChatting?
                              // SizedBox(child: Icon(Icons.done_all_rounded,size: 16,color: isRead ?Colors.blue:Colors.grey,)):const SizedBox.shrink()
                            ],
                          ),

                        ],
                      ),
                    ),
                    SizedBox(
                        width: width*0.6,
                        child: Text(time,maxLines: 1,)),
                  ],
                ),
                !isMeChatting
                    ? SizedBox(width: width * .03,)
                    : const SizedBox.shrink(),
                !isMeChatting
                    ?  CircleAvatar(
                  radius: 27,
                  backgroundImage:img==null?const AssetImage(AppImages.groupImg): NetworkImage(img!,),
                )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
