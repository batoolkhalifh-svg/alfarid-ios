import 'package:flutter/material.dart';
import '../utils/size.dart';


class CustomPadding extends StatelessWidget {
  const CustomPadding({super.key, required this.widget});
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * .06),
        child: widget,
      ),
    );
  }
}