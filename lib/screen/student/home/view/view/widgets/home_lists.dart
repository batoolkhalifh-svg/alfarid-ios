import 'package:alfarid/core/utils/images.dart';
import 'package:alfarid/core/utils/size.dart';
import 'package:alfarid/core/widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../excellent_teacher/view/excellent_teacher_screen.dart';
import '../../../../important_courses/view/important_course_screen.dart';
import '../../controller/home_cubit.dart';
import '../../controller/home_states.dart';
import 'custom_row.dart';
import 'custom_title_course_list.dart';
import 'excellent_teacher_item.dart';
import 'important_list_item.dart';

class HomeLists extends StatelessWidget {
  HomeLists({super.key});

  final ScrollController controller = ScrollController();
  final ScrollController controllerTeacher = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(builder: (context, state) {
      final cubit = HomeCubit.get(context);
      controller.addListener(() {
        if (controller.position.maxScrollExtent == controller.offset) {
          cubit.currentPage == cubit.coursesModel!.data!.paginate!.totalPages ? null : cubit.nextCourses();
        }
      });
      controllerTeacher.addListener(() {
        if (controllerTeacher.position.maxScrollExtent == controllerTeacher.offset) {
          cubit.currentPageTeacher == cubit.teacherModel!.data!.paginate!.totalPages ? null : cubit.nextTeachers();
        }
      });
      return SliverToBoxAdapter(
        child: Column(
          children: [
            CustomRow(
              title: cubit.titles[0],
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) => BlocProvider.value(value: context.read<HomeCubit>(), child: const ImportantCoursesScreen())));
              },
            ),
            const CustomTitleCourseList(),
            SizedBox(
              height: height * .27,
              child: state is LoadingHomeState2
                  ? const Center(child: CustomLoading())
                  : cubit.coursesModel!.data!.items!.isEmpty
                      ? Image.asset(AppImages.emptyCourses, width: width * 0.4)
                      : ListView.separated(
                          controller: controller,
                          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                          itemCount: cubit.data.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return ImportantListItem(
                              index: index,
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              width: width * 0.02,
                            );
                          },
                        ),
            ),
            CustomRow(
              title: cubit.titles[1],
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) => BlocProvider.value(value: context.read<HomeCubit>(), child: const ExcellentTeacherScreen())));
              },
            ),
            SizedBox(
              height: height * .25,
              child: state is LoadingHomeState2
                  ? const Center(child: CustomLoading())
                  : cubit.teacherModel!.data!.items!.isEmpty
                      ? Image.asset(AppImages.emptyCourses, width: width * 0.4)
                      : ListView.separated(
                          controller: controllerTeacher,
                          padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: width * 0.02),
                          itemCount: cubit.dataTeacher.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return ExcellentTeacherItem(
                              index: index,
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              width: width * 0.02,
                            );
                          },
                        ),
            ),
            SizedBox(
              height: height * 0.020,
            ),
          ],
        ),
      );
    });
  }
}
