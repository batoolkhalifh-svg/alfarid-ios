
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../generated/locale_keys.g.dart';
import '../utils/my_navigate.dart';
import '../utils/size.dart';
import 'custom_btn.dart';



class PickImageBottomSheetContainer extends StatelessWidget {
  const PickImageBottomSheetContainer(
      {super.key, required this.fromCamFun, required this.fromGalleryFun});

  final Function() fromCamFun;
  final Function() fromGalleryFun;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(
          vertical: height * .05, horizontal: width * .05),
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: width,
            child: Material(child: CustomButton(text: LocaleKeys.takeFromCamera.tr(), onPressed: fromCamFun, widthBtn: width*0.8,color: false,)),
          ),
          SizedBox(
            width: width,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: height * .01),
              child: Material(
                child: CustomButton(
                    text: LocaleKeys.pickImageFromGallery.tr(),
                    onPressed: fromGalleryFun,widthBtn: width*0.8,color: false,
                ),
              ),
            ),
          ),
          SizedBox(
            width: width,
            child: Material(
              child: CustomButton(
                  text: LocaleKeys.close.tr(), onPressed: () {
                navigatorPop();
              },widthBtn: width*0.8,color: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
