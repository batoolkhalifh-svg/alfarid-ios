import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';

class CustomCard extends StatelessWidget {
  final String img, text1, text2;

  const CustomCard({
    super.key,
    required this.img,
    required this.text1,
    required this.text2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: width * 0.04,
        vertical: width * 0.05,
      ),
      width: width * .43,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.r15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: AppColors.mainColor.withOpacity(0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🎯 Icon container (فخامة إضافية)
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.mainColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SvgPicture.asset(
              img,
              width: width * 0.10,
              colorFilter: ColorFilter.mode(
                AppColors.mainColor,
                BlendMode.srcIn,
              ),
            ),
          ),

          SizedBox(height: width * 0.03),

          // 📌 Title
          Text(
            text1,
            style: Styles.textStyle14.copyWith(
              color: AppColors.mainColorBold,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: width * 0.015),

          // 📊 Value
          Text(
            text2,
            style: Styles.textStyle14.copyWith(
              color: AppColors.grayColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}