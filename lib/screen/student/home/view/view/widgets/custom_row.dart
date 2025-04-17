import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/utils/size.dart';
import '../../../../../../core/utils/styles.dart';
import '../../../../../../generated/locale_keys.g.dart';



class CustomRow extends StatelessWidget {
  final String title;
  final Function() onTap;

  const CustomRow({super.key, required this.title, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04,vertical: width*0.025),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Styles.textStyle14.copyWith(color: AppColors.mainColorBold),),
          InkWell(
            onTap: onTap,
            child: Row(
              children: [
                Text(
                  LocaleKeys.showMore.tr(),
                  style: Styles.textStyle10.copyWith(color: AppColors.mainColor,fontFamily: AppFonts.almaraiBold),),
                SizedBox(width: width*0.005),
                const Padding(
                  padding:  EdgeInsets.only(top: 3),
                  child: Icon(Icons.arrow_forward_ios_rounded,color: AppColors.mainColor,size: 16,),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}