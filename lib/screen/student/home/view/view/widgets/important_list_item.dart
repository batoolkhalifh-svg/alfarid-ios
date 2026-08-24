import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:alfarid/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/local/app_cached.dart';
import '../../../../../../core/local/cache_helper.dart';
import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/utils/images.dart';
import '../../../../../../core/utils/size.dart';
import '../../../../../../core/utils/styles.dart';
import '../../../../../../core/widgets/custom_alert_dialogue.dart';
import '../../../../course_details/view/course_details_screen.dart';
import '../../controller/home_cubit.dart';
import '../../controller/home_states.dart';

class ImportantListItem extends StatelessWidget {
  final int index;

  const ImportantListItem({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final cubit = HomeCubit.get(context);
        final item = cubit.data[index];

        final hasToken =
            CacheHelper.getData(key: AppCached.token) != null;

        final hasPrice =
            item.price != null &&
                item.price.toString() != '0';

        return GestureDetector(
          onTap: () {
            if (!hasToken) {
              showDialog(
                context: context,
                builder: (context) =>
                const CustomAlertDialog(),
              );
            } else {
              navigateTo(
                widget: CourseDetailsScreen(
                  id: item.id!,
                ),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(AppRadius.r8),
              boxShadow: [
                BoxShadow(
                  color:
                  Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                /// 🖼️ صورة الكورس
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft:
                    Radius.circular(AppRadius.r8),
                    topRight:
                    Radius.circular(AppRadius.r8),
                  ),
                  child: Image.network(
                    item.image ?? '',
                    width: width * 0.55,
                    height: height * 0.1,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => Container(
                      width: width * 0.55,
                      height: height * 0.1,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.image_not_supported,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.02,
                    vertical: height * 0.01,
                  ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                    children: [

                      /// 📚 اسم الكورس
                      SizedBox(
                        width: width * 0.33,
                        child: Text(
                          item.name ?? '',
                          style: Styles.textStyle14
                              .copyWith(
                            color:
                            AppColors.mainColor2,
                          ),
                          maxLines: 2,
                          overflow:
                          TextOverflow.ellipsis,
                        ),
                      ),

                      /// ❤️ الحفظ
                      if (hasToken)
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints:
                          const BoxConstraints(),
                          onPressed: () {
                            cubit.toggleSaved(
                              id: item.id!,
                              index: index,
                            );
                          },
                          icon: SvgPicture.asset(
                            item.isFavourite == true
                                ? AppImages.save
                                : AppImages.unSave,
                            width: width * 0.05,
                          ),
                        ),
                    ],
                  ),
                ),

                /// 📘 المادة
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.02,
                  ),
                  child: Text(
                    item.subject ?? '',
                    style: Styles.textStyle12
                        .copyWith(
                      color:
                      AppColors.blackColor,
                    ),
                  ),
                ),

                SizedBox(height: 6.h),

                /// 👨‍🏫 السعر + اسم المعلم
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.02,
                  ),
                  child: Row(
                    children: [
                      if (hasPrice) ...[
                        Text(
                          LocaleKeys.qAr.tr(
                            args: [
                              item.price.toString()
                            ],
                          ),
                          style: Styles
                              .textStyle14
                              .copyWith(
                            color: AppColors
                                .mainColor2,
                            fontSize: 15.sp,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Image.asset(
                          AppImages.tallDash,
                          width: width * 0.05,
                          height: height * 0.03,
                        ),
                        SizedBox(width: 6.w),
                      ],

                      Expanded(
                        child: Text(
                          item.teacher?.name ??
                              '',
                          style: Styles
                              .textStyle14
                              .copyWith(
                            color: AppColors
                                .blackColor,
                            fontFamily: AppFonts
                                .almaraiRegular,
                          ),
                          overflow:
                          TextOverflow.ellipsis,
                        ),
                      ),

                      SizedBox(width: 5.w),

                      const Icon(
                        Icons.person,
                        color:
                        AppColors.mainColor2,
                        size: 18,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 8.h),
              ],
            ),
          ),
        );
      },
    );
  }
}