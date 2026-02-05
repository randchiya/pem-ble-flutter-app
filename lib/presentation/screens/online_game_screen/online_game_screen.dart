import 'package:flutter/material.dart';
import 'package:pem_ble_app/presentation/widgets/responsive_background.dart';
import 'package:pem_ble_app/core/constants/app_assets.dart';
import 'package:pem_ble_app/data/services/avatar_service.dart';
import 'package:pem_ble_app/presentation/widgets/profile_icon.dart';
import 'package:pem_ble_app/presentation/widgets/coin_counter.dart';
import 'package:pem_ble_app/presentation/widgets/hamburger_menu.dart';
import 'package:pem_ble_app/presentation/widgets/navigation_drawer.dart';

class OnlineGameScreen extends StatefulWidget {
  const OnlineGameScreen({super.key});

  @override
  State<OnlineGameScreen> createState() => _OnlineGameScreenState();
}

class _OnlineGameScreenState extends State<OnlineGameScreen> {
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
      backgroundColor: Colors.black,
      endDrawer: const AppNavigationDrawer(currentScreen: 'یاریی ئۆنلاین'),
      body: Builder(
        builder: (BuildContext scaffoldContext) {
          return ResponsiveBackground(
            imagePath: AppAssets.mainBackground,
            child: SafeArea(
              child: Stack(
                children: [
                  // Scrollable content
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 80, left: 24, right: 24, bottom: 24),
                    child: Column(
                      children: [
                        // Online game content placeholder
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.20),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF374a76),
                              width: 2.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                'یاریی ئۆنلاین',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Kurdish',
                                ),
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: MediaQuery.of(context).size.width * 0.008),
                              Container(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.width > 600 ? 6 : 4,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF374a76),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.width * 0.025),
                              Text(
                                'ئەم بەشە بۆ یاریی ئۆنلاین لەگەڵ یاریزانانی تر لە سەرانسەری جیهان',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: MediaQuery.of(context).size.width * 0.035,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Kurdish',
                                  height: 1.5,
                                ),
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 100), // Extra space at bottom
                      ],
                    ),
                  ),
                  // Profile icon and coin counter in top left corner
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Row(
                      children: [
                        // Profile icon widget
                        ProfileIcon(avatarService: _avatarService),
                        const SizedBox(width: 12),
                        // Coin counter widget
                        const CoinCounter(coinAmount: 1250),
                      ],
                    ),
                  ),
                  // Hamburger menu icon in top right corner
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