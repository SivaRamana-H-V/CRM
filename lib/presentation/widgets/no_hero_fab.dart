import 'package:flutter/material.dart';

class NoHeroFab extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color? backgroundColor;

  const NoHeroFab({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: FloatingActionButton(
        backgroundColor: backgroundColor,
        heroTag: null, // Disable hero animations
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
