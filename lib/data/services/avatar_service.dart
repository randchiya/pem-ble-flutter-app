import 'package:flutter/foundation.dart';
import 'package:pem_ble_app/data/services/supabase_service.dart';

class AvatarService extends ChangeNotifier {
  static final AvatarService _instance = AvatarService._internal();
  factory AvatarService() => _instance;
  AvatarService._internal();

  int _selectedAvatarId = 1; // Default to avatar 1
  final Set<int> _ownedAvatars = {1, 2, 3}; // Avatars 1-3 are always owned

  int get selectedAvatarId => _selectedAvatarId;
  Set<int> get ownedAvatars => _ownedAvatars;

  bool isOwned(int avatarId) => _ownedAvatars.contains(avatarId);
  bool isSelected(int avatarId) => _selectedAvatarId == avatarId;

  void selectAvatar(int avatarId) {
    if (isOwned(avatarId)) {
      _selectedAvatarId = avatarId;
      notifyListeners();
    }
  }

  void purchaseAvatar(int avatarId) {
    _ownedAvatars.add(avatarId);
    notifyListeners();
  }

  String getSelectedAvatarUrl() {
    // Use individual avatar files: 1.png, 2.png, 3.png, etc.
    return SupabaseService.getAvatarUrl(_selectedAvatarId);
  }

  String getAvatarUrl(int avatarId) {
    // Use individual avatar files: 1.png, 2.png, 3.png, etc.
    return SupabaseService.getAvatarUrl(avatarId);
  }
}