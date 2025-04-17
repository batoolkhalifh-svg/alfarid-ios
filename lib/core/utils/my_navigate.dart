import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../widgets/custom_padding.dart';

/// Navigator Push
void navigateToWithPadding({required widget,reloadMethod}) =>
    Navigator.push(
        navigatorKey.currentState!.context,
        PageRouteBuilder(
          barrierColor: Colors.transparent,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return CustomPadding(
              widget: child,
            );
          },
          pageBuilder: (context, animation, secondaryAnimation) {
            return widget;
          },
        )).then(reloadMethod ?? (value){});

void navigateTo({required widget,reloadMethod}) =>
    Navigator.push(
      navigatorKey.currentState!.context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    ).then(reloadMethod ?? (value){});

/// Navigator Finish
navigateAndFinish({required widget}) =>
    Navigator.pushAndRemoveUntil(
        navigatorKey.currentState!.context,
        MaterialPageRoute(builder: (ctx) => widget),
            (Route<dynamic> route) => false);

/// Navigator Pop
navigatorPop() => Navigator.pop(navigatorKey.currentState!.context);

/// Navigator And Replace
navigateAndReplace({required widget}) => Navigator.pushReplacement(
    navigatorKey.currentState!.context,
    PageRouteBuilder(
      barrierColor: Colors.transparent,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return widget;
      },
    ));

navigateAndReplaceWithPadding({required widget})=> Navigator.pushReplacement(
  navigatorKey.currentState!.context,
  PageRouteBuilder(
    barrierColor: Colors.transparent,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return CustomPadding(
        widget: SlideInUp(
          duration: const Duration(milliseconds: 500),
          from: 100,
          child: child,
        ),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return widget;
    },
  ),
);