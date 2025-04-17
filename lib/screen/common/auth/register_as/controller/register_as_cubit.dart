import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/base_state.dart';


class RegisterAsCubit extends Cubit<BaseStates> {
  RegisterAsCubit() : super(BaseStatesInitState());

  static RegisterAsCubit get(context) => BlocProvider.of(context);

  bool? isUser;
  void changeUser(bool type){
    isUser=type;
    emit(BaseStatesChangeState());
  }

}