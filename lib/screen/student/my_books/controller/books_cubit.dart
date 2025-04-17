import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../core/local/app_config.dart';
import '../../../../core/remote/my_dio.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../model/book_model.dart';



class MyBooksCubit extends Cubit<BaseStates> {
  MyBooksCubit() : super(BaseStatesInitState());

  static MyBooksCubit get(context) => BlocProvider.of(context);

  bool isExplore=true;
  void changeExplore(current){
    isExplore=current;
    emit(BaseStatesChangeState());
  }

  BooksModel? booksModel;
  Future<void> getAllBooks()async{
    Map<dynamic,dynamic> response =await myDio(endPoint: AppConfig.allBooks, dioType: DioType.get);
    debugPrint(response.toString());
    if(response["status"]==true){
      booksModel = BooksModel.fromJson(response);
    }else{
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }

  BooksModel? myBooksModel;
  Future<void> getMyBook()async{
    Map<dynamic,dynamic> response =await myDio(endPoint: AppConfig.myBooks, dioType: DioType.get);
    debugPrint(response.toString());
    if(response["status"]==true){
      myBooksModel = BooksModel.fromJson(response);
    }else{
      emit(BaseStatesErrorState(msg: response["message"]));
    }
  }
  fetchBooks()async{
    emit(BaseStatesLoadingState());
    await Future.wait([getAllBooks(),getMyBook()]);
    state is BaseStatesErrorState ? null : emit(BaseStatesSuccessState());
  }

  ///AddToCart
  Future<void> addToCart({required int bookId})async{
    emit(BaseStatesChangeState());
    final formData= ({
      "type":"books",
      "item_id" : bookId,
    });
    debugPrint(formData.toString());
    Map<dynamic, dynamic> response = await myDio(
        dioBody: formData,
        endPoint: AppConfig.addToCart,
        dioType: DioType.post);
    debugPrint(response.toString());
    if(response['status'] ==true){
      showToast(text: response['message'], state: ToastStates.success);
      emit(BaseStatesSuccessState());
    }else{
      showToast(text: response['message'], state: ToastStates.error);
      emit(BaseStatesError2State());
    }}

}