import 'package:flutter/material.dart';
import 'package:pem_ble_app/presentation/widgets/avatar_card.dart';
import 'package:pem_ble_app/presentation/widgets/responsive_background.dart';
import 'package:pem_ble_app/core/constants/app_assets.dart';
import 'package:pem_ble_app/presentation/widgets/buy_confirmation.dart';
import 'package:pem_ble_app/data/services/avatar_service.dart';
import 'package:pem_ble_app/presentation/widgets/profile_icon.dart';
import 'package:pem_ble_app/presentation/widgets/coin_counter.dart';

class AvatarScreen extends StatefulWidget {
  const AvatarScreen({super.key});

  @override
  State<AvatarScreen> createState() => _AvatarScreenState();
}

class _AvatarScreenState extends State<AvatarScreen> {
  final AvatarService _avatarService = AvatarService();

  @override
  void initState() {
    super.initState();
    _avatarService.addListener(_onAvatarChanged);
  }

  @override
  void dispose() {
    _avatarService.removeListener(_onAvatarChanged);
    super.dispose();
  }

  void _onAvatarChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Remove default back button
        actions: [
          // Profile icon, coin counter, and back button in the same row
          Padding(
            padding: const EdgeInsets.only(top: 5.0, right: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Profile icon widget
                ProfileIcon(avatarService: _avatarService),
                const SizedBox(width: 10), // Reduced from 20 to 10
                // Coin counter widget
                const CoinCounter(coinAmount: 1250),
                const SizedBox(width: 400), // Set to 400px for maximum space with back button
                // Back button
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Text(
                    'گەڕانەوە',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontFamily: 'Kurdish',
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.red,
                    ),
                  ),
                  label: const Icon(Icons.arrow_back, color: Colors.red),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ResponsiveBackground(
        imagePath: AppAssets.mainBackground,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: CustomScrollView(
                slivers: [
                  // Top spacing
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 20),
                  ),
                  // Text header as sliver
                  SliverToBoxAdapter(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6), // Darker background
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF212121), // Same outline as main cards
                          width: 2,
                        ),
                      ),
                      child: const Text(
                        'لێرەوە ئەتوانی ڕەسمی سەر پرۆفایلەکەت بگۆری بۆ کەسایەتی دڵخوازت',
                        style: TextStyle(
                          color: Colors.white, // White text for contrast against black background
                          fontSize: 16,
                          fontWeight: FontWeight.bold, // Make text bold
                          fontFamily: 'Kurdish',
                          height: 1.5,
                          shadows: [
                            Shadow(
                              offset: Offset(0.0, 1.0),
                              blurRadius: 2.0,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                  // Spacing between text and grid
                  SliverToBoxAdapter(
                    child: SizedBox(height: MediaQuery.of(context).size.width > 600 ? 40 : 30),
                  ),
                  // Avatar cards grid
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 3,
                      crossAxisSpacing: MediaQuery.of(context).size.width > 600 ? 16 : 12, // Reduced from 24/16 to 16/12
                      mainAxisSpacing: MediaQuery.of(context).size.width > 600 ? 20 : 16, // Reduced from 30/20 to 20/16
                      childAspectRatio: 1.0, // Changed from 0.75 to 1.0 since no buy button
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final cardNumber = index + 1;
                        final showCoinOverlay = cardNumber >= 4 && cardNumber <= 20;
                        final coinAmount = showCoinOverlay ? (cardNumber - 3) * 50 : 0;
                        final isOwned = _avatarService.isOwned(cardNumber);
                        final isSelected = _avatarService.isSelected(cardNumber);
                        
                        return AvatarCard(
                          title: 'کەسایەتی $cardNumber',
                          profileImagePath: _avatarService.getAvatarUrl(cardNumber),
                          avatarNumber: cardNumber, // Added avatar number parameter
                          hideAvatar: true, // Hide avatars in avatar screen
                          onBuyPressed: () {
                            if (isOwned) {
                              if (isSelected) {
                                // Already selected avatar
                                debugPrint('Avatar $cardNumber is already selected');
                              } else {
                                // Select this owned avatar
                                _avatarService.selectAvatar(cardNumber);
                                debugPrint('Selected owned avatar $cardNumber');
                              }
                            } else {
                              // Show buy confirmation popup for unowned avatars
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return BuyConfirmation(
                                    avatarTitle: 'کەسایەتی $cardNumber',
                                    coinAmount: coinAmount,
                                    onConfirm: () {
                                      Navigator.of(context).pop();
                                      // Handle purchase logic here
                                      _avatarService.purchaseAvatar(cardNumber);
                                      _avatarService.selectAvatar(cardNumber);
                                      debugPrint('Purchase confirmed for avatar $cardNumber');
                                    },
                                    onCancel: () {
                                      Navigator.of(context).pop();
                                      debugPrint('Purchase cancelled for avatar $cardNumber');
                                    },
                                  );
                                },
                              );
                            }
                          },
                          isTablet: MediaQuery.of(context).size.width > 600,
                          showCoinOverlay: showCoinOverlay,
                          coinAmount: coinAmount,
                          isOwned: isOwned,
                          isSelected: isSelected,
                        );
                      },
                      childCount: 20,
                    ),
                  ),
                  // Bottom spacing
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}