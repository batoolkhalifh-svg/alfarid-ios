import 'package:flutter/material.dart';

class AppColors {
  // اللون الرئيسي للتطبيق - أزرق فيروزي راقي
  static const mainColor = Color(0xFF0089A6); // الأساسي

  // لون داعم داكن لتدرجات الأزرار أو خلفيات ثانوية
  static const mainColor2 = Color(0xFF006C80); // أغمق من الرئيسي بحوالي 30%

  // لون النصوص الرئيسية - يتناسق مع الرئيسي
  static const mainColorText = Color(0xFF005560); // داكن متناسق مع الرئيسي

  // لون النصوص الغامقة جداً
  static const mainColorBold = Color(0xFF003B45); // داكن جداً للفخامة

  // ألوان داكنة للواجهات الخلفية أو العناصر الثانوية
  static const blackColor = Color(0xFF040815);
  static const blackColor2 = Color(0xFF0E202C);

  // ألوان رمادية للأزرار الغير نشطة أو النصوص الثانوية
  static const grayColor = Color(0xFFADADAD);
  static const grayColor2 = Color(0xFFB4BDC4);
  static const grayColor3 = Color(0xFFAABAEE);
  static var grayColorOp = const Color(0xFFADADAD).withOpacity(0.4);

  // خلفيات الشاشة
  static const onBoardingBgColor = Color(0xFFF6F9FF); // فاتحة وراقية
  static const containerBgColor = Color(0xFFF8F8F8);
  static const fillColor = Color(0xFFEAEEFB);
  static const borderColor = Color(0xFFDBDBDB);

  // لون النجوم (مثلاً للتقييم)
  static const star = Color(0xFFFFC416);

  // خلفية الدردشة
  static const myChatColor = Color(0xFFF5F5F5);
}