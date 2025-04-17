import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_arrow.dart';
import '../../../../../core/widgets/custom_course_item.dart';
import '../../../../../core/widgets/custom_error.dart';
import '../../../../../core/widgets/custom_loading.dart';
import '../../../../../core/widgets/empty_list.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../controller/my_saves_cubit.dart';

class MySavesBody extends StatelessWidget {
  const MySavesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider<MySavesCubit>(
            create: (context) => MySavesCubit()..fetchSaved(),
            child:
                BlocBuilder<MySavesCubit, BaseStates>(builder: (context, state) {
                var cubit = MySavesCubit.get(context);
                return SafeArea(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    CustomArrow(text: LocaleKeys.mySaves.tr(),),
                        state is BaseStatesLoadingState? Padding(
                          padding:  EdgeInsets.only(top: height*0.12),
                          child: const CustomLoading(fullScreen: true,),
                        ):
                        state is BaseStatesErrorState ? CustomError(title: state.msg, onPressed: (){cubit.fetchSaved();}):
                        cubit.savedModel!.data!.items!.isEmpty?Padding(
                          padding: EdgeInsets.only(top: height*0.08),
                          child: Center(child: EmptyList(img: AppImages.emptySaved, text:LocaleKeys.noCourses.tr())),
                        ):
                    Expanded(
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: width * 0.07, vertical: width * 0.03),
                          child: ListView.separated(
                                  padding: EdgeInsetsDirectional.symmetric(vertical: height*0.024),
                                  itemBuilder: (context, index){
                                    return  CustomCourseItem(isSaves: true,
                                      img: cubit.savedModel!.data!.items![index].course!.image!,
                                      title:  cubit.savedModel!.data!.items![index].course!.name!,
                                      subTitle: cubit.savedModel!.data!.items![index].course!.classroom!,
                                      price:  cubit.savedModel!.data!.items![index].course!.price.toString(), onTap: () {
                                      cubit.toggleSaved(id: cubit.savedModel!.data!.items![index].course!.id!); },);
                                    }, separatorBuilder: (context, index){
                                return SizedBox(height: height*0.018);
                              }, itemCount: cubit.savedModel!.data!.items!.length)),
                    ),
                  ]));
            })));
  }
}
