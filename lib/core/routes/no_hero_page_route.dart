import 'package:flutter/material.dart';

class NoHeroPageRoute<T> extends MaterialPageRoute<T> {
  NoHeroPageRoute({required super.builder, super.settings});

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }
} 