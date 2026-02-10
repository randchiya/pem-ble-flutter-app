import 'package:flutter/material.dart';
import 'package:pem_ble_app/data/services/supabase_service.dart';

/// Reusable card carousel component with ABSOLUTE sizing
/// Guaranteed pixel-identical appearance in all contexts
class CardCarousel extends StatefulWidget {
  final Function(int)? onCardChanged;
  final int initialCard;
  final bool showSelectedOverlay;
  
  const CardCarousel({
    super.key,
    this.onCardChanged,
    this.initialCard = 4, // Default to card 5 (index 4)
    this.showSelectedOverlay = false,
  });

  @override
  State<CardCarousel> createState() => _CardCarouselState();
}

class _CardCarouselState extends State<CardCarousel> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late int _currentPage;
  late AnimationController _snapController;
  double _dragPosition = 0.0; // Current drag position (-1 to 1)
  bool _isDragging = false;
  
  // ABSOLUTE CONSTANTS - DO NOT CHANGE
  static const double cardWidthTablet = 300.0;
  static const double cardHeightTablet = 420.0;
  static const double cardWidthPhone = 220.0; // Smaller for phones
  static const double cardHeightPhone = 308.0; // Maintains 5:7 ratio
  static const double centerScale = 1.0;
  static const double sideScale = 0.85;
  static const double centerOpacity = 1.0;
  static const double sideOpacity = 0.55;
  static const double cardBorderRadius = 12.0;
  
  // Card data - 9 card types
  final List<String> _cardTypes = [
    'People',
    'Occupation',
    'Genral',
    'Animal',
    'Behaviour',
    'Equipment',
    'Place',
    'Food',
    'Challenge',
  ];
  
  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialCard;
    _pageController = PageController(
      viewportFraction: 0.55,
      initialPage: widget.initialCard,
    );
    
    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150), // Much faster snap
    );
    
    _snapController.addListener(() {
      if (!_isDragging) {
        setState(() {
          // Use easeOut curve for smoother deceleration
          final curvedValue = Curves.easeOutQuart.transform(_snapController.value);
          _dragPosition = _dragPosition * (1 - curvedValue);
        });
      }
    });
    
    // Precache all card images for instant loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (int i = 0; i < _cardTypes.length; i++) {
        precacheImage(
          NetworkImage(_getCardTypeUrl(_cardTypes[i])),
          context,
        );
      }
    });
  }

  @override
  void dispose() {
    _snapController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    // Clamp page to valid range (no wrapping)
    int clampedPage = page.clamp(0, _cardTypes.length - 1);
    
    if (clampedPage != _currentPage) {
      setState(() {
        _currentPage = clampedPage;
        _dragPosition = 0.0;
      });
      widget.onCardChanged?.call(clampedPage + 1); // Pass 1-based index
    }
  }

  void _snapToNearest() {
    _isDragging = false;
    
    // Determine which card to snap to based on drag position (lower threshold for faster response)
    if (_dragPosition > 0.15) {
      // Snap to previous card (no wrapping)
      int newPage = _currentPage - 1;
      if (newPage >= 0) {
        _goToPage(newPage);
      } else {
        // At first card, snap back
        _snapController.forward(from: 0.0);
      }
    } else if (_dragPosition < -0.15) {
      // Snap to next card (no wrapping)
      int newPage = _currentPage + 1;
      if (newPage < _cardTypes.length) {
        _goToPage(newPage);
      } else {
        // At last card, snap back
        _snapController.forward(from: 0.0);
      }
    } else {
      // Snap back to current card
      _snapController.forward(from: 0.0);
    }
  }

  String _getCardTypeUrl(String cardType) {
    return SupabaseService.client.storage
        .from('Card Types')
        .getPublicUrl('$cardType.png');
  }

  String _getSelectedOverlayUrl() {
    return SupabaseService.client.storage
        .from('Card Types')
        .getPublicUrl('Selected-Overlay.png');
  }

  // Get card dimensions based on screen width
  double getCardWidth(BuildContext context) {
    return MediaQuery.of(context).size.width < 600 ? cardWidthPhone : cardWidthTablet;
  }

  double getCardHeight(BuildContext context) {
    return MediaQuery.of(context).size.width < 600 ? cardHeightPhone : cardHeightTablet;
  }

  @override
  Widget build(BuildContext context) {
    final cardW = getCardWidth(context);
    final cardH = getCardHeight(context);
    
    return SizedBox(
      height: cardH,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final centerX = constraints.maxWidth / 2;
          
          return GestureDetector(
            onHorizontalDragStart: (details) {
              setState(() {
                _isDragging = true;
                _snapController.stop();
              });
            },
            onHorizontalDragUpdate: (details) {
              setState(() {
                // Increased sensitivity for faster response
                _dragPosition += details.delta.dx / (constraints.maxWidth * 0.8);
                _dragPosition = _dragPosition.clamp(-1.0, 1.0);
              });
            },
            onHorizontalDragEnd: (details) {
              _snapToNearest();
            },
            onHorizontalDragCancel: () {
              _snapToNearest();
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: _buildCardStack(centerX, constraints.maxWidth, cardW, cardH),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildCardStack(double centerX, double screenWidth, double cardW, double cardH) {
    List<Widget> cards = [];
    
    // Adjust spacing based on screen size
    final cardSpacing = screenWidth < 600 ? 90.0 : 120.0;
    
    // Show current card and adjacent cards (no wrapping)
    final prevIndex = _currentPage - 1;
    final nextIndex = _currentPage + 1;
    
    // LAYER 1: Background - Side cards (only if they exist)
    // Left card (previous) - only show if not at start
    if (prevIndex >= 0) {
      cards.add(_buildCard(prevIndex, centerX, cardSpacing, cardW, cardH, 
          isBackground: true, relativePosition: -1));
    }
    
    // Right card (next) - only show if not at end
    if (nextIndex < _cardTypes.length) {
      cards.add(_buildCard(nextIndex, centerX, cardSpacing, cardW, cardH, 
          isBackground: true, relativePosition: 1));
    }
    
    // LAYER 2: Foreground - Center card (always on top)
    cards.add(_buildCard(_currentPage, centerX, cardSpacing, cardW, cardH, 
        isBackground: false, relativePosition: 0));
    
    return cards;
  }

  Widget _buildCard(int index, double centerX, double cardSpacing, double cardW, double cardH, 
      {required bool isBackground, required int relativePosition}) {
    final isActive = index == _currentPage;
    
    // Use explicit relative position for proper wrapping
    // relativePosition: -1 = left card, 0 = center, 1 = right card
    final double cardRelativePosition = relativePosition.toDouble();
    
    // Apply drag position to calculate final offset
    // Positive dragPosition = swiping right (showing previous card)
    // Negative dragPosition = swiping left (showing next card)
    final dragInfluence = cardRelativePosition + _dragPosition;
    
    // Calculate horizontal position
    final horizontalOffset = dragInfluence * cardSpacing;
    
    // Calculate scale and opacity based on distance from center
    final distanceFromCenter = dragInfluence.abs();
    final scale = isActive 
        ? 1.0 - (distanceFromCenter * 0.15) // Center card scales down slightly when dragging
        : sideScale + ((1.0 - distanceFromCenter.clamp(0.0, 1.0)) * 0.15); // Side cards scale up as they approach center
    
    final opacity = isActive
        ? (1.0 - (distanceFromCenter * 0.45)).clamp(0.55, 1.0) // Center card fades as it moves away
        : (sideOpacity + ((1.0 - distanceFromCenter.clamp(0.0, 1.0)) * 0.45)).clamp(0.55, 1.0); // Side cards fade in as they approach
    
    // Calculate dimensions
    final scaledWidth = cardW * scale;
    final scaledHeight = cardH * scale;
    
    final cardLeft = centerX - (scaledWidth / 2) + horizontalOffset;
    final cardTop = (cardH - scaledHeight) / 2; // Center vertically
    
    return Positioned(
      left: cardLeft,
      top: cardTop,
      child: Opacity(
        opacity: opacity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(cardBorderRadius),
          clipBehavior: Clip.hardEdge, // Strict clipping
          child: Container(
            width: scaledWidth,
            height: scaledHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(cardBorderRadius),
            ),
            clipBehavior: Clip.hardEdge, // Double clipping for safety
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.hardEdge,
              children: [
                // Base card image
                Image.network(
                  _getCardTypeUrl(_cardTypes[index]),
                  fit: BoxFit.contain,
                  width: scaledWidth,
                  height: scaledHeight,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.withValues(alpha: 0.3),
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.white.withValues(alpha: 0.5),
                          size: 80,
                        ),
                      ),
                    );
                  },
                ),
                // Selected overlay (only on center card when selected)
                if (isActive && widget.showSelectedOverlay)
                  Positioned.fill(
                    child: Image.network(
                      _getSelectedOverlayUrl(),
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Pagination dots component with scrolling indicator
/// Shows only 5-7 dots at a time with active dot always in the middle
class CarouselPaginationDots extends StatelessWidget {
  final int totalDots;
  final int currentIndex;
  
  const CarouselPaginationDots({
    super.key,
    required this.totalDots,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    // Number of visible dots (always odd to keep center dot in middle)
    const int visibleDots = 5;
    const int sideDotsCount = visibleDots ~/ 2; // 2 dots on each side
    
    // Calculate which dots to show
    List<int> visibleIndices = [];
    
    // Determine the range of dots to display
    int startIndex = currentIndex - sideDotsCount;
    int endIndex = currentIndex + sideDotsCount;
    
    // Adjust range if at the beginning or end
    if (startIndex < 0) {
      // Near the start - show first 5 dots
      startIndex = 0;
      endIndex = visibleDots - 1;
    } else if (endIndex >= totalDots) {
      // Near the end - show last 5 dots
      endIndex = totalDots - 1;
      startIndex = totalDots - visibleDots;
    }
    
    // Clamp to valid range
    startIndex = startIndex.clamp(0, totalDots - 1);
    endIndex = endIndex.clamp(0, totalDots - 1);
    
    // Build the list of visible indices
    for (int i = startIndex; i <= endIndex; i++) {
      visibleIndices.add(i);
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: visibleIndices.map((actualIndex) {
        final isActive = actualIndex == currentIndex;
        final distanceFromCurrent = (actualIndex - currentIndex).abs();
        
        // Size and opacity based on distance from current
        double size;
        double opacity;
        
        if (isActive) {
          size = 10.0;
          opacity = 1.0;
        } else if (distanceFromCurrent == 1) {
          size = 8.0;
          opacity = 0.6;
        } else {
          size = 6.0;
          opacity = 0.3;
        }
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: opacity),
          ),
        );
      }).toList(),
    );
  }
}
