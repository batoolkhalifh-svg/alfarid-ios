import 'package:alfarid/core/widgets/empty_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/local/app_cached.dart';
import '../../../../../core/local/cache_helper.dart';
import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/my_navigate.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/widgets/custom_alert_dialogue.dart';
import '../../../../../core/widgets/custom_arrow.dart';
import '../../../../../core/widgets/custom_course_item.dart';
import '../../../../../core/widgets/custom_loading.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../course_details/view/course_details_screen.dart';
import '../../../home/view/controller/home_cubit.dart';
import '../../../home/view/controller/home_states.dart';
import '../../../home/view/view/widgets/custom_title_course_list.dart';

class ImportantCoursesBody extends StatelessWidget {
  ImportantCoursesBody({super.key});

  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(builder: (context, state) {
      final cubit = HomeCubit.get(context);
      controller.addListener(() {
        if (controller.position.maxScrollExtent == controller.offset) {
          cubit.currentPage == cubit.coursesModel!.data!.paginate!.totalPages ? null : cubit.nextCourses();
        }
      });
      return Scaffold(
          body: SafeArea(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CustomArrow(
          text: LocaleKeys.importantCourses.tr(),
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.07, vertical: width * 0.03),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const CustomTitleCourseList(
                withOutPadding: true,
              ),
              SizedBox(height: height * 0.008),
              state is LoadingHomeState2
                  ? Padding(
                      padding: EdgeInsets.only(top: width * 0.18),
                      child: const Center(
                          child: CustomLoading(
                        fullScreen: true,
                      )),
                    )
                  : cubit.coursesModel!.data!.items!.isEmpty
                      ? Center(
                          child: EmptyList(
                          img: AppImages.emptyCourses,
                          text: LocaleKeys.noCourses.tr(),
                        ))
                      : SizedBox(
                          height: height * 0.7,
                          child: ListView.separated(
                              controller: controller,
                              padding: EdgeInsetsDirectional.symmetric(vertical: height * 0.024),
                              itemBuilder: (context, index) {
                                return CustomCourseItem(
                                  img: cubit.data[index].image!,
                                  title: cubit.data[index].name.toString(),
                                  subTitle: cubit.data[index].subject.toString(),
                                  price: cubit.data[index].price.toString(),
                                  teacherName: cubit.data[index].teacher!.name.toString(),
                                  onTap: () {
                                    CacheHelper.getData(key: AppCached.token) == null
                                        ? showDialog(context: context, builder: (context) => const CustomAlertDialog())
                                        : navigateTo(
                                            widget: CourseDetailsScreen(
                                            id: cubit.data[index].id!,
                                          ));
                                  },
                                  isSaves: cubit.data[index].isFavourite,
                                  onTapSave: () {
                                    cubit.toggleSaved(id: cubit.data[index].id!, index: index);
                                  },
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(height: height * 0.018);
                              },
                              itemCount: cubit.data.length),
                        ),
            ])),
      ])));
    });
  }
}
