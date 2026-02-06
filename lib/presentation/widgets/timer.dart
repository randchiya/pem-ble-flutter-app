import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pem_ble_app/data/services/supabase_service.dart';

class TimerWidget extends StatefulWidget {
  final int initialMinutes;
  final int initialSeconds;
  final VoidCallback? onTimerFinished;
  final bool autoStart;
  
  const TimerWidget({
    super.key,
    this.initialMinutes = 5,
    this.initialSeconds = 0,
    this.onTimerFinished,
    this.autoStart = false,
  });

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late int _totalSeconds;
  Timer? _timer;
  bool _isRunning = false;
  
  @override
  void initState() {
    super.initState();
    _totalSeconds = (widget.initialMinutes * 60) + widget.initialSeconds;
    
    if (widget.autoStart) {
      _startTimer();
    }
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  
  void _startTimer() {
    if (_totalSeconds <= 0) return;
    
    setState(() {
      _isRunning = true;
    });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_totalSeconds > 0) {
          _totalSeconds--;
        } else {
          _stopTimer();
          widget.onTimerFinished?.call();
        }
      });
    });
  }
  
  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }
  
  String _formatTime() {
    int minutes = _totalSeconds ~/ 60;
    int seconds = _totalSeconds % 60;
    
    // Convert to Kurdish numerals and remove leading zeros
    String minutesStr = _toKurdishNumerals(minutes.toString());
    String secondsStr = _toKurdishNumerals(seconds.toString().padLeft(2, '0'));
    
    return '$minutesStr:$secondsStr';
  }
  
  // Convert English numerals to Kurdish numerals
  String _toKurdishNumerals(String englishNumber) {
    const englishToKurdish = {
      '0': '٠',
      '1': '١',
      '2': '٢',
      '3': '٣',
      '4': '٤',
      '5': '٥',
      '6': '٦',
      '7': '٧',
      '8': '٨',
      '9': '٩',
    };
    
    String result = englishNumber;
    englishToKurdish.forEach((english, kurdish) {
      result = result.replaceAll(english, kurdish);
    });
    
    return result;
  }
  
  // Get timer icon URL from Supabase
  String _getTimerIconUrl() {
    return SupabaseService.client.storage
        .from('Icons')
        .getPublicUrl('timer.png');
  }
  
  // Get edit timer icon URL from Supabase
  String _getEditTimerIconUrl() {
    return SupabaseService.client.storage
        .from('Icons')
        .getPublicUrl('edit-timer.png');
  }
  
  // Get timer digit background URL from Supabase
  String _getTimerDigitBgUrl() {
    return SupabaseService.client.storage
        .from('Timer BG')
        .getPublicUrl('Timer-digit-bg.png');
  }
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Use same styling as other widgets
    final borderWidth = screenWidth * 0.006; // 0.6% of screen width
    
    // Responsive height-based padding and spacing
    double verticalPadding;
    double verticalSpacing;
    double iconSpacing;
    
    if (screenHeight < 600) {
      // Small screens (phones in landscape, small phones)
      verticalPadding = screenWidth * 0.015; // Reduced padding
      verticalSpacing = screenWidth * 0.005; // Further reduced spacing between icon and timer
      iconSpacing = screenWidth * 0.015; // Reduced icon spacing to compensate for larger icon
    } else if (screenHeight < 800) {
      // Medium screens (most phones in portrait)
      verticalPadding = screenWidth * 0.02; // Medium padding
      verticalSpacing = screenWidth * 0.008; // Further reduced spacing between icon and timer
      iconSpacing = screenWidth * 0.02; // Reduced icon spacing to compensate for larger icon
    } else {
      // Large screens (tablets, large phones)
      verticalPadding = screenWidth * 0.025; // Full padding
      verticalSpacing = screenWidth * 0.01; // Further reduced spacing between icon and timer
      iconSpacing = screenWidth * 0.025; // Reduced icon spacing to compensate for larger icon
    }
    
    return Container(
      width: screenWidth - 48, // Keep width consistent with other widgets
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.025,
        vertical: verticalPadding, // Responsive vertical padding
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF313030).withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(screenWidth * 0.025),
        border: Border.all(
          color: const Color(0xFFa6a6a6),
          width: borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.1),
            blurRadius: 6,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Edit button with text at the top (no extra spacing)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  // TODO: Add edit timer functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'دەستکاری کردنی کات',
                        style: TextStyle(fontFamily: 'kurdish'),
                        textDirection: TextDirection.rtl,
                      ),
                      backgroundColor: Color(0xFF457A00),
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'کلیک لێرە بکە بۆ گۆرینی کات',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: screenWidth < 600 
                            ? screenWidth * 0.03 // Phone: 3% of screen width
                            : screenWidth * 0.02, // Tablet: keep current
                        fontWeight: FontWeight.w400,
                        fontFamily: 'kurdish',
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(width: screenWidth * 0.01),
                    SizedBox(
                      width: screenWidth * 0.035,
                      height: screenWidth * 0.035,
                      child: Image.network(
                        _getEditTimerIconUrl(),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: screenWidth * 0.035,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: iconSpacing), // Responsive spacing
          
          // Timer icon under the title (bigger)
          SizedBox(
            width: screenWidth * 0.15, // Increased from 0.12 to 0.15 (25% bigger)
            height: screenWidth * 0.15, // Increased from 0.12 to 0.15 (25% bigger)
            child: Image.network(
              _getTimerIconUrl(),
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.timer,
                  color: Colors.white,
                  size: screenWidth * 0.15, // Increased from 0.12 to 0.15 (25% bigger)
                );
              },
            ),
          ),
          SizedBox(height: verticalSpacing), // Responsive spacing
          
          // Timer display (centered, with background image and fade-out edges)
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.white,
                  Colors.white,
                  Colors.transparent,
                ],
                stops: const [0.0, 0.15, 0.85, 1.0],
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstIn,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.transparent,
                    Colors.white,
                    Colors.white,
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.15, 0.85, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06,
                  vertical: screenWidth < 600 
                      ? screenWidth * 0.01 // Phone: decreased height
                      : screenWidth * 0.008, // Tablet: keep current
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  image: DecorationImage(
                    image: NetworkImage(_getTimerDigitBgUrl()),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {
                      debugPrint('Failed to load timer digit background: $exception');
                    },
                  ),
                ),
                child: Text(
                  _formatTime(),
                  style: TextStyle(
                    color: _totalSeconds <= 10 && _isRunning 
                        ? const Color(0xFFFF4444) // Red text when time is running out
                    : Colors.white,
                fontSize: screenWidth < 600 
                    ? screenWidth * 0.06 // Phone: keep current size
                    : screenWidth * 0.04, // Tablet: reduce size by 33%
                fontWeight: FontWeight.bold,
                fontFamily: 'kurdish',
                shadows: [
                  Shadow(
                    color: Colors.white.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 0),
                  ),
                  Shadow(
                    color: Colors.black,
                    blurRadius: 1,
                    offset: const Offset(-1, -1),
                  ),
                  Shadow(
                    color: Colors.black,
                    blurRadius: 1,
                    offset: const Offset(1, -1),
                  ),
                  Shadow(
                    color: Colors.black,
                    blurRadius: 1,
                    offset: const Offset(-1, 1),
                  ),
                  Shadow(
                    color: Colors.black,
                    blurRadius: 1,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
            ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}