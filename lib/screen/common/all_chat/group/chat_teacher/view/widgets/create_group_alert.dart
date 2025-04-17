import 'package:alfarid/core/utils/size.dart';
import 'package:alfarid/core/widgets/custom_btn.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import '../../../../../../../core/utils/colors.dart';
import '../../../../../../../core/utils/styles.dart';
import '../../../../../../../core/widgets/base_state.dart';
import '../../../../../../../core/widgets/custom_loading.dart';
import '../../../../../../../core/widgets/custom_textfield.dart';
import '../../../../../../../generated/locale_keys.g.dart';
import '../../../../../../trainer/start_live/model/student_model.dart';
import '../../controller/chat_teacher_cubit.dart';

class CreateGroupAlert extends StatelessWidget {
  const CreateGroupAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatTeacherCubit,BaseStates>(
        builder: (context,state) {
      ChatTeacherCubit cubit = BlocProvider.of(context);
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r20),
        ),
        titlePadding: EdgeInsets.zero,
        title: Container(
          decoration: BoxDecoration(
            color: AppColors.onBoardingBgColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(AppRadius.r20),
              topLeft: Radius.circular(AppRadius.r20),
            ),
          ),
          padding:  EdgeInsets.all(width*0.04),
          child: Center(
            child: Text(
              LocaleKeys.createGroupChat.tr(),
            ),
          ),
        ),
        content: SizedBox(
          width: width * 0.8,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(ctrl: cubit.groupName, hint: LocaleKeys.groupName.tr()),
                SizedBox(height: width*0.07),
                state is BaseStatesLoadingState2? const Center(child: CustomLoading()):
                cubit.studentsModel!.data!.isEmpty ? Text(LocaleKeys.emptyStudents.tr(),style: Styles.textStyle14.copyWith(color: AppColors.mainColorText),):
                MultiSelectDialogField(
                   items: cubit.studentsModel!.data!.map((student) => MultiSelectItem<DataS>(student, student.name!)).toList(),
                  // items: [],
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
              ],
            ),
          ),
        ),
        actions: [
          state is BaseStatesLoadingState? const Center(child: CustomLoading()):
          CustomButton(
           text: LocaleKeys.create.tr(), onPressed: () {
             cubit.createGroup(students: cubit.selectedId);
          }, widthBtn: width*0.7,
          ),
        ],
      );
    });
  }
}
