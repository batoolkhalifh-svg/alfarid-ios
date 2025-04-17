import 'package:alfarid/generated/locale_keys.g.dart';
import 'package:alfarid/screen/common/auth/register_as/view/register_as_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/my_navigate.dart';
import '../utils/size.dart';
import '../utils/styles.dart';
import 'custom_btn.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({super.key, this.onTap, this.isDelete=false,});
  final Function()? onTap;
  final bool? isDelete;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      title: Column(
        children: [
          Text(isDelete==true?LocaleKeys.areYouSureDeleteAcc.tr():LocaleKeys.youShouldLogin.tr(),style: Styles.textStyle14.copyWith(color: AppColors.mainColor),textAlign: TextAlign.center,),
          SizedBox(height: height*0.02,),
          isDelete==true?
          Row(
            children: [
              Expanded(child: CustomButton(text: LocaleKeys.yes.tr(), onPressed: onTap, widthBtn: width*0.8,)),
              SizedBox(width:width*.035,),
              Expanded(child: CustomButton(text: LocaleKeys.no.tr(), onPressed: () {navigatorPop(); }, widthBtn: width*0.8,)),
            ],
          ):CustomButton(text: LocaleKeys.login.tr(), onPressed: (){navigateAndFinish(widget: const RegisterASScreen());}, widthBtn: width*0.8)

        ],
      ),
    );
  }
}