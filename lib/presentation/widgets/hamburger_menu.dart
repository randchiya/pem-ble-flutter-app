import 'package:flutter/material.dart';

class HamburgerMenu extends StatelessWidget {
  final VoidCallback onTap;

  const HamburgerMenu({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      right: 0, // Changed to 0 to hit the window border
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 70, // Made slightly bigger (increased from 60 to 70)
          height: 38, // Made slightly bigger (increased from 32 to 38)
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.transparent, // Fade out on the left
                const Color(0xFF313030), // Changed to #313030
                const Color(0xFF313030), // Solid color on the right
              ],
              stops: const [0.0, 0.3, 1.0], // Fade starts at 0%, solid at 30%
            ),
            // Removed borderRadius for sharp edges
          ),
          child: const Align(
            alignment: Alignment.centerRight, // Move icon to the right side
            child: Padding(
              padding: EdgeInsets.only(right: 12), // Increased from 10 to 12 (2px more to the left)
              child: Icon(
                Icons.menu,
                color: Colors.white,
                size: 20, // Fixed icon size
              ),
            ),
          ),
        ),
      ),
    );
  }
}