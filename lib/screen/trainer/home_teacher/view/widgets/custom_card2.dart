import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomCard2 extends StatelessWidget {
  final String img, text1, text2, textBtn;
  final Function()? onTap;

  const CustomCard2({
    super.key,
    required this.img,
    required this.text1,
    required this.text2,
    required this.textBtn,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 180),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        /// 💎 Soft premium shadow
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],

        /// subtle border for luxury feel
        border: Border.all(
          color: Colors.grey.shade100,
        ),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          /// 🟦 ICON CONTAINER (important)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xff0089A6).withOpacity(0.08),
            ),
            child: SvgPicture.asset(
              img,
              width: 34,
              height: 34,
            ),
          ),

          const SizedBox(height: 12),

          /// 🔥 TITLE
          Text(
            text1,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xff005560),
            ),
          ),

          const SizedBox(height: 6),

          /// ✨ SUBTITLE
          Text(
            text2,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 14),

          /// 🚀 BUTTON (premium style)
          SizedBox(
            width: double.infinity,
            height: 38,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff0089A6),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                textBtn,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}