
class OnBoardingStates{}

class OnBoardingInitialState extends OnBoardingStates{}

class OnBoardingChangedState extends OnBoardingStates{}

class ChangeIsLastState extends OnBoardingStates{}

class ChangeIsSecPageState extends OnBoardingStates{}
class OnBoardingLoadingState extends OnBoardingStates{}
class OnBoardingSuccessState extends OnBoardingStates{}
class OnBoardingFailedState extends OnBoardingStates{
  final String msg;
  OnBoardingFailedState({required this.msg});
}
