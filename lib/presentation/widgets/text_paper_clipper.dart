import 'package:flutter/material.dart';
import 'dart:math' as math;

class TextPaperClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final random = math.Random(123); // Fixed seed for consistent shape
    
    // Start from top-left with subtle torn edge
    path.moveTo(0, 2 + random.nextDouble() * 2);
    
    // Top edge with professional torn effect
    double currentX = 0;
    while (currentX < size.width) {
      final segmentWidth = 25 + random.nextDouble() * 20;
      currentX += segmentWidth;
      if (currentX > size.width) currentX = size.width;
      
      final tearDepth = 0.5 + random.nextDouble() * 2;
      final controlX = currentX - segmentWidth * 0.5;
      final controlY = tearDepth * (random.nextBool() ? 1 : -1);
      
      path.quadraticBezierTo(controlX, controlY, currentX, 1 + random.nextDouble() * 2);
    }
    
    // Right edge with refined tearing
    double currentY = 0;
    while (currentY < size.height) {
      final segmentHeight = 22 + random.nextDouble() * 16;
      currentY += segmentHeight;
      if (currentY > size.height) currentY = size.height;
      
      final tearDepth = 0.5 + random.nextDouble() * 1.5;
      final controlX = size.width - tearDepth * (random.nextBool() ? 1 : -1);
      final controlY = currentY - segmentHeight * 0.5;
      
      path.quadraticBezierTo(controlX, controlY, size.width - (0.5 + random.nextDouble() * 1), currentY);
    }
    
    // Bottom edge with elegant tearing
    currentX = size.width;
    while (currentX > 0) {
      final segmentWidth = 25 + random.nextDouble() * 20;
      currentX -= segmentWidth;
      if (currentX < 0) currentX = 0;
      
      final tearDepth = 1 + random.nextDouble() * 2.5;
      final controlX = currentX + segmentWidth * 0.5;
      final controlY = size.height - tearDepth * (random.nextBool() ? 1 : -1);
      
      path.quadraticBezierTo(controlX, controlY, currentX, size.height - (1 + random.nextDouble() * 2));
    }
    
    // Left edge with subtle professional tearing
    currentY = size.height;
    while (currentY > 0) {
      final segmentHeight = 22 + random.nextDouble() * 16;
      currentY -= segmentHeight;
      if (currentY < 0) currentY = 0;
      
      final tearDepth = 0.5 + random.nextDouble() * 1.5;
      final controlX = tearDepth * (random.nextBool() ? 1 : -1);
      final controlY = currentY + segmentHeight * 0.5;
      
      path.quadraticBezierTo(controlX, controlY, 0.5 + random.nextDouble() * 1, currentY);
    }
    
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}