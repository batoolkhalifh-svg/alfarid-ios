// student_selection_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentSelectionCubit extends Cubit<Map<String, dynamic>> {
  StudentSelectionCubit() : super({});

  void setSelection({required String schoolType}) {
    emit({'schoolType': schoolType});
  }

  Map<String, dynamic> get selection => state;
}
