import 'package:alfarid/core/utils/styles.dart';
import 'package:alfarid/core/widgets/custom_btn.dart';
import 'package:alfarid/core/widgets/custom_error.dart';
import 'package:alfarid/core/widgets/custom_loading.dart';
import 'package:alfarid/core/widgets/custom_textfield.dart';
import 'package:alfarid/core/widgets/empty_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/size.dart';
import '../../../../../core/widgets/base_state.dart';
import '../../../../../core/widgets/custom_arrow.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../controller/cart_cubit.dart';
import 'cart_item.dart';

class CartBody extends StatelessWidget {
  const CartBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider<CartCubit>(
            create: (context) => CartCubit()..getMyCart(),
            child: BlocBuilder<CartCubit, BaseStates>(builder: (context, state) {
              var cubit = CartCubit.get(context);
              return SafeArea(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CustomArrow(
                  text: LocaleKeys.cart.tr(),
                ),
                state is BaseStatesLoadingState
                    ? Padding(
                        padding: EdgeInsets.only(top: width * 0.35),
                        child: const CustomLoading(
                          fullScreen: true,
                        ),
                      )
                    : state is BaseStatesErrorState
                        ? Padding(
                            padding: EdgeInsets.only(top: width * 0.1),
                            child: CustomError(
                                title: state.msg,
                                onPressed: () {
                                  cubit.getMyCart();
                                }),
                          )
                        : cubit.myMyCartModel!.data == null || cubit.myMyCartModel!.data!.items!.isEmpty
                            ? Padding(
                                padding: EdgeInsets.only(top: width * 0.1),
                                child: Center(child: EmptyList(img: AppImages.emptyCart, text: LocaleKeys.noCart.tr())),
                              )
                            : Expanded(
                                child: SingleChildScrollView(
                                  child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: width * 0.07, vertical: width * 0.03),
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        CustomTextField(
                                          ctrl: cubit.discountCtrl,
                                          prefixImg: AppImages.discount,
                                          isPrefixImg: true,
                                          hint: LocaleKeys.discountCoupon.tr(),
                                          suffixIcon: InkWell(
                                              onTap: () {
                                                FocusScope.of(context).unfocus();
                                                cubit.applyDiscount();
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: state is BaseStatesLoadingState2
                                                    ? const CustomLoading()
                                                    : Text(
                                                        LocaleKeys.apply.tr(),
                                                        style: Styles.textStyle16.copyWith(fontSize: AppFonts.t14),
                                                      ),
                                              )),
                                        ),
                                        SizedBox(height: height * 0.015),
                                        SizedBox(
                                          height: height * 0.67,
                                          child: ListView.separated(
                                              padding: EdgeInsetsDirectional.symmetric(vertical: height * 0.024),
                                              itemBuilder: (context, index) {
                                                return CartItem(
                                                  name: cubit.myMyCartModel!.data!.items![index].name.toString(),
                                                  img: cubit.myMyCartModel!.data!.items![index].image.toString(),
                                                  price: cubit.myMyCartModel!.data!.items![index].price.toString(),
                                                  onTapDelete: () {
                                                    cubit.deleteCart(itemId: cubit.myMyCartModel!.data!.items![index].id!);
                                                  },
                                                );
                                              },
                                              separatorBuilder: (context, index) {
                                                return SizedBox(height: height * 0.018);
                                              },
                                              itemCount: cubit.myMyCartModel!.data!.items!.length),
                                        ),
                                        state is BaseStatesLoadingState3
                                            ? const Center(child: CustomLoading())
                                            : CustomButton(
                                                text: LocaleKeys.buyBooks.tr(),
                                                onPressed: () {
                                                  // CacheHelper.getData(key: AppCached.isApple) == true
                                                  //     ?
                                                  cubit.buyBookFromCart();
                                                  // : navigateTo(
                                                  //     widget: PaymentScreen(price: cubit.myMyCartModel!.data!.totalAfterDiscount!));
                                                  // cubit.buyBookFromCart();
                                                },
                                                widthBtn: width * 0.84)
                                      ])),
                                ),
                              ),
              ]));
            })));
  }
}
