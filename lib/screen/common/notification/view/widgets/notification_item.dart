import 'package:alfarid/core/widgets/custom_network_img.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../student/web_view.dart';

class NotificationItem extends StatelessWidget {
  final String text1, text2, img, type, time;

  const NotificationItem({
    super.key,
    required this.text1,
    required this.type,
    required this.text2,
    required this.img,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final isPayment = type == 'pay';

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        if (isPayment) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  WebViewPaymentScreen(
                    paymentUrl: text2,
                  ),
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: height * 0.015,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.03,
          vertical: height * 0.015,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.mainColor
                .withOpacity(0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.mainColor
                  .withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            /// image
            ClipRRect(
              borderRadius:
              BorderRadius.circular(14),
              child: CustomNetworkImg(
                img: img,
                width: width * 0.16,
              ),
            ),

            SizedBox(width: width * 0.03),

            /// text area
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  /// title + badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          text1,
                          maxLines: 1,
                          overflow:
                          TextOverflow
                              .ellipsis,
                          style: Styles
                              .textStyle14
                              .copyWith(
                            color:
                            AppColors
                                .mainColorBold,
                            fontWeight:
                            FontWeight
                                .w700,
                          ),
                        ),
                      ),

                      if (isPayment)
                        Container(
                          padding:
                          const EdgeInsets
                              .symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration:
                          BoxDecoration(
                            color: AppColors
                                .mainColor
                                .withOpacity(
                              0.08,
                            ),
                            borderRadius:
                            BorderRadius.circular(
                              8,
                            ),
                          ),
                          child: Text(
                            "دفع",
                            style:
                            TextStyle(
                              fontSize:
                              10,
                              color:
                              AppColors.mainColor,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),

                  SizedBox(
                    height: height * 0.008,
                  ),

                  Text(
                    text2,
                    maxLines: 2,
                    overflow:
                    TextOverflow
                        .ellipsis,
                    style: Styles
                        .textStyle12
                        .copyWith(
                      color:
                      Colors.grey[700],
                      height: 1.4,
                    ),
                  ),

                  SizedBox(
                    height: height * 0.012,
                  ),

                  /// time row
                  Row(
                    children: [
                      Icon(
                        Icons
                            .access_time_rounded,
                        size: 14,
                        color:
                        Colors.grey,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        time,
                        style: Styles
                            .textStyle10
                            .copyWith(
                          color:
                          Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}