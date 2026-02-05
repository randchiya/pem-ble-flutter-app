import 'package:flutter/material.dart';
import 'package:pem_ble_app/data/services/avatar_service.dart';
import 'package:pem_ble_app/presentation/screens/profile_screen/profile_screen.dart';
import 'package:pem_ble_app/core/utils/page_transitions.dart';

class ProfileIcon extends StatelessWidget {
  final AvatarService avatarService;
  final bool enableNavigation;
  final double? customSize;

  const ProfileIcon({
    super.key,
    required this.avatarService,
    this.enableNavigation = true, // Default to true for backward compatibility
    this.customSize, // Optional custom size
  });

  // Get outline color based on selected avatar number
  Color _getAvatarOutlineColor(int avatarNumber) {
    if (avatarNumber >= 1 && avatarNumber <= 3) {
      return const Color(0xFFa6a6a6); // Default outline color
    } else if (avatarNumber >= 4 && avatarNumber <= 8) {
      return const Color(0xFF457A00); // Green
    } else if (avatarNumber >= 9 && avatarNumber <= 13) {
      return const Color(0xFF0025CC); // Blue
    } else if (avatarNumber >= 14 && avatarNumber <= 17) {
      return const Color(0xFF561269); // Purple
    } else if (avatarNumber >= 18 && avatarNumber <= 20) {
      return const Color(0xFFCCA300); // Gold
    } else {
      return const Color(0xFFa6a6a6); // Default fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Responsive sizing
    final size = customSize ?? (screenWidth < 600 ? 36.0 : 44.0); // Smaller on phone
    final borderWidth = screenWidth < 600 ? 1.5 : 2.0; // Thinner border on phone
    final radius = size / 2;
    
    final widget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4), // Made lighter (reduced from 0.6 to 0.4)
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: _getAvatarOutlineColor(avatarService.selectedAvatarId), // Dynamic outline color
          width: borderWidth,
        ),
      ),
      child: CircleAvatar(
        radius: radius - borderWidth,
        backgroundColor: Colors.transparent, // Made transparent instead of white
        backgroundImage: NetworkImage(
          avatarService.getSelectedAvatarUrl(),
        ),
        onBackgroundImageError: (exception, stackTrace) {
          debugPrint('Failed to load profile avatar: $exception');
        },
        child: null, // Let the backgroundImage show, fallback to backgroundColor if it fails
      ),
    );

    // Conditionally wrap with GestureDetector based on enableNavigation
    if (enableNavigation) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageTransitions.fadeTransition(const ProfileScreen()),
          );
        },
        child: widget,
      );
    } else {
      return widget;
    }
  }
}