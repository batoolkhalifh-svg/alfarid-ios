abstract class StartVrStates {}

class StartVrInitialState extends StartVrStates {}

class StartVrChangeState extends StartVrStates {}

class StartVrLoadingState extends StartVrStates {}

class StartVrSuccessState extends StartVrStates {}

class StartVrErrorState extends StartVrStates {
  final String msg;

  StartVrErrorState(this.msg);
}