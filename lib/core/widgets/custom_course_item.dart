import 'package:alfarid/core/widgets/custom_network_img.dart';
import 'package:alfarid/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../local/app_cached.dart';
import '../local/cache_helper.dart';
import '../utils/colors.dart';
import '../utils/images.dart';
import '../utils/size.dart';
import '../utils/styles.dart';

class CustomCourseItem extends StatelessWidget {
  final bool? isSaves;
  final String img, title, subTitle, price;
  final String? teacherName;
  final VoidCallback? onTap;
  final VoidCallback? onTapSave;

  const CustomCourseItem({
    super.key,
    this.isSaves,
    required this.img,
    required this.title,
    required this.subTitle,
    required this.price,
    this.teacherName,
    required this.onTap,
    this.onTapSave,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          width: width,
          margin: EdgeInsets.symmetric(vertical: height * 0.008),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              if (img.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: CustomNetworkImg(
                    img: img,
                    width: width * 0.28,
                    height: width * 0.28,
                  ),
                ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(width * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Styles.textStyle14.copyWith(
                                color: AppColors.mainColor2,
                                fontWeight: FontWeight.w700,
                                fontSize: 15.sp,
                              ),
                            ),
                          ),

                          if (CacheHelper.getData(
                              key: AppCached.token) !=
                              null)
                            InkWell(
                              onTap: onTapSave,
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: SvgPicture.asset(
                                  isSaves == true
                                      ? AppImages.save
                                      : AppImages.unSave,
                                  width: width * 0.05,
                                ),
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: height * 0.008),

                      Text(
                        subTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Styles.textStyle12.copyWith(
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),

                      SizedBox(height: height * 0.015),

                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.025,
                              vertical: height * 0.006,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.mainColor2
                                  .withOpacity(0.08),
                              borderRadius:
                              BorderRadius.circular(10),
                            ),
                            child: Text(
                              LocaleKeys.qAr.tr(args: [price]),
                              style: Styles.textStyle14.copyWith(
                                color: AppColors.mainColor2,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),

                          const Spacer(),

                          if (teacherName != null) ...[
                            const Icon(
                              Icons.person_outline,
                              size: 18,
                              color: AppColors.mainColor2,
                            ),
                            SizedBox(width: width * 0.01),
                            Expanded(
                              child: Text(
                                teacherName!,
                                overflow: TextOverflow.ellipsis,
                                style: Styles.textStyle12.copyWith(
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}