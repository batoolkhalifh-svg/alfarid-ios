import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/size.dart';
import '../utils/styles.dart';

enum InputType { normal, pass , fill}


class CustomTextField extends StatefulWidget {
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();

  const CustomTextField({super.key, this.hint, this.type, this.contentPadding, this.ctrl, this.maxLines = 1, this.isEnabled, this.hintStyle, this.prefixIcon, this.haveSuffix = false, this.textType = InputType.normal, this.isCharOnly = false, this.suffixIcon, this.isEmail=false, this.onTap, this.readOnly, this.title, this.isSearch, this.withoutPadding=false, this.isPrefixImg=false, this.prefixImg, this.isPhone, this.withOutBorderColor });

  final String? hint;
  final String? title;
  final TextInputType? type;
  final IconData? prefixIcon;
  final InputType textType;
  final bool haveSuffix;
  final bool? readOnly ;
  final TextEditingController? ctrl;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLines;
  final bool? isEnabled;
  final TextStyle? hintStyle;
  final bool isCharOnly;
  final Widget? suffixIcon ;
  final bool? isEmail;
  final bool? isSearch;
  final Function()? onTap;
  final bool withoutPadding ;
  final bool isPrefixImg ;
  final String? prefixImg ;
  final bool? isPhone ;
  final bool? withOutBorderColor;
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool isObscure = widget.textType == InputType.pass ? true : false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top:height*.025 ),
      child:TextField(
        onTap: widget.onTap,
        enabled: widget.isEnabled,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.top,
        controller: widget.ctrl,
        maxLines: widget.maxLines,
        cursorColor: AppColors.mainColor,
        cursorHeight: 20,
        style: Styles.textStyle12.copyWith(color: AppColors.mainColor),
        decoration: InputDecoration(
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r6),
              borderSide: const BorderSide(width: .9,color: Colors.red,)),
          filled: true,
          fillColor:Colors.white,
          contentPadding: widget.contentPadding ?? EdgeInsets.symmetric(vertical: height * 0.022, horizontal: width * 0.03),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.r6)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.r6),borderSide:  BorderSide(color:widget.withOutBorderColor==true?Colors.transparent: AppColors.grayColorOp)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.r6),borderSide:  BorderSide(color: widget.withOutBorderColor==true?Colors.transparent:AppColors.grayColorOp)),
          disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.r6),borderSide:  BorderSide(color: widget.withOutBorderColor==true?Colors.transparent:AppColors.grayColorOp)),
          hintText: widget.hint,
          hintStyle: widget.hintStyle ?? Styles.textStyle12.copyWith(
              color: AppColors.grayColor
          ),
          prefixIcon:
          widget.isPrefixImg ?
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width*0.025),
            child: SvgPicture.asset(widget.prefixImg??""),
          ) :
          widget.prefixIcon==null ? null:
          Icon(widget.prefixIcon,size: width*.05,color: AppColors.grayColor),
          prefixIconConstraints: BoxConstraints(
            minWidth: width*.1,
            minHeight: width*.1,
          ),
          suffixIcon: widget.suffixIcon ?? (widget.haveSuffix ? GestureDetector(
            onTap: () {
              isObscure = !isObscure;
              setState(() {});
            },
            child: Icon(color: AppColors.grayColor,
              isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,size: width*.055,
            ),
          ) : null) ,
        ),
        keyboardType: widget.isEmail== true ? TextInputType.emailAddress : widget.isPhone== true ? TextInputType.number : widget.type,
        obscureText:  isObscure,
        readOnly:widget.readOnly??false,
        inputFormatters: widget.isCharOnly ?
        [
          FilteringTextInputFormatter.allow(RegExp(
            r"[a-z\u0621-\u064a A-Z]",
          ))
        ] :
        widget.isEmail== true ? [
          FilteringTextInputFormatter.allow(RegExp("[a-z A-Z 0-9 @ . ! # % & ' * + - / = ? ^ _ ` { }|]"))
        ] :
        widget.isPhone ==true ?[FilteringTextInputFormatter.digitsOnly
        ] :[],
      ),
    );
  }
}