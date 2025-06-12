import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/size.dart';
import '../../controller/payment_cubit.dart';
import '../../controller/payment_states.dart';

class PaymentBody extends StatelessWidget {
  final int price;
  const PaymentBody({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => PaymentCubit(),
        child: BlocBuilder<PaymentCubit,PaymentStates>(
        builder: (context, state) {
        final cubit = BlocProvider.of<PaymentCubit>(context);
         return Scaffold(
           body: SafeArea(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Expanded(
                     child:
                     SingleChildScrollView(
                     child: Padding(
                         padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: width*0.2),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             Column(
                               children: [
                                 // CreditCard(
                                 //   locale: context.locale.languageCode =="ar"?const Localization.ar():const Localization.en(),
                                 //   config: PaymentConfig(
                                 //    publishableApiKey: "pk_test_r6eZg85QyduWZ7PNTHT56BFvZpxJgNJ2PqPMDoXA",
                                 //     amount:price, // SAR 257.58
                                 //     description: context.locale.languageCode =="ar"? 'الفريد':'Alfarid',
                                 //     metadata: {'size': '250g'},
                                 //     currency: 'SAR',
                                 //   ),
                                 //   onPaymentResult: (result) {
                                 //     if (result is PaymentResponse) {
                                 //       result.status==PaymentStatus.paid? cubit.buyBookFromCart():
                                 //       showToast(text:"فشلت عملية الدفع", state: ToastStates.error);
                                 //     }
                                 //   },
                                 // ),
                               ],
                             ),
                           ],)
                     ),
                   ),
                 ),
               ],
             ),
           ),
         );
    }));
  }
}
