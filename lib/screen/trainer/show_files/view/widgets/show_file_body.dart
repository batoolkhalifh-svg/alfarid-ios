import 'package:alfarid/core/utils/size.dart';
import 'package:alfarid/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_arrow.dart';
import '../../../../../core/widgets/custom_error.dart';
import '../../../../../core/widgets/custom_loading.dart';
import '../../../../../core/widgets/empty_list.dart';
import '../../../home_teacher/view/widgets/custom_blue_btn.dart';
import '../../controller/show_files_cubit.dart';

class ShowFilesBody extends StatelessWidget {
   const ShowFilesBody({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<ShowFilesCubit>(
          create: (context) => ShowFilesCubit()..getFiles(),
          child: BlocBuilder<ShowFilesCubit, BaseStates>(
              builder: (context, state) {
            var cubit = ShowFilesCubit.get(context);
            return SafeArea(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 CustomArrow(text: LocaleKeys.myFiles.tr()),
                  state is BaseStatesLoadingState? Padding(
                    padding:  EdgeInsets.only(top: width*0.35),
                    child: const CustomLoading(fullScreen: true,),
                  ):
                  state is BaseStatesErrorState ? CustomError(title: state.msg, onPressed: (){cubit.getFiles();}):
                  cubit.fileModel!.data!.items!.isEmpty?Center(child: EmptyList(img: AppImages.emptyCourses, text: LocaleKeys.emptyFiles.tr())):
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.07, vertical: width * 0.03),
                        child: ListView.separated(itemBuilder: (context, index){
                          return  Container(
                            padding: EdgeInsets.symmetric(horizontal: width*0.02,vertical: width*0.02),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(AppRadius.r15)
                            ),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text("${LocaleKeys.fileName.tr()} : ",style: Styles.textStyle12.copyWith(color: AppColors.mainColor,)),
                                        Text(cubit.fileModel!.data!.items![index].name.toString(),style: Styles.textStyle12.copyWith(color: AppColors.blackColor)),
                                      ],
                                    ),
                                    SizedBox(height: width*0.02),
                                    Row(
                                      children: [
                                        Text("${LocaleKeys.createdAt.tr()} : ",style: Styles.textStyle12.copyWith(color: AppColors.mainColor)),
                                        Text(cubit.fileModel!.data!.items![index].createdAt.toString(),style: Styles.textStyle12.copyWith(color: AppColors.blackColor)),
                                      ],
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  children: [
                                    CustomBlueButton(text:cubit.fileModel!.data!.items![index].type =="image"? LocaleKeys.showImage.tr():LocaleKeys.showFile.tr(),
                                      onTap: (){cubit.launcher(path: cubit.fileModel!.data!.items![index].path.toString());},),
                                    SizedBox(height: width*0.02,),
                                    GestureDetector(
                                        onTap:(){cubit.deleteFile(id: cubit.fileModel!.data!.items![index].id!);},
                                        child: const Icon(Icons.delete_outline,color: Colors.redAccent,)),
                                  ],
                                )
                              ],
                            ),
                          );
                        }, separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(height: height*0.01);
                        }, itemCount: cubit.fileModel!.data!.items!.length),),
                  ),

                ],
            ));
          })),
    );
  }
}
