
import 'package:alfarid/core/widgets/custom_loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_arrow.dart';
import '../../../../../core/widgets/custom_btn.dart';
import '../../../../../core/widgets/custom_error.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../controller/exam_cubit.dart';
import 'question_part.dart';

class ExamBody extends StatelessWidget {
  final int id;
  final bool isLieutenant;
  const ExamBody({super.key, required this.id, required this.isLieutenant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider<ExamCubit>(
            create: (context) => ExamCubit()..getExam(id: id, isLieutenant: isLieutenant),
            child: BlocBuilder<ExamCubit, BaseStates>(builder: (context, state) {
                var cubit = ExamCubit.get(context);
              return SafeArea(
                  child:  state is BaseStatesLoadingState ? const Center(child: CustomLoading(fullScreen: true,)):
                  state is BaseStatesErrorState ? CustomError(title: state.msg, onPressed: (){cubit.getExam(id: id, isLieutenant: isLieutenant);}):
                  cubit.myExamModel!.data!.questions!.isEmpty?Center(child: Text(LocaleKeys.notAddExam.tr()))
                      :Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       CustomArrow(text: cubit.myExamModel!.data!.name.toString(),),
                       Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: width * 0.07, vertical: width * 0.08),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                LinearProgressIndicator(
                                  borderRadius: BorderRadius.circular(AppRadius.r10),
                                  value: (cubit.currentIndex + 1) / cubit.myExamModel!.data!.questions!.length,
                                  backgroundColor: AppColors.grayColorOp,
                                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.mainColor),
                                  minHeight: height*0.01,
                                ),
                                 SizedBox(height: height*0.01),
                                const QuestionPart(),
                                CustomButton(text: LocaleKeys.next.tr(), onPressed: cubit.currentIndex < cubit.myExamModel!.data!.questions!.length - 1
                                    ? () {cubit.pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut,);} : (){
                                  cubit.submitExam(cubit.myExamModel!.data!.id.toString(),isLieutenant);
                                }, widthBtn: width*0.8),
                               SizedBox(height: width*0.03,),
                                Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: width*0.05),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        " ${cubit.currentIndex + 1} ${LocaleKeys.from.tr()} ${cubit.myExamModel!.data!.questions!.length}",
                                        style: Styles.textStyle14.copyWith(color: AppColors.blackColor),
                                      ),
                                      Text(
                                        " ${LocaleKeys.left.tr()} ${cubit.myExamModel!.data!.questions!.length-(cubit.currentIndex+1)} ${LocaleKeys.question.tr()}",
                                        style: Styles.textStyle14.copyWith(color: AppColors.blackColor),
                                      ),
                                    ],
                                  ),
                                ),
                                                  
                              ],
                            ),
                          )),
                    ),

                  ]));
            })),);
  }
}


