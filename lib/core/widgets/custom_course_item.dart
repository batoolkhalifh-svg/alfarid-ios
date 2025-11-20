import 'package:alfarid/core/remote/my_dio.dart';
import 'package:alfarid/core/widgets/custom_network_img.dart';
import 'package:alfarid/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

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
  final Function()? onTap;
  final Function()? onTapSave;

  const CustomCourseItem(
      {super.key,
      this.isSaves,
      required this.img,
      required this.title,
      required this.subTitle,
      required this.price,
      this.teacherName,
      required this.onTap,
      this.onTapSave});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        alignment: AlignmentDirectional.topStart,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.r8)),
        child: Row(
          children: [
            if (img.isNotEmpty)
              CustomNetworkImg(
                img: img,
                width: width * 0.29,
                height: width * 0.29,
              ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: width * 0.018),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.02,
                        vertical: height * 0.01,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text(
                            title,
                            style: Styles.textStyle14.copyWith(color: AppColors.mainColor2),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )),
                          if(CacheHelper.getData(key: AppCached.token) != null)
                          GestureDetector(
                              onTap: onTapSave,
                              child: SvgPicture.asset(isSaves == true ? AppImages.save : AppImages.unSave, width: width * 0.05))
                        ],
                      ),
                    ),
                    SizedBox(
                      width: width * 0.5,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                        child: Text(
                          subTitle,
                          style: Styles.textStyle12.copyWith(color: AppColors.blackColor),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                      child: Row(
                        children: [
                          Text(LocaleKeys.qAr.tr(args: [price]), style: Styles.textStyle14.copyWith(color: AppColors.mainColor2, fontSize: 15.sp)),
                          teacherName == null
                              ? SizedBox(height: height * 0.06)
                              : Image.asset(AppImages.tallDash, width: width * 0.05, height: height * 0.06),
                          SizedBox(
                            width: width * 0.01,
                          ),
                          Expanded(
                            child: Text(teacherName ?? "",
                                style: Styles.textStyle14.copyWith(color: AppColors.blackColor, fontFamily: AppFonts.almaraiRegular)),
                          ),

                          teacherName == null
                              ? const SizedBox.shrink()
                              : const Icon(
                                  Icons.person,
                                  color: AppColors.mainColor2,
                                  size: 18,
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
