import 'package:alfarid/core/utils/styles.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/size.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double widthBtn;
  final TextStyle? style;
  final bool? color;
  final double? hit;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.widthBtn,
    this.style,
    this.color = true,
    this.hit,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widthBtn,
          height: hit ?? height * 0.075,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: color == true
                ? const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.mainColor,
                AppColors.mainColor2,
              ],
            )
                : null,
            color: color == false ? Colors.white : null,
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.mainColor.withOpacity(0.22),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
            child: Center(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: style ??
                    TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: color == true
                          ? Colors.white
                          : AppColors.mainColor,
                      letterSpacing: 0.3,
                    ),
              ),
            ),
        ),
      ),
    );
  }
}