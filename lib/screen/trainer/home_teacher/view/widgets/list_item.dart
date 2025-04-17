import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../order_details/view/order_details_screen.dart';
import 'custom_blue_btn.dart';

class ListItem extends StatelessWidget {
  final int id;
  final String image, name,classRoom,status;
  final Function()? onTapAccept;
  const ListItem({super.key, required this.id, required this.image, required this.name, required this.classRoom, this.onTapAccept, required this.status});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){navigateTo(widget: OrderDetailsScreen(id: id));},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: width*0.02,vertical: width*0.02),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.r15)
        ),
        child: Row(
          children: [
            CircleAvatar(
                radius: AppRadius.r30,
                backgroundImage:  NetworkImage(image)
            ),
            SizedBox(width: width*0.02),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,style: Styles.textStyle14.copyWith(color: AppColors.mainColor,)),
                SizedBox(height: width*0.01),
                Text(classRoom,style: Styles.textStyle12.copyWith(color: AppColors.blackColor2,fontFamily: AppFonts.mulishExtraBold,fontWeight: FontWeight.bold)),
              ],
            ),
            const Spacer(),
            CustomBlueButton(text:status =="accepted"? LocaleKeys.acceptedOrder.tr():status=="rejected"?LocaleKeys.rejectedOrder.tr():LocaleKeys.waitingOrder.tr(),onTap: onTapAccept,
            isRed: status=="rejected"? true:false,)
          ],
        ),
      ),
    );
  }
}
