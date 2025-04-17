import 'package:alfarid/screen/trainer/order_details/view/widgets/order_details_body.dart';
import 'package:flutter/material.dart';


class OrderDetailsScreen extends StatelessWidget {
  final int id;
  const OrderDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return  OrderDetailsBody(id: id,);
  }
}
