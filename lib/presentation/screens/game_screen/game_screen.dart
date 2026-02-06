import 'package:flutter/material.dart';
import 'package:pem_ble_app/presentation/widgets/navigation_drawer.dart';
import 'package:pem_ble_app/presentation/widgets/responsive_background.dart';
import 'package:pem_ble_app/core/constants/app_assets.dart';
import 'package:pem_ble_app/data/services/avatar_service.dart';
import 'package:pem_ble_app/data/services/supabase_service.dart';
import 'package:pem_ble_app/presentation/widgets/profile_icon.dart';
import 'package:pem_ble_app/presentation/widgets/coin_counter.dart';
import 'package:pem_ble_app/presentation/widgets/groups.dart';
import 'package:pem_ble_app/presentation/widgets/timer.dart';
import 'package:pem_ble_app/presentation/widgets/hamburger_menu.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final AvatarService _avatarService = AvatarService();
  
  // Card selection state
  Set<int> selectedCards = <int>{1, 2, 3, 4, 5, 6, 7, 8, 9}; // All cards selected by default
  bool allSelected = true;

  @override
  void initState() {
    super.initState();
    _avatarService.addListener(_onAvatarChanged);
  }

  @override
  void dispose() {
    _avatarService.removeListener(_onAvatarChanged);
    super.dispose();
  }

  void _onAvatarChanged() {
    setState(() {});
  }

  // Toggle individual card selection
  void _toggleCardSelection(int cardNumber) {
    setState(() {
      if (selectedCards.contains(cardNumber)) {
        selectedCards.remove(cardNumber);
      } else {
        selectedCards.add(cardNumber);
      }
      allSelected = selectedCards.length == 9;
    });
  }

  // Toggle all cards selection
  void _toggleAllSelection() {
    setState(() {
      if (allSelected) {
        selectedCards.clear();
        allSelected = false;
      } else {
        selectedCards = <int>{1, 2, 3, 4, 5, 6, 7, 8, 9};
        allSelected = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      endDrawer: const AppNavigationDrawer(currentScreen: 'یاریکردن'),
      body: Builder(
        builder: (BuildContext scaffoldContext) {
          return ResponsiveBackground(
            imagePath: AppAssets.mainBackground,
            child: SafeArea(
              child: Stack(
                children: [
                  // Scrollable content
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 70), // Added top padding for fixed header
                    child: Column(
                      children: [
                        // Card Types widget - Fully Responsive Layout with Sharp Corners & Increased Spacing
                        Builder(
                          builder: (context) {
                            final screenSize = MediaQuery.of(context).size;
                            final screenWidth = screenSize.width;
                            
                            // Calculate responsive dimensions
                            // Card grid occupies 100% of available width minus padding
                            final availableWidth = screenWidth - 48; // Subtract left (24) + right (24) padding
                            
                            // Fixed card dimensions to maintain consistent size regardless of container width
                            final cardWidth = 93.0; // Fixed card width in pixels
                            final cardHeight = cardWidth * 1.75; // Maintain aspect ratio
                            
                            // Uniform spacing - same gap between all cards horizontally and vertically
                            final uniformSpacing = 12.0; // Fixed uniform spacing in pixels
                            final containerPadding = screenWidth * 0.03; // 3% of screen width for outer padding
                            final topPaddingReduction = 5.0; // 5 pixels reduction for top padding
                            
                            // Responsive container height - fits content with uniform spacing
                            // Height is now determined by content, not calculated
                            
                            // Responsive styling with REDUCED corner radius for sharper look
                            final borderWidth = screenWidth * 0.006; // 0.6% of screen width
                            final containerCornerRadius = screenWidth * 0.025; // 2.5% of screen width (reduced from 5%)
                            final cardCornerRadius = screenWidth * 0.008; // 0.8% of screen width (original card radius)
                            final overlayCornerRadius = screenWidth * 0.014; // 1.4% of screen width (overlay only)
                            
                            // Helper method to get card type image URL from Supabase storage
                            String getCardTypeUrl(int cardNumber) {
                              return SupabaseService.client.storage
                                  .from('Card Types')
                                  .getPublicUrl('$cardNumber.png');
                            }

                            // Helper method to get select/unselect icon URL from Supabase storage
                            String getSelectIconUrl(bool isSelected) {
                              return SupabaseService.client.storage
                                  .from('Icons')
                                  .getPublicUrl(isSelected ? 'select all.png' : 'unselect all.png');
                            }

                            // Helper method to get overlay URL from Supabase storage
                            String getOverlayUrl() {
                              return SupabaseService.client.storage
                                  .from('Card Types')
                                  .getPublicUrl('Selected-Overlay.png');
                            }
                            
                            // Helper method to build individual responsive cards with sharp corners
                            Widget buildResponsiveCard(int cardNumber) {
                              final isSelected = selectedCards.contains(cardNumber);
                              
                              return GestureDetector(
                                onTap: () => _toggleCardSelection(cardNumber),
                                child: SizedBox(
                                  width: cardWidth,
                                  height: cardHeight,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(cardCornerRadius), // Clip to card corners
                                    child: Stack(
                                      children: [
                                        // Card image
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(cardCornerRadius), // Sharp corners
                                          child: Image.network(
                                            getCardTypeUrl(cardNumber),
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black.withValues(alpha: 0.4),
                                                  borderRadius: BorderRadius.circular(cardCornerRadius),
                                                ),
                                                child: Center(
                                                  child: CircularProgressIndicator(
                                                    value: loadingProgress.expectedTotalBytes != null
                                                        ? loadingProgress.cumulativeBytesLoaded /
                                                            loadingProgress.expectedTotalBytes!
                                                        : null,
                                                  color: const Color(0xFFa6a6a6),
                                                  strokeWidth: borderWidth,
                                                ),
                                              ),
                                            );
                                          },
                                          errorBuilder: (context, error, stackTrace) {
                                            debugPrint('Failed to load card $cardNumber: $error');
                                            return Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey.withValues(alpha: 0.3),
                                                borderRadius: BorderRadius.circular(cardCornerRadius),
                                              ),
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.image_not_supported,
                                                      color: Colors.white.withValues(alpha: 0.5),
                                                      size: cardWidth * 0.25, // 25% of card width
                                                    ),
                                                    SizedBox(height: cardHeight * 0.05), // 5% of card height
                                                    Text(
                                                      '$cardNumber',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: cardWidth * 0.15, // 15% of card width
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      // Selection overlay
                                      if (isSelected)
                                        Positioned(
                                          top: -cardWidth * 0.02, // Responsive: 2% of card width (increased)
                                          left: -cardWidth * 0.02,
                                          right: -cardWidth * 0.025, // Responsive: 2.5% of card width (increased, slightly more on right)
                                          bottom: -cardWidth * 0.02,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(overlayCornerRadius), // Use overlay-specific radius
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(overlayCornerRadius), // Use overlay-specific radius
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(overlayCornerRadius), // Use overlay-specific radius
                                                child: Image.network(
                                                  getOverlayUrl(),
                                                  fit: BoxFit.cover,
                                                  width: cardWidth + (cardWidth * 0.05), // Responsive: card width + 5% (increased)
                                                  height: cardHeight + (cardWidth * 0.04), // Responsive: card height + 4% (increased)
                                                  errorBuilder: (context, error, stackTrace) {
                                                    // Fallback overlay if image fails to load
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xFF374a76).withValues(alpha: 0.7),
                                                        borderRadius: BorderRadius.circular(overlayCornerRadius),
                                                        border: Border.all(
                                                          color: const Color(0xFF374a76),
                                                          width: borderWidth * 2,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.check_circle,
                                                          color: Colors.white,
                                                          size: cardWidth * 0.3,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                    ),
                                ),
                              );
                            }
                            
                            return Container(
                              width: availableWidth,
                              // Removed fixed height - let content determine height naturally
                              padding: EdgeInsets.only(
                                top: containerPadding - topPaddingReduction, // Reduced top padding by 5px
                                left: containerPadding,
                                right: containerPadding,
                                bottom: containerPadding,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF313030).withValues(alpha: 0.65),
                                borderRadius: BorderRadius.circular(containerCornerRadius), // Sharper container corners
                                border: Border.all(
                                  color: const Color(0xFFa6a6a6),
                                  width: borderWidth,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: screenWidth * 0.025, // 2.5% of screen width
                                    offset: Offset(0, screenWidth * 0.012), // 1.2% of screen width
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // Header with title text and select/unselect icon
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Empty spacer to balance the layout
                                      SizedBox(width: screenWidth * 0.04), // Same width as icon + padding
                                      // Centered title text
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            'جۆری کارتەکان دیاری بکە',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenWidth < 600 
                                                  ? screenWidth * 0.04 // Phone: 4% of screen width
                                                  : screenWidth * 0.032, // Tablet: keep current
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'kurdish',
                                            ),
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                      ),
                                      // Select/Unselect all icon
                                      GestureDetector(
                                        onTap: _toggleAllSelection,
                                        child: SizedBox(
                                          width: screenWidth * 0.04, // 4% of screen width
                                          height: screenWidth * 0.04, // Square aspect ratio
                                          child: Image.network(
                                            getSelectIconUrl(allSelected),
                                            fit: BoxFit.contain,
                                            errorBuilder: (context, error, stackTrace) {
                                              // Fallback icon if image fails to load
                                              return Icon(
                                                allSelected ? Icons.deselect : Icons.select_all,
                                                color: Colors.white,
                                                size: screenWidth * 0.04,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: screenWidth * 0.015 + 2), // Space below header + 2px extra
                                  // Card grid with uniform spacing
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: uniformSpacing / 2), // Half spacing on sides for centering
                                    child: Column(
                                      children: [
                                        // First row: Cards 1, 2, 3 (RTL order: 3, 2, 1)
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            buildResponsiveCard(3),
                                            buildResponsiveCard(2),
                                            buildResponsiveCard(1),
                                          ],
                                        ),
                                        SizedBox(height: uniformSpacing), // Uniform vertical spacing
                                        // Second row: Cards 4, 5, 6 (RTL order: 6, 5, 4)
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            buildResponsiveCard(6),
                                            buildResponsiveCard(5),
                                            buildResponsiveCard(4),
                                          ],
                                        ),
                                        SizedBox(height: uniformSpacing), // Uniform vertical spacing
                                        // Third row: Cards 7, 8, 9 (RTL order: 9, 8, 7)
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            buildResponsiveCard(9),
                                            buildResponsiveCard(8),
                                            buildResponsiveCard(7),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Bottom instruction text
                                  Padding(
                                    padding: EdgeInsets.only(top: screenWidth * 0.01), // Small space above text
                                    child: Center(
                                      child: Text(
                                        'کلیک لە کارتەکان بکە بۆ دیاری کردی ئەو کارتانەی ئەتەوێ یاری پێ بکەی.',
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.8), // 80% opacity
                                          fontSize: screenWidth < 600 
                                              ? screenWidth * 0.03 // Phone: 3% of screen width
                                              : screenWidth * 0.018, // Tablet: keep current
                                          fontFamily: 'kurdish',
                                          height: 1.1, // Reduced line spacing (default is ~1.2)
                                        ),
                                        textDirection: TextDirection.rtl,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 30), // Spacing between card types and groups
                        
                        // Groups widget
                        Center(
                          child: Groups(avatarService: _avatarService),
                        ),
                        const SizedBox(height: 30), // Spacing between groups and timer
                        
                        // Timer widget
                        Center(
                          child: TimerWidget(
                            initialMinutes: 5,
                            initialSeconds: 0,
                            onTimerFinished: () {
                              // Handle timer finished
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'کات تەواو بوو!',
                                    style: TextStyle(fontFamily: 'kurdish'),
                                    textDirection: TextDirection.rtl,
                                  ),
                                  backgroundColor: Color(0xFFCC0000),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 100), // Extra space at bottom for comfortable scrolling
                      ],
                    ),
                  ),
                  // Profile icon and coin counter in top left corner (fixed position)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Row(
                      children: [
                        ProfileIcon(avatarService: _avatarService),
                        const SizedBox(width: 12),
                        const CoinCounter(coinAmount: 1250),
                      ],
                    ),
                  ),
                  // Hamburger menu icon in top right corner (fixed position)
                  HamburgerMenu(
                    onTap: () {
                      Scaffold.of(scaffoldContext).openEndDrawer();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}