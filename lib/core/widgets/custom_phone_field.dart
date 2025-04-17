import 'package:easy_localization/easy_localization.dart' as localization;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/images.dart';
import '../../../core/utils/size.dart';
import '../utils/styles.dart';
import '../../generated/locale_keys.g.dart';

class CustomPhoneField extends StatelessWidget {
  final String? phoneKey;
  final Color? fillCol;
  final TextEditingController ?ctrl;
  final Function(PhoneNumber) onChangedPhone;
  final bool isEnabled;

  final Function(Country) onChangedCode;

  const CustomPhoneField(
      {super.key,
        this.phoneKey,
        required this.onChangedPhone,
        required this.onChangedCode,
        this.fillCol, this.ctrl, this.isEnabled=true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: height * 0.018),
      child: Directionality(
        textDirection: context.locale.languageCode == "ar"
            ? TextDirection.ltr
            : TextDirection.rtl,
        child: IntlPhoneField(
          controller: ctrl,
          enabled: isEnabled,
          dropdownTextStyle: Styles.textStyle12.copyWith(color: AppColors.mainColor),
          dropdownIcon: const Icon(
            Icons.arrow_drop_down,
            color: AppColors.mainColor,
            size: 25,
          ),
          dropdownIconPosition: IconPosition.trailing,
          cursorColor: AppColors.mainColor,
          cursorHeight: 20,
          flagsButtonPadding: EdgeInsetsDirectional.only(start: width*.02),
          style: Styles.textStyle12.copyWith(color: AppColors.mainColor),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
                vertical: height * 0.023,
                horizontal: width * 0.03),
            border:   OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.r6),borderSide:  BorderSide(color: AppColors.grayColorOp)),
            focusedBorder:  OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.r6),borderSide:  BorderSide(color: AppColors.grayColorOp)),
            enabledBorder:   OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.r6),borderSide:  BorderSide(color: AppColors.grayColorOp)),
            disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.r6),borderSide:  BorderSide(color: AppColors.grayColorOp)),

            hintStyle: Styles.textStyle12.copyWith(
                color: AppColors.grayColor
            ),
            hintText: LocaleKeys.phone.tr(),
            suffixIcon:  Padding(
              padding:EdgeInsets.symmetric(horizontal: width*0.038),
              child: SvgPicture.asset(AppImages.phone),
            ),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(14)
          ],
          initialCountryCode: phoneKey ?? "QA",
          disableLengthCheck: true,
          onChanged: onChangedPhone,
          onCountryChanged: onChangedCode,
          textAlign: context.locale.languageCode == "ar"
              ? TextAlign.right
              : TextAlign.left,
        ),
      ),
    );
  }
}