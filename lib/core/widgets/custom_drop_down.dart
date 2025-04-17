import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../generated/locale_keys.g.dart';
import '../utils/colors.dart';
import '../utils/images.dart';
import '../utils/size.dart';
import '../utils/styles.dart';

class CustomDropDown extends StatelessWidget {
  final dynamic dropDownValue ;
  final List<DropdownMenuItem<String>> items ;
  final void Function(String?) onChanged  ;
  final String hintText;
  const CustomDropDown({super.key, this.dropDownValue, required this.onChanged, required this.items, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top:height * 0.018),
      child: DropdownButtonFormField<String>(
        hint: Text(hintText,style: Styles.textStyle12.copyWith(
            color: AppColors.grayColor),),
        onChanged: onChanged,
        value:dropDownValue,
        style:const TextStyle(color: AppColors.mainColor),
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          prefixIcon:hintText==LocaleKeys.fileType.tr()?null: Padding(
            padding: EdgeInsets.symmetric(horizontal: width*0.038),
            child: SvgPicture.asset(AppImages.user),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: height*0.02, horizontal: width*0.015),
          border:  OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.r6),borderSide:  BorderSide(color: AppColors.grayColorOp)),
          focusedBorder:  OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.r6),borderSide:  BorderSide(color: AppColors.grayColorOp)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.r6),borderSide:  BorderSide(color: AppColors.grayColorOp)),
        ),
        icon:  Icon(Icons.keyboard_arrow_down,color: Colors.grey.shade300,),
        items: items,


      ),
    );
  }
}