import 'package:flutter/material.dart';

class AnimatedPageTransitions {
  static Future<dynamic> slideTransition(BuildContext context, Widget page) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => page,
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (_, aimation, anotherAnimation, c) =>
            SlideTransition(
                position: Tween(
                        begin: const Offset(1.0, 0.0),
                        end: const Offset(0.0, 0.0))
                    .animate(aimation),
                child: c),
      ),
    );
  }

  static Future<dynamic> fadeTransition(BuildContext context, Widget page) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => page,
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (_, a, __, c) =>
            FadeTransition(opacity: a, child: c),
      ),
    );
  }

  static Future<dynamic> scaleTransitionAndRemoveUntil(
      BuildContext context, Widget page) {
    return Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          reverseTransitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, __, ___) => page,
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (_, animation, anotherAnimation, c) =>
              ScaleTransition(scale: animation, child: c),
        ),
        (route) => false);
  }
}
