import 'package:flutter/material.dart';
import 'package:pem_ble_app/presentation/widgets/responsive_background.dart';
import 'package:pem_ble_app/presentation/widgets/card_carousel.dart';
import 'package:pem_ble_app/core/constants/app_assets.dart';

/// Full-screen card selection view
/// Uses IDENTICAL carousel component as the widget version
class CardSelectionScreen extends StatefulWidget {
  const CardSelectionScreen({super.key});

  @override
  State<CardSelectionScreen> createState() => _CardSelectionScreenState();
}

class _CardSelectionScreenState extends State<CardSelectionScreen> {
  int _currentPage = 4; // Start at card 5 (index 4)
  
  // ABSOLUTE CONSTANTS - MUST MATCH card_type_selector.dart
  static const double topPadding = 24.0;
  static const double bottomPadding = 24.0;
  static const double horizontalPadding = 16.0;
  static const double containerBorderRadius = 24.0;
  
  void _onCardChanged(int cardNumber) {
    setState(() {
      _currentPage = cardNumber - 1; // Convert card number to index
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isPhone = screenWidth < 600;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: ResponsiveBackground(
        imagePath: AppAssets.mainBackground,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                top: topPadding,
                bottom: bottomPadding,
                left: horizontalPadding,
                right: horizontalPadding,
              ),
              child: Column(
                children: [
                  // Back button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Title
                  Text(
                    'جۆری کارتەکان هەڵبژێرە',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: isPhone ? screenWidth * 0.06 : screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'kurdish',
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Card Carousel - IDENTICAL to widget version
                  CardCarousel(
                    initialCard: 4,
                    onCardChanged: _onCardChanged,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Pagination dots - IDENTICAL to widget version
                  CarouselPaginationDots(
                    totalDots: 9,
                    currentIndex: _currentPage,
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Card description or additional info
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1a1a1a).withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(containerBorderRadius),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      'ئەم جۆرە کارتە هەڵبژێرە بۆ یاریکردن.\nدەتوانی لە نێوان ٩ جۆری جیاواز هەڵبژێری.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: isPhone ? screenWidth * 0.035 : screenWidth * 0.025,
                        fontFamily: 'kurdish',
                        height: 1.6,
                      ),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Confirm button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle card selection confirmation
                        Navigator.pop(context, _currentPage + 1);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF374a76),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'دڵنیاکردنەوە',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isPhone ? screenWidth * 0.04 : screenWidth * 0.03,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'kurdish',
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
