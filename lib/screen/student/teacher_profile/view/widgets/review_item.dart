import 'package:flutter/material.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';

class ReviewItem extends StatelessWidget {
  final String image, name, rate, commented, createAt;

  const ReviewItem(
      {super.key, required this.image, required this.name, required this.rate, required this.commented, required this.createAt});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: width * 0.024, vertical: width * 0.042),
        alignment: AlignmentDirectional.topStart,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.r8)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: AppRadius.r28,
              backgroundImage: NetworkImage(image),
            ),
            SizedBox(width: width * 0.03),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: Styles.textStyle14.copyWith(color: AppColors.mainColor, fontWeight: FontWeight.bold),maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: width * 0.01, horizontal: width * 0.02),
                        decoration: BoxDecoration(
                            color: AppColors.fillColor,
                            border: Border.all(color: AppColors.mainColor),
                            borderRadius: BorderRadius.circular(AppRadius.r15)),
                        child: Row(
                          children: [
                            Text(
                              rate,
                              style: Styles.textStyle14.copyWith(color: AppColors.mainColor, fontFamily: AppFonts.jost),
                            ),
                            SizedBox(width: width * 0.01),
                            Image.asset(
                              AppImages.star,
                              width: width * 0.05,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: width * 0.015),
                  SizedBox(
                      width: width * 0.52,
                      child: Text(
                        commented,
                        style: Styles.textStyle12.copyWith(color: AppColors.blackColor),
                      )),
                  SizedBox(height: width * 0.015),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        createAt,
                        style: Styles.textStyle14
                            .copyWith(fontFamily: AppFonts.mulishExtraBold, color: AppColors.blackColor, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: width * 0.05),
                    ],
                  )
                ],
              ),
            )
          ],
        ));
  }
}
