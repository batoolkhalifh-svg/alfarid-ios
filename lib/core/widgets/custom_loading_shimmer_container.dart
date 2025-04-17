import 'package:flutter/material.dart';

class CustomLoadingShimmerContainer extends StatelessWidget {
  const CustomLoadingShimmerContainer({super.key,  this.wdt,  this.hgt, this.child});
  final double? wdt,hgt;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: wdt,
      height: hgt,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.04),
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }
}