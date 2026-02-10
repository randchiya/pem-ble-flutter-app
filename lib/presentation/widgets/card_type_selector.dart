import 'package:flutter/material.dart';
import 'package:pem_ble_app/presentation/widgets/card_carousel.dart';

class CardTypeSelector extends StatefulWidget {
  final Function(int)? onCardChanged;
  
  const CardTypeSelector({
    super.key,
    this.onCardChanged,
  });

  @override
  State<CardTypeSelector> createState() => _CardTypeSelectorState();
}

class _CardTypeSelectorState extends State<CardTypeSelector> {
  int _currentPage = 4; // Start at card 5 (index 4) - Behaviour
  
  // Map card types to number of text fields
  final Map<int, int> _cardTypeTextFields = {
    0: 6, // People
    1: 1, // Occupation
    2: 2, // Genral
    3: 4, // Animal
    4: 2, // Behaviour
    5: 1, // Equipment
    6: 4, // Place
    7: 2, // Food
    8: 1, // Challenge
  };
  
  // Map card types to their text field labels
  final Map<int, List<String>> _cardTypeLabels = {
    0: [ // People
      'کورد',
      'ئەکتەر | کەسایەتیە بیانیەکان',
      'گۆرانی بیژە بیانیەکان',
      'سەرکردە | زانە بیانیەکان',
      'یاریزانان',
      'کارەکتەری کارتۆن | یاریەکان',
    ],
    1: [ // Occupation
      'گشتی',
    ],
    2: [ // General
      'پەندی پێشینان',
      'گشتی',
    ],
    3: [ // Animal
      'ئاژەڵە ماڵیەکان',
      'ئاژەڵە کێویەکان',
      'ئاژەڵە ئاویەکان',
      'باڵندەکان',
    ],
    4: [ // Behaviour
      'هەست',
      'تەبیعەت',
    ],
    5: [ // Equipment
      'گشتی',
    ],
    6: [ // Place
      'شار | شوێنەکانی کوردستان',
      'شار | شوێنەکانی عێراق',
      'شارە بیانیەکان',
      'گشتی',
    ],
    7: [ // Food
      'خواردنە کوردیەکان',
      'خواردنە بیانیەکان',
    ],
    8: [ // Challenge
      'گشتی',
    ],
  };
  
  // Track checkbox states dynamically based on current card
  late List<bool> _checkboxStates;
  
  @override
  void initState() {
    super.initState();
    _checkboxStates = List.generate(_getTextFieldCount(), (_) => false);
  }
  
  int _getTextFieldCount() {
    return _cardTypeTextFields[_currentPage] ?? 6;
  }
  
  String _getTextFieldLabel(int index) {
    final labels = _cardTypeLabels[_currentPage];
    if (labels != null && index < labels.length) {
      return labels[index];
    }
    return '';
  }
  
  // ABSOLUTE CONSTANTS - MUST MATCH EVERYWHERE
  static const double topPadding = 24.0;
  static const double bottomPadding = 24.0;
  static const double horizontalPadding = 16.0;
  static const double containerBorderRadius = 24.0;
  
  void _onCardChanged(int cardNumber) {
    setState(() {
      _currentPage = cardNumber - 1; // Convert card number to index
      // Reset checkbox states when card changes
      _checkboxStates = List.generate(_getTextFieldCount(), (_) => false);
    });
    widget.onCardChanged?.call(cardNumber);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isPhone = screenWidth < 600;
    
    // Check if any checkbox is selected
    final hasSelection = _checkboxStates.any((isChecked) => isChecked);
    
    return Container(
      width: screenWidth - 48,
      padding: const EdgeInsets.only(
        top: topPadding,
        bottom: bottomPadding,
        left: horizontalPadding,
        right: horizontalPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(containerBorderRadius),
        border: Border.all(
          color: Colors.white,
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header - Title text
          Text(
            'جۆری کارتەکان هەڵبژێرە',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: isPhone ? screenWidth * 0.045 : screenWidth * 0.035,
              fontWeight: FontWeight.w500,
              fontFamily: 'kurdish',
            ),
            textDirection: TextDirection.rtl,
          ),
          
          const SizedBox(height: 20),
          
          // Card Carousel - ABSOLUTE SIZING
          CardCarousel(
            initialCard: 4,
            onCardChanged: _onCardChanged,
            showSelectedOverlay: hasSelection,
          ),
          
          const SizedBox(height: 16),
          
          // Pagination dots
          CarouselPaginationDots(
            totalDots: 9,
            currentIndex: _currentPage,
          ),
          
          const SizedBox(height: 24),
          
          // Checklist Section - 2 columns, 3 rows
          _buildChecklistGrid(screenWidth, isPhone),
          
          const SizedBox(height: 20),
          
          // Instruction text
          Text(
            'کلیک لە کارتەکان بکە بۆ دیاری کردی ئەو کارتانەی ئەتەوێ یاری پێ بکەی',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: isPhone ? screenWidth * 0.03 : screenWidth * 0.022,
              fontFamily: 'kurdish',
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistGrid(double screenWidth, bool isPhone) {
    final itemHeight = isPhone ? screenWidth * 0.08 : screenWidth * 0.06;
    final spacing = screenWidth * 0.02;
    final textFieldCount = _getTextFieldCount();
    
    // If only 1 text field, center it
    if (textFieldCount == 1) {
      return Center(
        child: SizedBox(
          width: screenWidth * 0.5, // 50% width for centered single field
          child: _buildChecklistItem(0, itemHeight, itemHeight, screenWidth),
        ),
      );
    }
    
    // Build rows dynamically based on text field count (2 columns)
    List<Widget> rows = [];
    
    for (int i = 0; i < textFieldCount; i += 2) {
      rows.add(
        Row(
          children: [
            _buildChecklistItem(i, itemHeight, itemHeight, screenWidth),
            if (i + 1 < textFieldCount) ...[
              SizedBox(width: spacing),
              _buildChecklistItem(i + 1, itemHeight, itemHeight, screenWidth),
            ] else
              Expanded(child: SizedBox()), // Empty space if odd number
          ],
        ),
      );
      
      // Add spacing between rows (except after last row)
      if (i + 2 < textFieldCount) {
        rows.add(SizedBox(height: spacing));
      }
    }
    
    return Column(children: rows);
  }

  Widget _buildChecklistItem(int index, double height, double checkSize, double screenWidth) {
    final isChecked = _checkboxStates[index];
    final label = _getTextFieldLabel(index);
    final isPhone = screenWidth < 600;
    
    return Expanded(
      child: Row(
        children: [
          // Text field with label and white outline
          Expanded(
            child: Container(
              height: height,
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF1a1a1a),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Colors.white,
                  width: 1.5,
                ),
              ),
              child: Align(
                alignment: Alignment.centerRight, // RTL alignment
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: isPhone ? screenWidth * 0.028 : screenWidth * 0.022,
                    fontFamily: 'kurdish',
                  ),
                  textDirection: TextDirection.rtl,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.015),
          // Interactive checkbox with white outline
          GestureDetector(
            onTap: () {
              setState(() {
                _checkboxStates[index] = !_checkboxStates[index];
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: height,
              height: height,
              decoration: BoxDecoration(
                color: isChecked 
                    ? const Color(0xFF4CAF50) 
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Colors.white,
                  width: 1.5,
                ),
              ),
              child: Icon(
                isChecked ? Icons.check : Icons.close,
                color: isChecked 
                    ? Colors.white 
                    : Colors.grey.withValues(alpha: 0.4),
                size: height * 0.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
