import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:alfarid/core/utils/styles.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/images.dart';
import '../../../../core/utils/size.dart';
import '../../../../core/widgets/base_state.dart';
import '../../../../core/widgets/custom_arrow.dart';
import '../../../../core/widgets/custom_btn.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../generated/locale_keys.g.dart';
import '../controller/start_live_cubit.dart';

class LinkLive extends StatelessWidget {
  final String link;
  const LinkLive({super.key, required this.link});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<StartLiveCubit>(
          create: (context) => StartLiveCubit(),
          child: BlocBuilder<StartLiveCubit, BaseStates>(
              builder: (context, state) {
                var cubit = StartLiveCubit.get(context);
                return SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomArrow(text: LocaleKeys.makeAlive.tr()),
                        Expanded(
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: width * 0.07, vertical: width * 0.03),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    DottedBorder(
                                      color: AppColors.mainColor,
                                      strokeWidth: 1,
                                      child: InkWell(
                                        onTap: ()async{
                                          await Clipboard.setData(ClipboardData(text: link));
                                          showToast(text: LocaleKeys.textCopied.tr(), state: ToastStates.success);
                                        },
                                        child: Row(
                                            children:[
                                              Text(LocaleKeys.copy.tr(),style: Styles.textStyle12.copyWith(color: AppColors.mainColorText)),
                                              Padding(
                                                padding:  EdgeInsets.only(top: width*0.035),
                                                child: SvgPicture.asset(AppImages.copy,width: width*0.1,),
                                              ),
                                              SizedBox(
                                                  width: width*0.58,
                                                  child: Text(link,style: Styles.textStyle12.copyWith(color: AppColors.blackColor),textAlign: TextAlign.end,)),
                                            ]
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: height*0.71),
                                    CustomButton(text: LocaleKeys.home.tr(), onPressed: (){
                                      navigatorPop();
                                    }, widthBtn: width*0.85)


                                  ],
                                ),
                              )),
                        ),



                      ],
                    ));
              })),
    );
  }
}
