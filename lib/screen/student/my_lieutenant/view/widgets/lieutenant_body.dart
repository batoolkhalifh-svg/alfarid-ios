import 'package:alfarid/core/utils/images.dart';
import 'package:alfarid/core/widgets/custom_loading.dart';
import 'package:alfarid/core/widgets/empty_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_arrow.dart';
import '../../../../../core/widgets/custom_btn.dart';
import '../../../../../core/widgets/custom_error.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../controller/lieutenant_cubit.dart';
import 'lieutenant_item.dart';

class LieutenantBody extends StatelessWidget {
  const LieutenantBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider<LieutenantCubit>(
            create: (context) => LieutenantCubit()..fetchLieutenants(),
            child: BlocBuilder<LieutenantCubit, BaseStates>(builder: (context, state) {
              var cubit = LieutenantCubit.get(context);
              return SafeArea(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CustomArrow(
                  text: LocaleKeys.lieutenant.tr(),
                  withArrow: false,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.07, vertical: width * 0.08),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomButton(
                              hit: height * 0.062,
                              text: LocaleKeys.explore.tr(),
                              onPressed: () {
                                cubit.changeExplore(true);
                              },
                              widthBtn: width * 0.41,
                              color: cubit.isExplore == true ? true : false),
                          CustomButton(
                              hit: height * 0.062,
                              text: LocaleKeys.myLibrary.tr(),
                              onPressed: () {
                                cubit.allLieutenantModel!.data!.items!.isEmpty ? null : cubit.changeExplore(false);
                              },
                              widthBtn: width * 0.41,
                              color: cubit.isExplore == false ? true : false),
                        ],
                      ),
                    ])),
                state is BaseStatesLoadingState
                    ? const CustomLoading(fullScreen: true)
                    : state is BaseStatesErrorState
                        ? CustomError(
                            title: state.msg,
                            onPressed: () {
                              cubit.fetchLieutenants();
                            })
                        : cubit.allLieutenantModel!.data!.items!.isEmpty
                            ? Center(child: EmptyList(img: AppImages.emptyBook, text: LocaleKeys.noBooks.tr()))
                            : Expanded(
                                child: cubit.isExplore == true
                                    ? cubit.allLieutenantModel!.data!.items!.isEmpty
                                        ? Center(child: EmptyList(img: AppImages.emptyBook, text: LocaleKeys.noBooks.tr()))
                                        : GridView.builder(
                                            padding: EdgeInsetsDirectional.symmetric(horizontal: width * 0.06),
                                            itemCount: cubit.allLieutenantModel!.data!.items!.length,
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: width * 0.03,
                                                mainAxisSpacing: width * 0.03,
                                                childAspectRatio: .6),
                                            itemBuilder: (BuildContext context, int index) {
                                              return LieutenantItem(
                                                img: cubit.allLieutenantModel!.data!.items![index].image.toString(),
                                                name: cubit.allLieutenantModel!.data!.items![index].name.toString(),
                                                classRoom: cubit.allLieutenantModel!.data!.items![index].classroom!.name.toString(),
                                                subject: cubit.allLieutenantModel!.data!.items![index].subject!.name.toString(),
                                                price: cubit.allLieutenantModel!.data!.items![index].price.toString(),
                                                onTapCart: () {
                                                  cubit.addToCart(bookId: cubit.allLieutenantModel!.data!.items![index].id!);
                                                },
                                              );
                                            },
                                          )
                                    : cubit.myAllLieutenantModel!.data!.items!.isEmpty
                                        ? Center(child: EmptyList(img: AppImages.emptyBook, text: LocaleKeys.noBooks.tr()))
                                        : GridView.builder(
                                            padding: EdgeInsetsDirectional.symmetric(horizontal: width * 0.06),
                                            itemCount: cubit.myAllLieutenantModel!.data!.items!.length,
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: width * 0.03,
                                                mainAxisSpacing: width * 0.03,
                                                childAspectRatio: .555),
                                            itemBuilder: (BuildContext context, int index) {
                                              return LieutenantItem(
                                                img: cubit.allLieutenantModel!.data!.items![index].image.toString(),
                                                name: cubit.myAllLieutenantModel!.data!.items![index].name.toString(),
                                                classRoom: cubit.myAllLieutenantModel!.data!.items![index].classroom!.name.toString(),
                                                subject: cubit.allLieutenantModel!.data!.items![index].subject!.name.toString(),
                                                file: cubit.myAllLieutenantModel!.data!.items![index].file.toString(),
                                                onTapExam: () {
                                                  cubit.getLieutenantExam(id: cubit.allLieutenantModel!.data!.items![index].id!);
                                                },
                                              );
                                            },
                                          ),
                              ),
                SizedBox(
                  height: width * 0.01,
                )
              ]));
            })));
  }
}
