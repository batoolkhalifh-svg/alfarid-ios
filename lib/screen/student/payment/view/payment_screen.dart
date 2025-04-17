
import 'package:flutter/material.dart';
import 'widgets/payment_body.dart';

class PaymentScreen extends StatelessWidget {
  final int price;
  const PaymentScreen({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return PaymentBody(price: price,);
  }
}
