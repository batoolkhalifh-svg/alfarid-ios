import 'package:flutter/material.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';


class TabItem extends StatelessWidget {
  const TabItem({super.key, required this.title, required this.isSelected, required this.onTap});
  final String title;
  final bool isSelected;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Column(
        children: [
          Text(title,style: Styles.textStyle12.copyWith(
              color: isSelected ? AppColors.mainColor : AppColors.grayColor,fontWeight: FontWeight.bold
          ),),
          Container(
            margin: EdgeInsets.only(top: height*.02),
            height: 2,
            width: width*.4,
            color: isSelected ? AppColors.mainColor : Colors.transparent,
          )
        ],
      ),
    );
  }
}
