import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../generated/locale_keys.g.dart';
import '../utils/images.dart';
import '../utils/size.dart';
import '../utils/styles.dart';

class CustomAuthBg extends StatelessWidget {
  final Widget widget;
  final ScrollPhysics? physics;
  const CustomAuthBg({super.key, required this.widget, this.physics});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
                width: double.infinity,
                height: height,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(AppImages.backgroundAuth),
                      fit: BoxFit.fill),
                ),),
            Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                    child: SingleChildScrollView(
                        physics: physics ,
                        child: Column(
                          children: [
                            Padding(
                                padding: EdgeInsetsDirectional.only(top: height * .1),
                                child: Column(children: [
                                  Text(
                                    LocaleKeys.startJourney.tr(),
                                    style: Styles.textStyle20.copyWith(color: Colors.white),
                                  ),
                                  SizedBox(height: height * 0.01),
                                  Image.asset(
                                    AppImages.logo,
                                    width: width * 0.35,
                                  ),])),
                            Container(
                              width: width,
                              // height: height*0.7,
                              decoration: const BoxDecoration(
                                  image:DecorationImage(
                                      image: AssetImage(AppImages.onBoardingBottom),
                                      fit: BoxFit.fill)
                              ),
                              child: widget,
                            ),
                          ],
                        ))))
               ]));
  }
}
