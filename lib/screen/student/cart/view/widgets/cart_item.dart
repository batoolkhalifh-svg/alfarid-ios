import 'package:alfarid/core/remote/my_dio.dart';
import 'package:alfarid/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';

class CartItem extends StatelessWidget {
  final String name,img,price;
  final void Function()? onTapDelete;
  const CartItem({super.key, required this.name, required this.img, required this.price, this.onTapDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: width*0.022,vertical: width*0.022),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.r8)
      ),
      child: Row(
        children: [
          Container(
            width: width*.25,
            height: height*.12,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.r10),
                image: DecorationImage(image: NetworkImage(img),fit: BoxFit.fill)
            ),child: img.isEmpty
              ? Image.asset(AppImages.noImage,fit: BoxFit.fill,)
              : null,),
          SizedBox(width: width*0.03),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: width*0.4,
                  child: Text(name, style: Styles.textStyle14.copyWith(color: AppColors.blackColor,fontWeight: FontWeight.bold),)),
              SizedBox(height: width*0.03),
              Text(LocaleKeys.qAr.tr(args: [price]) , style: Styles.textStyle14.copyWith(color: Colors.green,fontFamily: AppFonts.almaraiBold,fontWeight: FontWeight.bold),),
            ],
          ),
          const Spacer(),
          InkWell(
              onTap: onTapDelete,
              child: SvgPicture.asset(AppImages.redDelete,width: width*0.085,))

        ],
      ),
    );
  }
}
