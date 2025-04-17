abstract class TeacherLiveStates {}

class TeacherLiveInitialState extends TeacherLiveStates {}
class GetLivesLoading extends TeacherLiveStates {}
class GetLivesSuccess extends TeacherLiveStates {}
class GetLivesError extends TeacherLiveStates {}