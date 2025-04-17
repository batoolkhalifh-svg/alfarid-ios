import 'package:flutter/material.dart';

import '../../../../../../../core/utils/colors.dart';
import '../../../../../../../core/utils/size.dart';


class ChatImg extends StatelessWidget {
  const ChatImg({super.key, required this.isActive, required this.img});
  final bool isActive;
  final String img;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: AppRadius.r20,
          backgroundColor: Colors.transparent,
          backgroundImage:AssetImage(img),
        ),
        CircleAvatar(
          radius: AppRadius.r8,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: AppRadius.r6,
            backgroundColor: isActive==true ?  Colors.green : AppColors.grayColor,
          ),
        ),
      ],
    );
  }
}
