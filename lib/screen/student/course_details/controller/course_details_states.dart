part of 'course_details_cubit.dart';
abstract class CourseDetailsStates {}

class CourseDetailsInitialState extends CourseDetailsStates {}
class ChangeTabsState extends CourseDetailsStates {}
class CourseDetailsLoadingState extends CourseDetailsStates {}
class SubscribeLoadingState extends CourseDetailsStates {}

class CourseDetailsErrorState extends CourseDetailsStates {
  final String msg;
  CourseDetailsErrorState({required this.msg});
}

class CourseDetailsSuccessState extends CourseDetailsStates {}
class CourseDetailsSChangeVideoState extends CourseDetailsStates {}
class DoneChangeState extends CourseDetailsStates {}

