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

  /// true => استكشاف
  /// false => مكتبتي
  bool isExplore = true;

  void changeExplore(bool explore) {
    isExplore = explore;
    emit(BaseStatesChangeState());
  }

  // بيانات الكتب
  BooksModel booksModel = BooksModel(data: Data(items: []));
  BooksModel myBooksModel = BooksModel(data: Data(items: []));

  /// جلب كل الكتب
  Future<void> getAllBooks() async {
    try {
      Map<dynamic, dynamic> response =
      await myDio(endPoint: AppConfig.allBooks, dioType: DioType.get);
      debugPrint("All Books Response: $response");

      if (response["status"] == true && response["data"] != null) {
        booksModel = BooksModel.fromJson(response);
      } else {
        booksModel = BooksModel(data: Data(items: []));
        debugPrint("No books found or response invalid");
      }
    } catch (e) {
      booksModel = BooksModel(data: Data(items: []));
      debugPrint("Error fetching all books: $e");
    }
  }

  /// جلب مكتبتي
  Future<void> getMyBook() async {
    try {
      Map<dynamic, dynamic> response =
      await myDio(endPoint: AppConfig.myBooks, dioType: DioType.get);
      debugPrint("My Books Response: $response");

      if (response["status"] == true && response["data"] != null) {
        myBooksModel = BooksModel.fromJson(response);
      } else {
        myBooksModel = BooksModel(data: Data(items: []));
        debugPrint("No books in my library");
      }
    } catch (e) {
      myBooksModel = BooksModel(data: Data(items: []));
      debugPrint("Error fetching my books: $e");
    }
  }

  /// تحميل البيانات للواجهتين
  Future<void> fetchBooks() async {
    emit(BaseStatesLoadingState());

    await getAllBooks();
    await getMyBook();

    // حتى لو كانت البيانات فارغة، نرسل Success لتفعيل الواجهة
    emit(BaseStatesSuccessState());
  }

  /// إضافة إلى السلة
  Future<void> addToCart({required int bookId}) async {
    emit(BaseStatesChangeState());
    final formData = {
      "type": "books",
      "item_id": bookId,
    };
    debugPrint("Add to cart formData: $formData");

    try {
      Map<dynamic, dynamic> response = await myDio(
        dioBody: formData,
        endPoint: AppConfig.addToCart,
        dioType: DioType.post,
      );
      debugPrint("Add to cart response: $response");

      if (response['status'] == true) {
        showToast(text: response['message'], state: ToastStates.success);
        emit(BaseStatesSuccessState());
      } else {
        showToast(text: response['message'], state: ToastStates.error);
        emit(BaseStatesError2State());
      }
    } catch (e) {
      showToast(text: "حدث خطأ أثناء الإضافة", state: ToastStates.error);
      debugPrint("Error addToCart: $e");
      emit(BaseStatesError2State());
    }
  }
}
