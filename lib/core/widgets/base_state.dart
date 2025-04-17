abstract class BaseStates {}

class BaseStatesInitState extends BaseStates {}

class BaseStatesLoadingState extends BaseStates {}
class BaseStatesLoadingState2 extends BaseStates {}
class BaseStatesLoadingState3 extends BaseStates {}

class BaseStatesErrorState extends BaseStates {
  final String msg;
  BaseStatesErrorState({required this.msg});
}

class BaseStatesSuccessState extends BaseStates {}

class BaseStatesChangeState extends BaseStates {}
class BaseStatesError2State extends BaseStates {}