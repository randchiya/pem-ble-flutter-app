import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class SupabaseService {
  static const String _supabaseUrl = 'https://tjxpmrskptstimbtwlzc.supabase.co';
  static const String _supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRqeHBtcnNrcHRzdGltYnR3bHpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njk4NTE2NTEsImV4cCI6MjA4NTQyNzY1MX0.CQYwdaCPWyNuds99kP-Tds4tgaQaSIBoMj7B8c7UGdU';
  
  static SupabaseClient get client => Supabase.instance.client;
  
  static Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: _supabaseUrl,
        anonKey: _supabaseAnonKey,
      );
      debugPrint('Supabase initialized successfully');
    } catch (e) {
      debugPrint('Supabase initialization failed: $e');
    }
  }
  
  /// Get avatar image URL from Supabase storage
  static String getAvatarUrl(int avatarNumber) {
    return client.storage
        .from('Avatars')
        .getPublicUrl('$avatarNumber.png'); // Changed from 'avatar$avatarNumber.png' to '$avatarNumber.png'
  }
  
  /// Get avatar card background URL based on avatar number
  static String getAvatarCardBackgroundUrl(int avatarNumber) {
    // Each avatar now has its own unique background: Avatar 1.png, Avatar 2.png, etc.
    return client.storage
        .from('Avatars-Displays')
        .getPublicUrl('Avatar $avatarNumber.png');
  }
  
  /// Get selected overlay URL for avatar cards
  static String getSelectedOverlayUrl() {
    return client.storage
        .from('Avatars-Displays')
        .getPublicUrl('Selected-Overlay.png');
  }
  
  /// Get avatar1.png URL (default fallback)
  static String getDefaultAvatarUrl() {
    final url = client.storage
        .from('Avatars')
        .getPublicUrl('1.png'); // Changed from 'avatar1.png' to '1.png'
    debugPrint('Generated avatar URL: $url');
    
    // Also try to test the connection
    _testConnection();
    
    return url;
  }
  
  /// Test network connectivity to Supabase
  static void _testConnection() async {
    try {
      final response = await client.storage.from('Avatars').list();
      debugPrint('Supabase connection successful. Files in bucket: ${response.length}');
    } catch (e) {
      debugPrint('Supabase connection failed: $e');
      debugPrint('Please verify your Supabase project URL and ensure the bucket is public');
    }
  }
}