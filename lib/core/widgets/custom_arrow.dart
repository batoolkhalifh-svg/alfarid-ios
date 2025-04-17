import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../main.dart';
import '../utils/colors.dart';
import '../utils/images.dart';
import '../utils/my_navigate.dart';
import '../utils/size.dart';
import '../utils/styles.dart';

class CustomArrow extends StatelessWidget {
  final String text;
  final bool? withArrow;
  const CustomArrow({super.key, required this.text, this.withArrow=true});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.symmetric(horizontal: width*0.07,vertical: width*0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          withArrow==false? const SizedBox.shrink():
          GestureDetector(
              onTap:(){
                FocusScope.of(context).unfocus();
                navigatorPop();},
              child: SvgPicture.asset(navigatorKey.currentContext!.locale.languageCode=="ar"?AppImages.arrow:AppImages.arrow2,width: width*0.055,)),
          Expanded(child: Center(child: Text(text,style: Styles.textStyle14.copyWith(color: AppColors.blackColor),textAlign: TextAlign.center,))),          SizedBox(width: width*0.055),
        ],
      ),
    );
  }
}
