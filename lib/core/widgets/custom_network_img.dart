
import 'package:flutter/material.dart';
import '../utils/images.dart';

class CustomNetworkImg extends StatelessWidget {
  const CustomNetworkImg({super.key, required this.img,  this.width, this.height, this.clr, this.fit,});
  final String img;
  final double? width;
  final double? height;
  final Color? clr;
  final BoxFit? fit;
  @override
  Widget build(BuildContext context) {
    return Image.network(
      img,
      width: width,
      height: height,
      color: clr,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        AppImages.noImage,
        width: width,
        height: height,
        fit:fit?? BoxFit.scaleDown,
        matchTextDirection: true,
      ),
      fit: BoxFit.fill,
    );
  }
}
