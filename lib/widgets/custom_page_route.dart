
import 'package:flutter/material.dart';
class MyCustomPageRoute extends PageRouteBuilder {
  final Widget route;
  MyCustomPageRoute({required this.route})
      : super(
          pageBuilder: (
            context,
            animation,
            secondaryAnimation,
          ) {
            return route;
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        );
}
