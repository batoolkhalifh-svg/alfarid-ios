
import 'package:alfarid/core/widgets/custom_btn.dart';
import 'package:alfarid/screen/student/my_points/view/widgets/point_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_arrow.dart';
import '../../../../../core/widgets/custom_error.dart';
import '../../../../../core/widgets/custom_loading.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../controller/my_points_cubit.dart';

class MyPointsBody extends StatelessWidget {
  const MyPointsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider<MyPointsCubit>(
            create: (context) => MyPointsCubit()..getMyPoints(),
            child:
                BlocBuilder<MyPointsCubit, BaseStates>(builder: (context, state) {
              var cubit = MyPointsCubit.get(context);
              return SafeArea(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    CustomArrow(text: LocaleKeys.thePoints.tr(),),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.07, vertical: width * 0.03),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomButton(hit: height * 0.062,text: LocaleKeys.thisWeek.tr(), onPressed: (){cubit.changeCPoints(true);}, widthBtn: width*0.41,color: cubit.isWeek==true?true:false),
                                  CustomButton(hit: height * 0.062,text: LocaleKeys.thisMonth.tr(), onPressed: (){cubit.changeCPoints(false);}, widthBtn: width*0.41,color: cubit.isWeek==false?true:false),
                                ],
                              ),
                              SizedBox(height: height*0.02),
                              // Container(
                              //   height: height*0.18,
                              //   width: width*0.86,
                              //   padding: EdgeInsetsDirectional.symmetric(horizontal: width*0.035,vertical: width*0.035),
                              //   decoration: BoxDecoration(
                              //       image: const DecorationImage(image: AssetImage(AppImages.pointsBg),fit: BoxFit.fill),
                              //       borderRadius: BorderRadius.circular(AppRadius.r10)
                              //   ),
                              //   child:Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //     children: List.generate(3, (index){
                              //       return Column(
                              //         children: [
                              //           Stack(
                              //             alignment: AlignmentDirectional.topEnd,
                              //             children: [
                              //               Padding(
                              //                 padding: const EdgeInsets.all(8.0),
                              //                 child: CircleAvatar(
                              //                   radius:index.isEven?AppRadius.r20: AppRadius.r30,
                              //                   backgroundColor: Colors.transparent,
                              //                   backgroundImage:  const AssetImage( "assets/images/test5.png"),
                              //                 ),
                              //               ),
                              //               CircleAvatar(
                              //                 radius:index.isEven?AppRadius.r10: AppRadius.r15,
                              //                 backgroundColor: AppColors.grayColor3,
                              //                 child: Text("5",style: Styles.textStyle14.copyWith(
                              //                     color: Colors.white,
                              //                     fontFamily: AppFonts.iBMPlexSansArabicRegular
                              //                 ),),
                              //               ),
                              //             ],
                              //           ),
                              //           Text("احمد محمد",style: Styles.textStyle12.copyWith(fontWeight: FontWeight.bold,color: Colors.white),),
                              //           SizedBox(height: width*0.01),
                              //           Text("80",style: Styles.textStyle14.copyWith(fontWeight: FontWeight.bold,color: Colors.white),)
                              //
                              //         ],
                              //       );
                              //     }),
                              //   ) ,
                              // ),
                              state is BaseStatesLoadingState? Padding(
                                padding:  EdgeInsets.only(top: width*0.35),
                                child: const CustomLoading(fullScreen: true,),
                              ):
                              state is BaseStatesErrorState ? Padding(
                                padding:EdgeInsets.only(top: width*0.1),
                                child: CustomError(title: state.msg, onPressed: (){cubit.getMyPoints();}),
                              ):
                              SizedBox(
                              height: height*0.76,
                              child: ListView.separated(
                                    padding: EdgeInsetsDirectional.symmetric(vertical: height*0.024),
                                    itemBuilder: (context, index){
                                      return cubit.isWeek==true?PointItem(score: cubit.myPointModel!.data!.weekPoints![index].score.toString(),
                                        name: cubit.myPointModel!.data!.weekPoints![index].student!.name.toString(), img: cubit.myPointModel!.data!.weekPoints![index].student!.image.toString(),):
                                      PointItem(score: cubit.myPointModel!.data!.monthPoints![index].score.toString(),
                                        name: cubit.myPointModel!.data!.monthPoints![index].student!.name.toString(), img: cubit.myPointModel!.data!.monthPoints![index].student!.image.toString(),);
                                      }, separatorBuilder: (context, index){
                                  return SizedBox(height: height*0.018);
                                }, itemCount:cubit.isWeek==true?cubit.myPointModel!.data!.weekPoints!.length:cubit.myPointModel!.data!.monthPoints!.length),
                          ),

                        ])),
                  ]));
            })));
  }
}
