import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../utils/colors.dart';
import '../utils/size.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading(
      {super.key, this.fullScreen = false, this.col});
  final bool fullScreen;
  final Color? col;

  @override
  Widget build(BuildContext context) {
    return fullScreen
        ? Padding(
      padding: EdgeInsetsDirectional.symmetric(vertical: height*0.2),
      child: SpinKitPouringHourGlass(
        color: col ?? AppColors.mainColor,
        size: width*0.3,
      ),
    ): CircularProgressIndicator(
      color:col ?? AppColors.mainColor,
    );
  }
}