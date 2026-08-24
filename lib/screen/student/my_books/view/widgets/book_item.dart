import 'package:alfarid/core/local/app_cached.dart';
import 'package:alfarid/core/local/cache_helper.dart';
import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';
import 'open_file.dart';

class BookItem extends StatelessWidget {
  final String? price, file;
  final String img, name, classRoom;
  final void Function()? onTapCart;

  const BookItem({
    super.key,
    required this.img,
    required this.name,
    this.price,
    required this.classRoom,
    this.file,
    this.onTapCart,
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
        padding: EdgeInsets.all(width * 0.025),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🖼 IMAGE + PRICE BADGE
            Stack(
              children: [

                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.r10),
                  child: Container(
                    width: double.infinity,
                    height: height * 0.14,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: img.isEmpty
                            ? const AssetImage(AppImages.noImage)
                            : NetworkImage(img) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // 💰 PRICE BADGE
                if (CacheHelper.getData(key: AppCached.isApple) != true &&
                    price != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.02,
                        vertical: width * 0.01,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        price!,
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
              style: Styles.textStyle12.copyWith(
                color: AppColors.blackColor,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: width * 0.01),

            // 🏫 CLASS
            Text(
              classRoom,
              style: Styles.textStyle12.copyWith(
                color: AppColors.mainColor2,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const Spacer(),

            // 🛒 ADD TO CART BUTTON (NEW DESIGN)
            if (CacheHelper.getData(key: AppCached.isApple) != true &&
                price != null)
              GestureDetector(
                onTap: onTapCart,
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: height * 0.01),
                  padding: EdgeInsets.symmetric(vertical: height * 0.012),
                  decoration: BoxDecoration(
                    color: AppColors.mainColor2,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.mainColor2.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
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
                      const Text(
                        "أضف إلى السلة",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
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