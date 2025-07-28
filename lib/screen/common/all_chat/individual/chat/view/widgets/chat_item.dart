import 'package:alfarid/core/utils/images.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/utils/colors.dart';
import '../../../../../../../core/utils/size.dart';
import '../../../../../../../core/utils/styles.dart';


class ChatItem extends StatelessWidget {
  const ChatItem({super.key,  this.img,  required this.name, required this.msg, required this.time, required this.onTapItem, required this.msgCount});
  final String? img;
  final String name;
  final String msg;
  final String time;
  final String msgCount;
  final Function() onTapItem;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapItem,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
            radius: AppRadius.r28,
             backgroundColor: Colors.transparent,
             backgroundImage:img==null?const AssetImage(AppImages.groupImg): NetworkImage(img!),
      ),
              SizedBox(width:width*.02),
              Expanded(
                child: Column(
                  crossAxisAlignment:msg==''?CrossAxisAlignment.center:CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: width*.45,
                      child: Text(name,style: Styles.textStyle14.copyWith(
                        color: AppColors.blackColor2,
                        fontFamily: AppFonts.almaraiRegular
                      ),overflow: TextOverflow.ellipsis),
                    ),
                    msg==''?const SizedBox.shrink():SizedBox(height: height*.01,),
                    msg==''?const SizedBox.shrink():
                    SizedBox(
                      width: width*.45,
                      child: Text(msg,style: Styles.textStyle12,overflow: TextOverflow.ellipsis,))
                  ],
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  time==''?const SizedBox.shrink():
                  Text(TimeOfDay.fromDateTime(DateTime.parse(time)).format(context),style: Styles.textStyle12.copyWith(
                    color: AppColors.mainColor,
                    fontFamily: AppFonts.iBMPlexSansArabicRegular
                  ),),
                  SizedBox(height: height*.01,),
                  msgCount=="0"?const SizedBox.shrink():
                      msgCount=="null"?const SizedBox.shrink():
                  CircleAvatar(
                    radius: AppRadius.r10,
                    backgroundColor: AppColors.mainColor,
                    child: Text(msgCount,style: Styles.textStyle10.copyWith(
                        color: Colors.white
                    ),),
                  )

                ],
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: height*.02),
            width: width,
            height: 1,
            color: AppColors.grayColor.withOpacity(.4),
          ),
        ],
      ),
    );
  }
}
