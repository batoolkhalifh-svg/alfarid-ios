
import 'package:alfarid/core/utils/size.dart';
import 'package:alfarid/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_arrow.dart';
import '../../../../../core/widgets/custom_btn.dart';
import '../../../../../core/widgets/custom_loading.dart';
import '../../../../../core/widgets/custom_textfield.dart';
import '../../controller/start_live_cubit.dart';
import '../../model/student_model.dart';

class StartLiveBody extends StatelessWidget {
   const StartLiveBody({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<StartLiveCubit>(
          create: (context) => StartLiveCubit()..fetchStudents(),
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
                              CustomTextField(ctrl: cubit.liveTitleController,hint: LocaleKeys.broadcastTopic.tr()),
                              SizedBox(height: width*0.04),
                              state is BaseStatesLoadingState2? const Center(child: CustomLoading()):
                              cubit.studentsModel!.data!.isEmpty ? Text(LocaleKeys.emptyStudents.tr(),style: Styles.textStyle14.copyWith(color: AppColors.mainColorText),):
                              MultiSelectDialogField(
                                items: cubit.studentsModel!.data!.map((student) => MultiSelectItem<DataS>(student, student.name!)).toList(),
                                title: Text(LocaleKeys.chooseStudent.tr()),
                                selectedColor: AppColors.mainColor,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(AppRadius.r6)),
                                  border: Border.all(color: AppColors.grayColorOp, width: 1,),),
                                buttonIcon: const Icon(Icons.arrow_drop_down),
                                buttonText: Text(LocaleKeys.chooseStudent.tr(), style: Styles.textStyle12.copyWith(color: AppColors.grayColor),),
                                onConfirm: (results) {
                                  cubit.addSelectedList(results);
                                },
                              ),
                              CustomTextField(ctrl: cubit.liveDataController,hint: LocaleKeys.broadcastDate.tr(),suffixIcon:const Icon(Icons.calendar_today_outlined,color: AppColors.mainColor,),
                             readOnly: true,
                              onTap: (){
                                showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2101)).then((value) => cubit.selectDate(value));
                              },),
                              CustomTextField(ctrl: cubit.liveTimeController,hint: LocaleKeys.broadcastTime.tr(),suffixIcon:const Icon(Icons.access_time_outlined,color: AppColors.mainColor,),
                             readOnly: true,
                              onTap:(){
                                showTimePicker(context: context, initialTime: TimeOfDay.now(),).then((value) {
                                  cubit.getTime(val: value!);
                                },);
                              }),
                              CustomTextField(ctrl: cubit.notesController,hint: LocaleKeys.addNotesToStudent.tr()),
                              SizedBox(height: height*0.3),
                              state is BaseStatesLoadingState ?const Center(child: CustomLoading()):
                              CustomButton(text: LocaleKeys.create.tr(), onPressed: (){cubit.createLive();}, widthBtn: width*0.85)
                                                
                                                
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
