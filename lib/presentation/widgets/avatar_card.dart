import 'package:flutter/material.dart';
import 'package:pem_ble_app/data/services/supabase_service.dart';

class AvatarCard extends StatelessWidget {
  final String title;
  final String profileImagePath;
  final VoidCallback onBuyPressed;
  final bool isTablet;
  final bool showCoinOverlay;
  final int coinAmount;
  final bool isOwned;
  final bool isSelected;
  final int avatarNumber; // Added avatar number to determine background
  final bool hideAvatar; // Added parameter to hide avatar image

  const AvatarCard({
    super.key,
    required this.title,
    required this.profileImagePath,
    required this.onBuyPressed,
    required this.avatarNumber, // Required parameter
    this.isTablet = false,
    this.showCoinOverlay = false,
    this.coinAmount = 0,
    this.isOwned = false,
    this.isSelected = false,
    this.hideAvatar = false, // Default to showing avatar
  });

  @override
  Widget build(BuildContext context) {
    final double cardSize = isTablet ? 140 : 100;
    final double avatarRadius = isTablet ? 32 : 24; // Increased from 28/20 to 32/24
    final double fontSize = isTablet ? 12 : 10;
    
    return GestureDetector(
      onTap: onBuyPressed, // Make entire card clickable
      child: Column(
        children: [
          // Main square card with overlay
          Stack(
            children: [
              // Background image container
              Container(
                width: cardSize,
                height: cardSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                  // Removed border outline
                  image: DecorationImage(
                    image: NetworkImage(SupabaseService.getAvatarCardBackgroundUrl(avatarNumber)),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {
                      debugPrint('Failed to load avatar card background: $exception');
                    },
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Add some top spacing to push avatar down
                    SizedBox(height: isTablet ? 30 : 25), // Increased from 25/20 to 30/25 to push text lower
                    // Profile picture in the middle (moved down and left) - conditionally shown
                    if (!hideAvatar) // Only show avatar if hideAvatar is false
                      Transform.translate(
                        offset: const Offset(-1, 0), // Move 1 pixel to the left
                        child: CircleAvatar(
                          radius: avatarRadius,
                          backgroundColor: Colors.transparent, // Changed from black to transparent
                          backgroundImage: profileImagePath.isNotEmpty 
                              ? NetworkImage(profileImagePath)
                              : NetworkImage(SupabaseService.getDefaultAvatarUrl()),
                          onBackgroundImageError: (exception, stackTrace) {
                            debugPrint('Failed to load avatar image: $exception');
                          },
                          child: null, // Let the backgroundImage show, fallback to backgroundColor if it fails
                        ),
                      ),
                    // Flexible spacer to push text to bottom
                    const Spacer(),
                    // Text at the bottom
                    Padding(
                      padding: EdgeInsets.only(
                        left: isTablet ? 6 : 4,
                        right: isTablet ? 6 : 4,
                        bottom: isTablet ? 10 : 6, // Reduced from 12/8 to 10/6 (2px lower)
                      ),
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: fontSize,
                          fontWeight: FontWeight.w900, // Changed from FontWeight.bold to FontWeight.w900 (extra bold)
                          fontFamily: 'Kurdish',
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              // Selected overlay (on top of background and avatar)
              if (isSelected)
                Container(
                  width: cardSize,
                  height: cardSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                    image: DecorationImage(
                      image: NetworkImage(SupabaseService.getSelectedOverlayUrl()),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {
                        debugPrint('Failed to load selected overlay: $exception');
                      },
                    ),
                  ),
                ),
              // Coin overlay for unowned cards only
              if (showCoinOverlay && !isOwned)
                Positioned(
                  top: isTablet ? -8 : -6,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.only(
                        left: isTablet ? 8 : 6,
                        right: isTablet ? 8 : 6,
                        top: isTablet ? 6 : 5,
                        bottom: isTablet ? 2 : 1,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                        border: Border.all(
                          color: Colors.amber.shade700,
                          width: isTablet ? 2 : 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: isTablet ? 4 : 3,
                            offset: Offset(0, isTablet ? 2 : 1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Left line
                          Container(
                            width: isTablet ? 20 : 16,
                            height: 1,
                            color: Colors.black87,
                          ),
                          // Coin amount and icon
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: isTablet ? 3 : 2),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  coinAmount.toString().padLeft(3, '0'),
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: isTablet ? 10 : 8,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Kurdish',
                                  ),
                                ),
                                SizedBox(width: isTablet ? 2 : 1),
                                // New coin icon from Supabase
                                SizedBox(
                                  width: isTablet ? 12 : 10,
                                  height: isTablet ? 12 : 10,
                                  child: Image.network(
                                    SupabaseService.client.storage
                                        .from('Icons')
                                        .getPublicUrl('coin.png'),
                                    width: isTablet ? 12 : 10,
                                    height: isTablet ? 12 : 10,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      // Fallback to original icon if image fails to load
                                      return Icon(
                                        Icons.monetization_on,
                                        color: Colors.amber.shade700,
                                        size: isTablet ? 12 : 10,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Right line
                          Container(
                            width: isTablet ? 20 : 16,
                            height: 1,
                            color: Colors.black87,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}