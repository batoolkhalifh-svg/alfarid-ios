
import 'package:alfarid/core/utils/size.dart';
import 'package:alfarid/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_arrow.dart';
import '../../../../../core/widgets/custom_btn.dart';
import '../../../../../core/widgets/custom_drop_down.dart';
import '../../../../../core/widgets/custom_loading.dart';
import '../../../../../core/widgets/custom_textfield.dart';
import '../../../home_teacher/view/widgets/custom_blue_btn.dart';
import '../../controller/upload_file_cubit.dart';

class UploadFileBody extends StatelessWidget {
   const UploadFileBody({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<UploadFileCubit>(
          create: (context) => UploadFileCubit(),
          child: BlocBuilder<UploadFileCubit, BaseStates>(
              builder: (context, state) {
            var cubit = UploadFileCubit.get(context);
            return SafeArea(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 CustomArrow(text: LocaleKeys.downloadFile.tr()),
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.07, vertical: width * 0.03),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              CustomTextField(ctrl: cubit.nameFileController,hint: LocaleKeys.fileName.tr()),
                              SizedBox(height: width*0.04),
                              CustomDropDown(
                                onChanged: (v){
                                  cubit.changeDropdownType(id: v!);
                                },
                                dropDownValue: cubit.dropdownType,
                                items: List.generate(cubit.fileTypeList.length,(index) =>
                                    DropdownMenuItem(value: cubit.fileTypeList[index]["id"],
                                        child: Text(cubit.fileTypeList[index]["name"]))),
                                hintText: LocaleKeys.fileType.tr(),
                              ),
                              SizedBox(height: height*0.1),
                              cubit.selectedFile==null?  SizedBox(height: height*0.05):
                              CustomBlueButton(text: "${cubit.dropdownType=='image'?LocaleKeys.showImage.tr():LocaleKeys.showFile.tr()}${cubit.fileName}",onTap: (){cubit.openPDFOrImage();},
                              fontSize: AppFonts.t14,),
                              SizedBox(height: height*0.42),
                              state is BaseStatesLoadingState ?const Center(child: CustomLoading()):
                              CustomButton(text: LocaleKeys.downloadFile.tr(), onPressed: (){cubit.createFile();}, widthBtn: width*0.85),
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
