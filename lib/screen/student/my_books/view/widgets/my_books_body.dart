import 'package:alfarid/core/utils/images.dart';
import 'package:alfarid/core/widgets/custom_loading.dart';
import 'package:alfarid/core/widgets/empty_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_arrow.dart';
import '../../../../../core/widgets/custom_btn.dart';
import '../../../../../core/widgets/custom_error.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../controller/books_cubit.dart';
import 'book_item.dart';

class MyBooksBody extends StatelessWidget {
  const MyBooksBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider<MyBooksCubit>(
            create: (context) => MyBooksCubit()..fetchBooks(),
            child:
                BlocBuilder<MyBooksCubit, BaseStates>(builder: (context, state) {
              var cubit = MyBooksCubit.get(context);
              return SafeArea(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    CustomArrow(text: LocaleKeys.myBooks.tr(),withArrow: false,),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.07, vertical: width * 0.08),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomButton(hit: height * 0.062,text: LocaleKeys.explore.tr(), onPressed: (){cubit.changeExplore(true);}, widthBtn: width*0.41,color: cubit.isExplore==true?true:false),
                                  CustomButton(hit: height * 0.062,text: LocaleKeys.myLibrary.tr(), onPressed: (){cubit.booksModel!.data!.items!.isEmpty?null: cubit.changeExplore(false);}, widthBtn: width*0.41,color: cubit.isExplore==false?true:false),
                                ],
                              ),

                            ])),
                        state is BaseStatesLoadingState ? const CustomLoading(fullScreen: true):
                        state is BaseStatesErrorState? CustomError(title: state.msg, onPressed: (){cubit.fetchBooks();}):
                        cubit.booksModel!.data!.items!.isEmpty? Center(child: EmptyList(img: AppImages.emptyBook, text: LocaleKeys.noBooks.tr())):
                        Expanded(
                          child: cubit.isExplore==true?
                          cubit.booksModel!.data!.items!.isEmpty? Center(child: EmptyList(img: AppImages.emptyBook, text: LocaleKeys.noBooks.tr())):
                          GridView.builder(
                            padding: EdgeInsetsDirectional.symmetric(horizontal: width*0.06),
                            itemCount:cubit.booksModel!.data!.items!.length,
                            gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2 ,
                              crossAxisSpacing: width*0.03,
                              mainAxisSpacing: width*0.03,
                              childAspectRatio: .71
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return BookItem(
                                img: cubit.booksModel!.data!.items![index].image.toString(),
                                name: cubit.booksModel!.data!.items![index].name.toString(),
                                classRoom: cubit.booksModel!.data!.items![index].classroom.toString(),
                                price: cubit.booksModel!.data!.items![index].price.toString(),
                                onTapCart: (){cubit.addToCart(bookId: cubit.booksModel!.data!.items![index].id!);},);
                            },
                          ):
                          cubit.myBooksModel!.data!.items!.isEmpty? Center(child: EmptyList(img: AppImages.emptyBook, text: LocaleKeys.noBooks.tr())):
                          GridView.builder(
                          padding: EdgeInsetsDirectional.symmetric(horizontal: width*0.06),
                          itemCount: cubit.myBooksModel!.data!.items!.length,
                          gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2 ,
                          crossAxisSpacing: width*0.03,
                          mainAxisSpacing: width*0.03,
                          childAspectRatio: .71
                          ),
                          itemBuilder: (BuildContext context, int index) {
                          return BookItem(
                          img: cubit.myBooksModel!.data!.items![index].image.toString(),
                          name: cubit.myBooksModel!.data!.items![index].name.toString(),
                          classRoom: cubit.myBooksModel!.data!.items![index].classroom.toString(),
                          file: cubit.myBooksModel!.data!.items![index].file.toString(),);
                          },
                          ),
                        ),
                        SizedBox(height: width*0.01,)

                  ]));
            })));
  }
}
