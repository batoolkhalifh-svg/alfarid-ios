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
import '../../../../../core/widgets/custom_btn.dart';
import '../../../../../generated/locale_keys.g.dart';
import 'open_file.dart';

class LieutenantItem extends StatelessWidget {
  final String? price, file;
  final String img, name, classRoom, subject;
  final void Function()? onTapCart;
  final Function()? onTapExam;

  const LieutenantItem(
      {super.key,
      required this.img,
      required this.name,
      this.price,
      required this.classRoom,
      this.file,
      this.onTapCart,
      required this.subject,
      this.onTapExam});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: file == null
          ? () {}
          : () async {
              navigateTo(
                  widget: PDFViewerScreen(
                url: file.toString(),
                name: name,
                img: img,
              ));
            },
      child: Container(
        padding: EdgeInsetsDirectional.all(width * 0.02),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.r10)),
        child: Column(
          children: [
            Container(
              width: width * .4,
              height: height * .14,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.r10), image: DecorationImage(image: NetworkImage(img), fit: BoxFit.fill)),
              child: img.isEmpty
                  ? Image.asset(
                      AppImages.noImage,
                      fit: BoxFit.fill,
                    )
                  : null,
            ),
            SizedBox(height: width * 0.018),
            Row(
              children: [
                SizedBox(
                    width: width * 0.3,
                    child: Text(
                      name,
                      style: Styles.textStyle12.copyWith(color: AppColors.blackColor, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    )),
                const Spacer(),
                CacheHelper.getData(key: AppCached.isApple) == true
                    ? const SizedBox.shrink()
                    : price != null
                        ? Text(
                            LocaleKeys.qAr.tr(args: [price!]) ?? "",
                            style: Styles.textStyle12
                                .copyWith(color: Colors.green, fontFamily: AppFonts.almaraiBold, fontWeight: FontWeight.bold),
                          )
                        : const SizedBox.shrink()
              ],
            ),
            SizedBox(height: width * 0.02),
            Row(
              children: [
                SizedBox(
                    width: width * 0.3,
                    child: Text(
                      subject,
                      style: Styles.textStyle14.copyWith(color: AppColors.mainColor2, fontFamily: AppFonts.almaraiRegular),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )),
              ],
            ),
            Row(
              children: [
                SizedBox(
                    width: width * 0.3,
                    child: Text(
                      classRoom,
                      style: Styles.textStyle14.copyWith(color: AppColors.mainColor2, fontFamily: AppFonts.almaraiRegular),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                const Spacer(),
                CacheHelper.getData(key: AppCached.isApple) == true
                    ? const SizedBox.shrink()
                    : price == null
                        ? const SizedBox.shrink()
                        : GestureDetector(onTap: onTapCart, child: SvgPicture.asset(AppImages.cart2, width: width * 0.07))
              ],
            ),
            if (file != null) ...[
              SizedBox(
                height: height * 0.005,
              ),
              CustomButton(
                text: LocaleKeys.startTest.tr(),
                onPressed: onTapExam,
                widthBtn: width * 0.85,
                hit: height * 0.045,
              )
            ]
          ],
        ),
      ),
    );
  }
}
