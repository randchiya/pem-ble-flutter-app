import 'package:flutter/material.dart';
import 'package:pem_ble_app/presentation/widgets/navigation_drawer.dart';
import 'package:pem_ble_app/presentation/widgets/responsive_background.dart';
import 'package:pem_ble_app/core/constants/app_assets.dart';
import 'package:pem_ble_app/data/services/avatar_service.dart';
import 'package:pem_ble_app/presentation/widgets/profile_icon.dart';
import 'package:pem_ble_app/presentation/widgets/coin_counter.dart';
import 'package:pem_ble_app/presentation/widgets/groups.dart';
import 'package:pem_ble_app/presentation/widgets/timer.dart';
import 'package:pem_ble_app/presentation/widgets/hamburger_menu.dart';
import 'package:pem_ble_app/presentation/widgets/card_type_selector.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final AvatarService _avatarService = AvatarService();
  
  int _selectedCardType = 5; // Default to card 5

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

  void _onCardTypeChanged(int cardNumber) {
    setState(() {
      _selectedCardType = cardNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      endDrawer: const AppNavigationDrawer(currentScreen: 'یاریکردن'),
      body: Builder(
        builder: (BuildContext scaffoldContext) {
          return ResponsiveBackground(
            imagePath: AppAssets.mainBackground,
            child: SafeArea(
              child: Stack(
                children: [
                  // Scrollable content
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 70), // Added top padding for fixed header
                    child: Column(
                      children: [
                        // Card Type Selector widget
                        Center(
                          child: CardTypeSelector(
                            onCardChanged: _onCardTypeChanged,
                          ),
                        ),
                        const SizedBox(height: 30), // Spacing between card types and groups
                        
                        // Groups widget
                        Center(
                          child: Groups(avatarService: _avatarService),
                        ),
                        const SizedBox(height: 30), // Spacing between groups and timer
                        
                        // Timer widget
                        Center(
                          child: TimerWidget(
                            initialMinutes: 5,
                            initialSeconds: 0,
                            onTimerFinished: () {
                              // Handle timer finished
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'کات تەواو بوو!',
                                    style: TextStyle(fontFamily: 'kurdish'),
                                    textDirection: TextDirection.rtl,
                                  ),
                                  backgroundColor: Color(0xFFCC0000),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 100), // Extra space at bottom for comfortable scrolling
                      ],
                    ),
                  ),
                  // Profile icon and coin counter in top left corner (fixed position)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Row(
                      children: [
                        ProfileIcon(avatarService: _avatarService),
                        const SizedBox(width: 12),
                        const CoinCounter(coinAmount: 1250),
                      ],
                    ),
                  ),
                  // Hamburger menu icon in top right corner (fixed position)
                  HamburgerMenu(
                    onTap: () {
                      Scaffold.of(scaffoldContext).openEndDrawer();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}