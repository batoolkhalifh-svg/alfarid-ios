class ChatDetailsStates{}

class ChatDetailsInitState extends ChatDetailsStates{}
class ChatDetailsLoadingState extends ChatDetailsStates{}
class ChatDetailsSuccessState extends ChatDetailsStates{}
class ChatDetailsFailedState extends ChatDetailsStates{
  final String error;

  ChatDetailsFailedState({required this.error});
}
