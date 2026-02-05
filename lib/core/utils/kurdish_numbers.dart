class KurdishNumbers {
  static const Map<String, String> _englishToKurdish = {
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

  /// Convert English numbers to Kurdish numbers
  static String toKurdish(int number) {
    String numberStr = number.toString();
    String kurdishNumber = '';
    
    for (int i = 0; i < numberStr.length; i++) {
      String digit = numberStr[i];
      kurdishNumber += _englishToKurdish[digit] ?? digit;
    }
    
    return kurdishNumber;
  }

  /// Convert English number string to Kurdish numbers
  static String toKurdishFromString(String numberStr) {
    String kurdishNumber = '';
    
    for (int i = 0; i < numberStr.length; i++) {
      String digit = numberStr[i];
      kurdishNumber += _englishToKurdish[digit] ?? digit;
    }
    
    return kurdishNumber;
  }
}