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
  
  void _showEditTimerDialog() {
    // Stop timer while editing
    final wasRunning = _isRunning;
    if (_isRunning) {
      _stopTimer();
    }
    
    // Calculate current minutes and seconds
    int currentMinutes = _totalSeconds ~/ 60;
    int currentSeconds = _totalSeconds % 60;
    
    // Controllers for input
    final minutesController = TextEditingController(text: currentMinutes.toString());
    final secondsController = TextEditingController(text: currentSeconds.toString());
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: const Color(0xFF313030),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(
                color: Color(0xFFa6a6a6),
                width: 2,
              ),
            ),
            title: const Text(
              'گۆڕینی کات',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'kurdish',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Seconds input
                    SizedBox(
                      width: 80,
                      child: TextField(
                        controller: secondsController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          labelText: 'چرکە',
                          labelStyle: const TextStyle(
                            color: Color(0xFFa6a6a6),
                            fontFamily: 'kurdish',
                          ),
                          filled: true,
                          fillColor: Colors.black.withValues(alpha: 0.3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFa6a6a6),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFa6a6a6),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF457A00),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        ':',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Minutes input
                    SizedBox(
                      width: 80,
                      child: TextField(
                        controller: minutesController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          labelText: 'خولەک',
                          labelStyle: const TextStyle(
                            color: Color(0xFFa6a6a6),
                            fontFamily: 'kurdish',
                          ),
                          filled: true,
                          fillColor: Colors.black.withValues(alpha: 0.3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFa6a6a6),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFa6a6a6),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF457A00),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Cancel button
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Resume timer if it was running
                      if (wasRunning) {
                        _startTimer();
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey.withValues(alpha: 0.3),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'پاشگەزبوونەوە',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'kurdish',
                        fontSize: 16,
                      ),
                    ),
                  ),
                  // Confirm button
                  TextButton(
                    onPressed: () {
                      final minutes = int.tryParse(minutesController.text) ?? 0;
                      final seconds = int.tryParse(secondsController.text) ?? 0;
                      
                      // Validate input
                      if (minutes < 0 || minutes > 99 || seconds < 0 || seconds > 59) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'تکایە ژمارەیەکی دروست بنووسە (خولەک: ٠-٩٩، چرکە: ٠-٥٩)',
                              style: TextStyle(fontFamily: 'kurdish'),
                              textDirection: TextDirection.rtl,
                            ),
                            backgroundColor: Color(0xFFCC0000),
                          ),
                        );
                        return;
                      }
                      
                      setState(() {
                        _totalSeconds = (minutes * 60) + seconds;
                      });
                      
                      Navigator.of(context).pop();
                      
                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'کات بە سەرکەوتوویی گۆڕدرا',
                            style: TextStyle(fontFamily: 'kurdish'),
                            textDirection: TextDirection.rtl,
                          ),
                          backgroundColor: Color(0xFF457A00),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF457A00),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'پەسەندکردن',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'kurdish',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ).then((_) {
      // Clean up controllers
      minutesController.dispose();
      secondsController.dispose();
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
                onTap: _showEditTimerDialog,
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