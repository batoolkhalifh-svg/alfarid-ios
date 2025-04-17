import 'package:flutter/material.dart';

class CustomLoadingShimmerCircle extends StatelessWidget {
  const CustomLoadingShimmerCircle({super.key,  this.radius, });
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.black.withOpacity(.04),
      radius: radius,
    );
  }
}