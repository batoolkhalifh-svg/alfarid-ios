import 'package:alfarid/core/utils/styles.dart';
import 'package:easy_localization/easy_localization.dart' as translation;
import 'package:flutter/material.dart';
import '../../../../../../core/utils/size.dart';
import '../../../../../../core/utils/colors.dart';

class CustomContainer extends StatelessWidget {
  final void Function()? onTap;
  final bool isSelect;
  final String image;
  final String title;

  const CustomContainer(
      {super.key,
        this.onTap,
        required this.isSelect,
        required this.image,
        required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Directionality(
        textDirection:context.locale.languageCode=="ar"? TextDirection.ltr:TextDirection.rtl,
        child: Container(
          width: width * 0.39,
          // height: height * 0.211,
          padding: EdgeInsets.only(top: height * .035, bottom: height * .028),
          decoration: BoxDecoration(
            color: AppColors.containerBgColor,
           border: Border.all(color:isSelect==true? AppColors.mainColor:AppColors.containerBgColor ),
            borderRadius: BorderRadius.circular(AppRadius.r8)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(image,width: width*0.2),
              Text(title, style:Styles.textStyle14.copyWith(color: AppColors.blackColor))
            ],
          ),
        ),
      ),
    );
  }
}