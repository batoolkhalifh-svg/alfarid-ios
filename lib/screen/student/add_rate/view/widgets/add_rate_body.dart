import 'package:alfarid/core/widgets/custom_loading.dart';
import 'package:alfarid/core/widgets/custom_textfield.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_arrow.dart';
import '../../../../../core/widgets/custom_btn.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../../main.dart';
import '../../controller/add_rate_cubit.dart';

class AddRateBody extends StatelessWidget {
  final int id;
  const AddRateBody({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider<AddRateCubit>(
            create: (context) => AddRateCubit(),
            child:
                BlocBuilder<AddRateCubit, BaseStates>(builder: (context, state) {
              var cubit = AddRateCubit.get(context);
              return SafeArea(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    CustomArrow(text: LocaleKeys.addReviews.tr(),),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: width * 0.07, vertical: width * 0.08),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(LocaleKeys.writeComments.tr(),style: Styles.textStyle14.copyWith(color: AppColors.blackColor,fontWeight: FontWeight.bold),),
                                  CustomTextField(ctrl: cubit.commentCtrl,
                                  hint: LocaleKeys.writeAnything.tr(),
                                  maxLines: 6,
                                  contentPadding: EdgeInsets.symmetric(vertical: height * 0.022, horizontal: width * 0.03),
                                  withOutBorderColor: true,),
                                  SizedBox(height: width*0.035),
                                  Text(navigatorKey.currentContext!.locale.languageCode=="ar"?"تقييمك من 1 ل 5":"Your rating from 1 to 5",style: Styles.textStyle14.copyWith(color: AppColors.blackColor,fontWeight: FontWeight.bold),),
                                  SizedBox(height: height*.02),
                                  RatingBar.builder(
                                    initialRating: cubit.commentRating,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    itemSize: width*.095,
                                    itemPadding: EdgeInsets.zero,
                                    unratedColor: AppColors.grayColor,
                                    itemBuilder: (context, idx) => Container(
                                      margin: EdgeInsets.only(left: width*.02),
                                      padding: EdgeInsets.all(width*.01),
                                      decoration:  BoxDecoration(
                                          color: AppColors.grayColor.withOpacity(.2)
                                      ),
                                      child: Icon(
                                        Icons.star,
                                        color:  idx < cubit.commentRating ? AppColors.star : Colors.white,
                                      ),
                                    ),
                                    onRatingUpdate: (value) {
                                      cubit.changeCommentRate(value);
                                    },
                                  ),
                                 SizedBox(height: height*0.41),
                                  state is BaseStatesLoadingState ? const Center(child: CustomLoading()):
                                  CustomButton(text: LocaleKeys.addReviews.tr(), onPressed: (){
                                    FocusScope.of(context).unfocus();
                                    print(cubit.commentRating);
                                    cubit.addRate(id: id);
                                  }, widthBtn: width*0.85)
                        
                                ])),
                      ),
                    ),
                  ]));
            })));
  }
}
