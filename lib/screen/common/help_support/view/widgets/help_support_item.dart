import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';

class HelpAndSupportItem extends StatelessWidget {
  final String text1, text2, img;
  final void Function()? onTap;

  const HelpAndSupportItem({
    super.key,
    required this.text1,
    required this.text2,
    required this.img,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.04,
          vertical: height * 0.018,
        ),
        margin: EdgeInsets.only(
          bottom: height * 0.015,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.mainColor.withOpacity(0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.mainColor.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            /// icon circle
            Container(
              width: width * 0.14,
              height: width * 0.14,
              padding: EdgeInsets.all(width * 0.025),
              decoration: BoxDecoration(
                color: AppColors.mainColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                img,
                fit: BoxFit.contain,
              ),
            ),

            SizedBox(width: width * 0.04),

            /// text
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    text1,
                    style: Styles.textStyle14.copyWith(
                      color:
                      AppColors.mainColorBold,
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.006,
                  ),
                  Text(
                    text2,
                    style: Styles.textStyle12
                        .copyWith(
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            /// arrow
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: AppColors.mainColor,
            ),
          ],
        ),
      ),
    );
  }
}