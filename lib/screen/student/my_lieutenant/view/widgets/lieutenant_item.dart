import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/local/app_cached.dart';
import '../../../../../core/local/cache_helper.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../generated/locale_keys.g.dart';
import 'open_file.dart';
import '../../../../../core/widgets/custom_btn.dart';

class LieutenantItem extends StatelessWidget {
  final String? price, file;
  final String img, name, classRoom, subject;
  final void Function()? onTapCart;
  final Function()? onTapExam;

  const LieutenantItem({
    super.key,
    required this.img,
    required this.name,
    this.price,
    required this.classRoom,
    this.file,
    this.onTapCart,
    required this.subject,
    this.onTapExam,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: file == null
          ? null
          : () {
        navigateTo(
          widget: PDFViewerScreen(
            url: file.toString(),
            name: name,
            img: img,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(width * 0.03),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🖼 IMAGE + 💰 PRICE BADGE (فوق الصورة)
            Stack(
              children: [

                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    width: double.infinity,
                    height: height * 0.16,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: img.isEmpty
                            ? AssetImage(AppImages.noImage)
                            : NetworkImage(img) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // 💰 PRICE BADGE (فخم)
                if (CacheHelper.getData(key: AppCached.isApple) != true &&
                    price != null)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.02,
                        vertical: width * 0.01,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        LocaleKeys.qAr.tr(args: [price!]),
                        style: Styles.textStyle12.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: width * 0.02),

            // 📘 NAME
            Text(
              name,
              style: Styles.textStyle14.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.blackColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: width * 0.01),

            // 📚 SUBJECT CHIP
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.025,
                vertical: width * 0.01,
              ),
              decoration: BoxDecoration(
                color: AppColors.mainColor2.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                subject,
                style: Styles.textStyle12.copyWith(
                  color: AppColors.mainColor2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            SizedBox(height: width * 0.01),

            // 🏫 CLASS
            Text(
              classRoom,
              style: Styles.textStyle12.copyWith(
                color: Colors.grey.shade600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const Spacer(),

            // 🛒 FULL BUTTON (أضف للسلة - فخم)
            if (CacheHelper.getData(key: AppCached.isApple) != true &&
                price != null)
              GestureDetector(
                onTap: onTapCart,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: height * 0.012,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.mainColor2,
                        AppColors.mainColor2.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.mainColor2.withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppImages.cart2,
                        width: width * 0.05,
                        color: Colors.white,
                      ),
                      SizedBox(width: width * 0.02),
                      Text(
                        "أضف إلى السلة",
                        style: Styles.textStyle12.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            SizedBox(height: height * 0.01),

            // 🧪 EXAM
            if (file != null)
              CustomButton(
                text: LocaleKeys.startTest.tr(),
                onPressed: onTapExam,
                widthBtn: width,
                hit: height * 0.045,
                color: true,
              ),
          ],
        ),
      ),
    );
  }
}