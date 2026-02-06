import 'package:flutter/material.dart';
import 'package:pem_ble_app/presentation/widgets/profile_icon.dart';
import 'package:pem_ble_app/data/services/avatar_service.dart';
import 'package:pem_ble_app/data/services/supabase_service.dart';

class Groups extends StatefulWidget {
  final AvatarService avatarService;
  
  const Groups({super.key, required this.avatarService});

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> with TickerProviderStateMixin {
  int selectedPlayerCount = 4; // Default to 4 players
  
  // Text editing controllers and focus states for editable players
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};
  final Map<String, bool> _isEditing = {};
  final Map<String, bool> _hasBeenEdited = {}; // Track if player name has been confirmed
  final Map<String, bool> _hasValidationError = {}; // Track validation errors
  
  // Random background assignments for players (2.png to 5.png)
  Map<String, String> _playerBackgrounds = {};
  
  // Animation controller for validation notification
  late AnimationController _notificationController;
  late Animation<double> _notificationAnimation;
  bool _showNotification = false;
  String _validationMessage = '';
  
  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller for validation notification
    _notificationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _notificationAnimation = CurvedAnimation(
      parent: _notificationController,
      curve: Curves.easeInOut,
    );
    
    // Assign random unique backgrounds to all players
    _assignRandomBackgrounds();
    
    // Initialize controllers and focus nodes for editable players
    for (String playerName in ['کەسی ٢', 'کەسی ٣', 'کەسی ٤']) {
      _controllers[playerName] = TextEditingController(text: 'ناوکەت لێرە بنووسە');
      _focusNodes[playerName] = FocusNode();
      _isEditing[playerName] = false;
      _hasBeenEdited[playerName] = false; // Initially not edited
      _hasValidationError[playerName] = false; // Initially no validation error
      
      // Listen to focus changes
      _focusNodes[playerName]!.addListener(() {
        setState(() {
          _isEditing[playerName] = _focusNodes[playerName]!.hasFocus;
        });
      });
      
      // Listen to text changes for Kurdish validation
      _controllers[playerName]!.addListener(() {
        final currentText = _controllers[playerName]!.text;
        if (currentText.isNotEmpty && currentText != 'ناوکەت لێرە بنووسە') {
          // Check if text is now valid Kurdish and clear error if so
          if (_hasValidationError[playerName] == true && _isKurdishText(currentText)) {
            setState(() {
              _hasValidationError[playerName] = false;
            });
            _hideValidationNotification();
          }
        }
      });
    }
  }
  
  // Assign random unique backgrounds to all players
  void _assignRandomBackgrounds() {
    final availableBackgrounds = ['2.png', '3.png', '4.png', '5.png'];
    final allPlayers = ['کەسی ١', 'کەسی ٢', 'کەسی ٣', 'کەسی ٤'];
    
    _playerBackgrounds = {};
    
    // Assign each player a different background
    for (int i = 0; i < allPlayers.length; i++) {
      _playerBackgrounds[allPlayers[i]] = availableBackgrounds[i];
    }
  }
  
  @override
  void dispose() {
    // Dispose animation controller
    _notificationController.dispose();
    
    // Dispose controllers and focus nodes
    for (String playerName in ['کەسی ٢', 'کەسی ٣', 'کەسی ٤']) {
      _controllers[playerName]?.dispose();
      _focusNodes[playerName]?.dispose();
    }
    super.dispose();
  }
  
  // Check if text contains Kurdish characters
  bool _isKurdishText(String text) {
    // Kurdish Unicode ranges and common Kurdish characters
    final kurdishPattern = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\u200C\u200D]');
    return kurdishPattern.hasMatch(text);
  }
  
  // Show validation notification with fade-in
  void _showValidationNotification(String message) {
    setState(() {
      _validationMessage = message;
      _showNotification = true;
    });
    _notificationController.forward();
  }
  
  // Hide validation notification with fade-out
  void _hideValidationNotification() {
    _notificationController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showNotification = false;
          _validationMessage = '';
        });
      }
    });
  }
  
  // Validate text on submission
  bool _validatePlayerName(String playerName, String text) {
    if (text.trim().isEmpty || text == 'ناوکەت لێرە بنووسە') {
      return true; // Empty or default text is acceptable
    }
    
    if (!_isKurdishText(text)) {
      setState(() {
        _hasValidationError[playerName] = true;
      });
      _showValidationNotification('تکایە ناوەکەت بە زمانی شیرینی کوردی بنووسە');
      return false;
    }
    
    return true;
  }
  
  // Get appropriate placeholder text based on current text
  String _getPlaceholderText(String currentText) {
    // If the text is empty or the default placeholder, show default
    if (currentText.trim().isEmpty || currentText == 'ناوکەت لێرە بنووسە') {
      return 'ناوکەت لێرە بنووسە'; // Default placeholder
    } 
    // If text contains Kurdish characters, show default placeholder
    else if (_isKurdishText(currentText)) {
      return 'ناوکەت لێرە بنووسە'; // Kurdish text is valid
    } 
    // If text doesn't contain Kurdish characters, show validation message
    else {
      return 'تکایە بە زمانی شیرینی کوردی ناوەکەت بنووسە'; // Non-Kurdish text
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Use same border width calculation as Card Types
    final borderWidth = screenWidth * 0.006; // 0.6% of screen width (same as Card Types)
    
    return Container(
      width: screenWidth - 48, // Same as Card Types: subtract left (24) + right (24) padding
      padding: EdgeInsets.all(screenWidth * 0.025), // Reduced from 0.04 to 0.025
      decoration: BoxDecoration(
        color: const Color(0xFF313030).withValues(alpha: 0.65), // Changed to #313030 with 65% opacity
        borderRadius: BorderRadius.circular(screenWidth * 0.025), // Reduced from 0.04 to 0.025
        border: Border.all(
          color: const Color(0xFFa6a6a6), // Same as Card Types
          width: borderWidth, // Same calculation as Card Types
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.1), // Subtle glow
            blurRadius: 6, // Reduced from 8
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 8, // Reduced from 12
            offset: const Offset(0, 3), // Reduced from 4
          ),
        ],
      ),
      child: Column(
        children: [
          // Validation notification (appears at top when needed)
          AnimatedBuilder(
            animation: _notificationAnimation,
            builder: (context, child) {
              if (!_showNotification) return const SizedBox.shrink();
              
              return FadeTransition(
                opacity: _notificationAnimation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.5),
                    end: Offset.zero,
                  ).animate(_notificationAnimation),
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: screenWidth * 0.02),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                      vertical: screenWidth * 0.015,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFCC0000).withValues(alpha: 0.9), // Red background
                      borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      border: Border.all(
                        color: const Color(0xFFFF4444),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _validationMessage,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.025,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'kurdish',
                      ),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Header Section (top line with title and 2/4 selectors)
          _buildHeader(screenWidth),
          SizedBox(height: screenWidth * 0.03), // Spacing
          
          // Player cards area (shows based on selection)
          _buildPlayerCardsArea(screenWidth),
          SizedBox(height: screenWidth * 0.03), // Spacing
          
          // Bottom instruction text
          Text(
            'کلیک لەسەر ناوەکان بکە بۆ گۆڕینی ناوی کەسەکان',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: screenWidth < 600 
                  ? screenWidth * 0.03 // Phone: 3% of screen width
                  : screenWidth * 0.025, // Tablet: keep current
              fontFamily: 'kurdish',
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    // Responsive height for 2/4 selector
    final selectorHeight = screenWidth < 600 
        ? screenWidth * 0.055 // Phone: taller selector
        : screenWidth * 0.045; // Tablet: keep current
    
    return Column(
      children: [
        // Title and number selector in same row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Number selector (2 and 4) on the left - single segmented control
            Container(
              height: selectorHeight, // Responsive height
              decoration: BoxDecoration(
                color: const Color(0xFF313030).withValues(alpha: 0.65), // #313030 background with 65% opacity
                borderRadius: BorderRadius.circular(selectorHeight / 2), // Adjusted for responsive height
                border: Border.all(
                  color: const Color(0xFFa6a6a6), // Added a6a6a6 outline
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // "4" selector (left side)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPlayerCount = 4;
                      });
                    },
                    child: Container(
                      width: screenWidth * 0.06, // Keep original width
                      height: selectorHeight, // Match container height
                      decoration: BoxDecoration(
                        color: selectedPlayerCount == 4 
                            ? const Color(0xFF457A00) // Solid green when selected
                            : Colors.transparent, // Transparent when not selected
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(selectorHeight / 2), // Adjusted for responsive height
                          bottomLeft: Radius.circular(selectorHeight / 2),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '4',
                          style: TextStyle(
                            color: selectedPlayerCount == 4 
                                ? Colors.white // White text when selected
                                : Colors.white.withValues(alpha: 0.7), // Light gray when not selected
                            fontSize: screenWidth < 600 
                                ? screenWidth * 0.04 // Phone: 4% of screen width
                                : screenWidth * 0.025, // Tablet: keep current
                            fontWeight: FontWeight.bold,
                            fontFamily: 'kurdish',
                          ),
                        ),
                      ),
                    ),
                  ),
                  // "2" selector (right side) - no gap between
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPlayerCount = 2;
                      });
                    },
                    child: Container(
                      width: screenWidth * 0.06, // Keep original width
                      height: selectorHeight, // Match container height
                      decoration: BoxDecoration(
                        color: selectedPlayerCount == 2 
                            ? const Color(0xFF457A00) // Solid green when selected
                            : Colors.transparent, // Transparent when not selected
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(selectorHeight / 2), // Adjusted for responsive height
                          bottomRight: Radius.circular(selectorHeight / 2),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '2',
                          style: TextStyle(
                            color: selectedPlayerCount == 2 
                                ? Colors.white // White text when selected
                                : Colors.white.withValues(alpha: 0.7), // Light gray when not selected
                            fontSize: screenWidth < 600 
                                ? screenWidth * 0.04 // Phone: 4% of screen width
                                : screenWidth * 0.025, // Tablet: keep current
                            fontWeight: FontWeight.bold,
                            fontFamily: 'kurdish',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Title text on the right (RTL layout)
            Expanded(
              child: Text(
                'ژمارەی ئەو کەسانەی یاری دەکەن',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth < 600 
                      ? screenWidth * 0.04 // Phone: 4% of screen width
                      : screenWidth * 0.032, // Tablet: keep current
                  fontWeight: FontWeight.bold,
                  fontFamily: 'kurdish',
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlayerCardsArea(double screenWidth) {
    if (selectedPlayerCount == 2) {
      return _build2PlayerCards(screenWidth);
    } else {
      return _build4PlayerCards(screenWidth);
    }
  }

  Widget _build2PlayerCards(double screenWidth) {
    // Responsive height - taller on phones
    final fourPlayerContainerHeight = screenWidth < 600 
        ? screenWidth * 0.22 // Phone: taller cards
        : screenWidth * 0.175; // Tablet: keep current
    final individualCardHeight = (fourPlayerContainerHeight - screenWidth * 0.01) / 2; // Same calculation as 4-player
    
    // Responsive font size for group titles
    final groupTitleFontSize = screenWidth < 600 
        ? screenWidth * 0.035 // Phone: 3.5% of screen width
        : screenWidth * 0.025; // Tablet: keep current
    
    return Column(
      children: [
        // Group titles row
        Row(
          children: [
            // Left side title (Group 2)
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: screenWidth * 0.015),
                child: Text(
                  'گرووپی ٢',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: groupTitleFontSize,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'kurdish',
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            
            // Space for divider
            SizedBox(width: screenWidth * 0.06), // Same width as divider + margins
            
            // Right side title (Group 1)
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: screenWidth * 0.015),
                child: Text(
                  'گرووپی ١',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: groupTitleFontSize,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'kurdish',
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        
        // Player cards with divider - EXACT SAME RECTANGLE HEIGHT AS 4-PLAYER
        Container(
          height: individualCardHeight, // Use the exact same individual card height as 4-player
          child: Row(
            children: [
              // Left player card - کەسی ٢ (Player 2)
              Expanded(
                child: Container(
                  height: individualCardHeight, // Force exact same height as 4-player individual cards
                  child: _buildPlayerCard('کەسی ٢', screenWidth),
                ),
              ),
              
              // Vertical divider - shorter for 2 players
              Container(
                width: 3, // Keep same width as 4-player layout
                height: individualCardHeight * 0.8, // 80% of individual card height
                color: const Color(0xFFa6a6a6).withValues(alpha: 0.4),
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
              ),
              
              // Right player card - کەسی ١ (Player 1)
              Expanded(
                child: Container(
                  height: individualCardHeight, // Force exact same height as 4-player individual cards
                  child: _buildPlayerCard('کەسی ١', screenWidth),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _build4PlayerCards(double screenWidth) {
    // Responsive font size for group titles
    final groupTitleFontSize = screenWidth < 600 
        ? screenWidth * 0.035 // Phone: 3.5% of screen width
        : screenWidth * 0.025; // Tablet: keep current
        
    return Column(
      children: [
        // Group titles row
        Row(
          children: [
            // Left side title (Group 2)
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: screenWidth * 0.015),
                child: Text(
                  'گرووپی ٢',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: groupTitleFontSize,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'kurdish',
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            
            // Space for divider
            SizedBox(width: screenWidth * 0.06), // Same width as divider + margins
            
            // Right side title (Group 1)
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: screenWidth * 0.015),
                child: Text(
                  'گرووپی ١',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: groupTitleFontSize,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'kurdish',
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        
        // Player cards with divider
        Container(
          height: screenWidth < 600 
              ? screenWidth * 0.22 // Phone: taller cards
              : screenWidth * 0.175, // Tablet: keep current
          child: Row(
            children: [
              // Left column (2 cards stacked)
              Expanded(
                child: Column(
                  children: [
                    Expanded(child: _buildPlayerCard('کەسی ٣', screenWidth)),
                    SizedBox(height: screenWidth * 0.01), // Reduced spacing (was 0.02, now 0.01)
                    Expanded(child: _buildPlayerCard('کەسی ٤', screenWidth)),
                  ],
                ),
              ),
              
              // Vertical divider
              Container(
                width: 3,
                height: double.infinity,
                color: const Color(0xFFa6a6a6).withValues(alpha: 0.4),
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
              ),
              
              // Right column (2 cards stacked)
              Expanded(
                child: Column(
                  children: [
                    Expanded(child: _buildPlayerCard('کەسی ١', screenWidth)),
                    SizedBox(height: screenWidth * 0.01), // Reduced spacing (was 0.02, now 0.01)
                    Expanded(child: _buildPlayerCard('کەسی ٢', screenWidth)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Get background image URL based on random assignment
  String _getPlayerBackgroundUrl(String playerName) {
    // Use the randomly assigned background for this player
    final backgroundFile = _playerBackgrounds[playerName] ?? '2.png'; // Fallback to 2.png
    
    return SupabaseService.client.storage
        .from('Player BG')
        .getPublicUrl(backgroundFile);
  }

  Widget _buildPlayerCard(String playerName, double screenWidth) {
    final isPlayer1 = playerName == 'کەسی ١';
    final isEditable = !isPlayer1; // All players except Player 1 are editable
    final isCurrentlyEditing = _isEditing[playerName] ?? false;
    final hasBeenEdited = _hasBeenEdited[playerName] ?? false;
    
    // Determine outline color
    Color outlineColor;
    if (isPlayer1) {
      outlineColor = const Color(0xFF457A00); // Player 1 always green
    } else if (_hasValidationError[playerName] == true) {
      outlineColor = const Color(0xFFCC0000); // Red when validation error
    } else if (hasBeenEdited) {
      outlineColor = const Color(0xFF457A00); // Green when confirmed after editing (permanent)
    } else if (isCurrentlyEditing) {
      outlineColor = const Color(0xFF457A00); // Green when editing
    } else {
      outlineColor = const Color(0xFFa6a6a6).withValues(alpha: 0.6); // Default gray
    }
    
    // Determine text opacity - same for all states
    double textOpacity = 0.9; // Same opacity for all players and all states
    
    // Determine text size - same for all players but different on phone vs tablet
    double fontSize = screenWidth < 600 
        ? screenWidth * 0.03 // Phone: 3% of screen width
        : screenWidth * 0.025; // Tablet: keep current
    
    // Responsive icon size - bigger on phones
    double iconSize = screenWidth < 600 
        ? screenWidth * 0.08 // Phone: 8% of screen width (bigger)
        : screenWidth * 0.06; // Tablet: keep current
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(screenWidth * 0.02),
        border: Border.all(
          color: outlineColor,
          width: (isPlayer1 || hasBeenEdited || isCurrentlyEditing || (_hasValidationError[playerName] == true)) ? 2 : 1, // Thicker border for Player 1, when editing/edited, or validation error
        ),
        // Use background image instead of solid color
        image: DecorationImage(
          image: NetworkImage(_getPlayerBackgroundUrl(playerName)),
          fit: BoxFit.cover,
          onError: (exception, stackTrace) {
            debugPrint('Failed to load player background for $playerName: $exception');
          },
        ),
      ),
      child: Container(
        // Add a semi-transparent overlay to ensure text readability
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(screenWidth * 0.02),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center, // Center align vertically
            children: [
              // Player name on the left - editable for non-Player 1
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight, // Center vertically, right horizontally
                  child: isEditable
                      ? TextField(
                          controller: _controllers[playerName],
                          focusNode: _focusNodes[playerName],
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: textOpacity), // Dynamic opacity
                            fontSize: fontSize, // Same font size for all players
                            fontWeight: FontWeight.w500,
                            fontFamily: 'kurdish',
                            height: 1.1, // Same line height for all players
                            shadows: [
                              // Add glow effect for all players
                              Shadow(
                                color: Colors.white.withValues(alpha: 0.5),
                                blurRadius: 4,
                                offset: const Offset(0, 0),
                              ),
                            ], // Removed black outline shadows
                          ),
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right, // Always right align
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: screenWidth < 600 
                                ? EdgeInsets.only(bottom: fontSize * 0.35) // Phone: larger adjustment for centering
                                : EdgeInsets.zero, // Tablet: no padding
                            isDense: true, // Reduce vertical padding
                            hintText: _getPlaceholderText(_controllers[playerName]?.text ?? ''),
                            hintStyle: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: fontSize,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'kurdish',
                              height: 1.1,
                            ),
                          ),
                          maxLines: 1,
                          textAlignVertical: TextAlignVertical.center, // Center vertically
                          onSubmitted: (value) {
                            // Validate the text when user presses enter
                            if (_validatePlayerName(playerName, value)) {
                              // Mark as edited and confirmed when validation passes
                              setState(() {
                                _hasBeenEdited[playerName] = true;
                                _hasValidationError[playerName] = false; // Clear any previous error
                              });
                              // Unfocus when user presses enter
                              _focusNodes[playerName]?.unfocus();
                            }
                            // If validation fails, keep focus and show error
                          },
                          onTap: () {
                            // Clear the default text when tapped for the first time
                            if (_controllers[playerName]?.text == 'ناوکەت لێرە بنووسە') {
                              _controllers[playerName]?.clear();
                            } else {
                              // Select all text when tapped for easy editing
                              _controllers[playerName]?.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: _controllers[playerName]?.text.length ?? 0,
                              );
                            }
                          },
                          onChanged: (value) {
                            // Update state when text changes to trigger validation
                            setState(() {
                              // This will trigger a rebuild and update the hint text
                            });
                          },
                        )
                      : Text(
                          playerName,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: textOpacity), // Dynamic opacity
                            fontSize: fontSize, // Same font size for all players
                            fontWeight: FontWeight.w500,
                            fontFamily: 'kurdish',
                            height: 1.1, // Same line height for all players
                            shadows: [
                              // Add glow effect for all players
                              Shadow(
                                color: Colors.white.withValues(alpha: 0.5),
                                blurRadius: 4,
                                offset: const Offset(0, 0),
                              ),
                            ], // Removed black outline shadows
                          ),
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                        ),
                ),
              ),
              
              // More spacing between name and icon - closer on both devices
              SizedBox(width: screenWidth < 600 ? screenWidth * 0.008 : screenWidth * 0.015), // Closer on both phone and tablet
              
              // Profile icon on the right - use ProfileIcon widget for کەسی ١
              if (isPlayer1)
                // Use ProfileIcon widget for Player 1 - non-clickable in Groups
                ProfileIcon(
                  avatarService: widget.avatarService,
                  enableNavigation: false, // Disable navigation in Groups widget
                  customSize: iconSize, // Responsive size
                )
              else
                // Use generic icon for other players
                Container(
                  width: iconSize, // Responsive size
                  height: iconSize, // Square aspect ratio
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: 0.4),
                    border: Border.all(
                      color: const Color(0xFFa6a6a6).withValues(alpha: 0.8),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.white.withValues(alpha: 0.8),
                    size: iconSize * 0.58, // Proportional to icon size
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

