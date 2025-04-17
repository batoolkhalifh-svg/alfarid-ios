import 'package:flutter/material.dart';

import '../utils/size.dart';
import '../utils/styles.dart';

class EmptyList extends StatelessWidget {
  final String img;
  final String text;
  const EmptyList({super.key, required this.img, required this.text});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:EdgeInsetsDirectional.symmetric(vertical: height*0.2),
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(img,width: width*0.4),
          SizedBox(height: height*0.02),
          Text(text, style: Styles.textStyle16)
        ],
      ),
    );
  }
}