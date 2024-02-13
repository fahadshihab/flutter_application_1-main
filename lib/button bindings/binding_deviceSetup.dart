import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class button1 extends GestureDetector {
  final Widget child;
  button1({required this.child})
      : super(
          child: child,
        );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      onTapDown: ((details) {}),
      onTapUp: ((details) {}),
      onTapCancel: onTapCancel,
      child: child,
    );
  }
}
