import 'package:flutter/material.dart';
import '../utils/images.dart';
import '../utils/size.dart';

class CustomAuthBg extends StatelessWidget {
  final Widget widget;
  final ScrollPhysics? physics;

  const CustomAuthBg({
    super.key,
    required this.widget,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // الخلفية الأساسية
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppImages.backgroundAuth),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // طبقة شفافة فخمة فوق الخلفية
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.08),
                    Colors.transparent,
                    Colors.white.withOpacity(0.03),
                  ],
                ),
              ),
            ),
          ),

          // المحتوى الرئيسي
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                physics: physics ?? const BouncingScrollPhysics(),
                child: Transform.translate(
                  offset: Offset(0, -height * 0.06),
                  child: Container(
                    width: width,
                    padding: EdgeInsets.only(
                      top: height * 0.035,
                      bottom: height * 0.025,
                    ),
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage(AppImages.onBoardingBottom),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(34),
                        topRight: Radius.circular(34),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 24,
                          offset: const Offset(0, -8),
                        ),
                      ],
                    ),
                    child: widget,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}