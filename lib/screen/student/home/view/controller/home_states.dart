
class HomeStates{}

class HomeInitialState extends HomeStates{}
class HomeChangeState extends HomeStates{}
class LoadingHomeState extends HomeStates{}
class LoadingHomeState2 extends HomeStates{}
class SuccessHomeState extends HomeStates{}
class ErrorHomeState extends HomeStates{
 final String msg;
  ErrorHomeState({required this.msg});

}


