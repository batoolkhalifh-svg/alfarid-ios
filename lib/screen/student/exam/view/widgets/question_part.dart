import 'package:alfarid/core/utils/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../controller/exam_cubit.dart';

class QuestionPart extends StatelessWidget {
  const QuestionPart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExamCubit, BaseStates>(builder: (context, state) {
      var cubit = ExamCubit.get(context);
      return  Container(
        margin: EdgeInsetsDirectional.symmetric(horizontal: width*0.02, vertical: width*0.04),
        height: height*0.62,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.r10)
        ),
        child: PageView.builder(
          controller: cubit.pageController,
          physics: const NeverScrollableScrollPhysics(), // لتعطيل السحب اليدوي
          onPageChanged: (index) {
            cubit.changeIndex(index);
          },
          itemCount: cubit.myExamModel!.data!.questions!.length,
          itemBuilder: (context, index) {
            final question = cubit.myExamModel!.data!.questions![index];
            return Padding(
              padding:  EdgeInsets.symmetric(horizontal: width*0.035,vertical: width*0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.question.toString(),
                    style: Styles.textStyle16.copyWith(fontFamily: AppFonts.almaraiBold,color: AppColors.blackColor),
                  ),
                  SizedBox(height: width*0.06),
                  ...List.generate(
                    question.options!.length,
                        (answerIndex) => Container(
                      margin: EdgeInsets.only(bottom: width*0.025),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                          border: Border.all(color: AppColors.grayColorOp)
                      ),
                      child: ListTile(
                        title: Text(question.options![answerIndex].answer.toString(),style: Styles.textStyle14.copyWith(color: AppColors.blackColor),),
                        contentPadding: EdgeInsetsDirectional.zero,
                        leading: Radio(
                          value: question.options![answerIndex].id,
                          groupValue: cubit.selectedAnswer,
                          onChanged: (value) {
                            cubit.addAnswer(value,question.id);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );});




  }
}
