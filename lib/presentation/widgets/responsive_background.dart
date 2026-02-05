import 'package:flutter/material.dart';

class ResponsiveBackground extends StatelessWidget {
  final Widget child;
  final String imagePath;

  const ResponsiveBackground({
    super.key,
    required this.child,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.fill,
          alignment: Alignment.center,
        ),
      ),
      child: child,
    );
  }
}