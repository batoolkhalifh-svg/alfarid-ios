import 'package:alfarid/screen/trainer/bottom_nav_teacher/view/bottom_nav_screen.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/size.dart';
import '../../../core/local/app_cached.dart';
import '../../../core/local/cache_helper.dart';
import '../../../core/utils/my_navigate.dart';
import '../../student/bottom_nav_student/view/bottom_nav_screen.dart';
import '../on_boarding/view/on_boarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2)).then((value) =>
    navigateAndFinish( widget:
    CacheHelper.getData(key: AppCached.token)==null?
    const OnBoardingScreen():
    CacheHelper.getData(key: AppCached.role)==AppCached.student?
    const BottomNavScreen():const BottomNavTeacherScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: height * .04),
              width: double.infinity,
              height: height,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(AppImages.splashBg),
                    fit: BoxFit.fill),
              ),
              child: ZoomIn(
                  duration: const Duration(milliseconds: 2800),
                  child:Image.asset(AppImages.logo,width: width*0.5)
              ),
            ),
          ],
        ));
  }
}