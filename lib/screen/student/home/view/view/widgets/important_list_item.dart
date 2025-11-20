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

  const ImportantListItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(builder: (context, state) {
      final cubit = HomeCubit.get(context);
      return GestureDetector(
        onTap: () {
          CacheHelper.getData(key: AppCached.token) == null
              ? showDialog(context: context, builder: (context) => const CustomAlertDialog())
              : navigateTo(
                  widget: CourseDetailsScreen(
                  id: cubit.data[index].id!,
                ));
        },
        child: Container(
          // width: width*0.55,
          alignment: AlignmentDirectional.topStart,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.r8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: width * 0.55,
                height: height * 0.1,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(AppRadius.r8), topRight: Radius.circular(AppRadius.r8)),
                    image: DecorationImage(image: NetworkImage(cubit.data[index].image.toString()), fit: BoxFit.fill)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.02,
                  vertical: height * 0.01,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: width * 0.33,
                        child: Text(
                          cubit.data[index].name.toString(),
                          style: Styles.textStyle14.copyWith(color: AppColors.mainColor2),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )),
                    if(CacheHelper.getData(key: AppCached.token) != null)
                    GestureDetector(
                        onTap: () {
                          cubit.toggleSaved(id: cubit.data[index].id!, index: index);
                        },
                        child: SvgPicture.asset(cubit.data[index].isFavourite == true ? AppImages.save : AppImages.unSave,
                            width: width * 0.05))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                child: Text(cubit.data[index].subject.toString(), style: Styles.textStyle12.copyWith(color: AppColors.blackColor)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                child: Row(
                  children: [
                    if (cubit.data[index].price != null && cubit.data[index].price.toString() != '0')
                      Text(LocaleKeys.qAr.tr(args: [cubit.data[index].price.toString()]),
                          style: Styles.textStyle14.copyWith(color: AppColors.mainColor2, fontSize: 15.sp)),
                    Image.asset(AppImages.tallDash, width: width * 0.05, height: height * 0.06),
                    Text(cubit.data[index].teacher!.name.toString(),
                        style: Styles.textStyle14.copyWith(color: AppColors.blackColor, fontFamily: AppFonts.almaraiRegular)),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    const Icon(
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
      );
    });
  }
}
