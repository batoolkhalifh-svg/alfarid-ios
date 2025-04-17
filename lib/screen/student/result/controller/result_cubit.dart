import 'package:alfarid/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../core/utils/images.dart';



class ResultCubit extends Cubit<BaseStates> {
  ResultCubit() : super(BaseStatesInitState());

  static ResultCubit get(context) => BlocProvider.of(context);

  List resultsImages=[
    AppImages.question,
    AppImages.time,
    AppImages.starBlue,
    AppImages.question
  ];
  List resultsText=[
    LocaleKeys.numberOfQuestions.tr(),
    LocaleKeys.timeTaken.tr(),
    LocaleKeys.numberOfCorrectQuestions.tr(),
    LocaleKeys.overallScore.tr(),
  ];




}