
class HomeTeacherStates{}

class HomeInitialState extends HomeTeacherStates{}
class HomeChangeState extends HomeTeacherStates{}
class LoadingHomeState extends HomeTeacherStates{}
class LoadingHomeState2 extends HomeTeacherStates{}
class SuccessHomeState extends HomeTeacherStates{}
class ErrorHomeState extends HomeTeacherStates{
 final String msg;
  ErrorHomeState({required this.msg});

}


