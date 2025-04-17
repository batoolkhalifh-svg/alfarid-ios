
import 'package:alfarid/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../remote/my_dio.dart';
import '../utils/images.dart';
import '../utils/size.dart';
import '../utils/styles.dart';
import 'custom_btn.dart';


class CustomError extends StatelessWidget {
  const CustomError({super.key, required this.title, required this.onPressed});
  final String title;

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            title == globalError(context.locale.languageCode)
                ? AppImages.noInternet
                : title == noInternet(context.locale.languageCode)
                ? AppImages.noInternet
                : AppImages.netError,
            width: width * .35,
            height: height * .17,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: height * .02,
                horizontal: width * .05),
            child: Text(title,
                style: Styles.textStyle16.copyWith(
                    height: height * 0.002,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.center),
          ),
          SizedBox(
            width: width*.3,
            child: CustomButton(text: LocaleKeys.tryAgain.tr(), onPressed:onPressed, widthBtn:width*.3,
            ),
          ),
          SizedBox(
            height: height * .03,
          )
        ],
      ),
    );
  }
}
