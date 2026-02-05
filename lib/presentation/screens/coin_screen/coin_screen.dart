import 'package:flutter/material.dart';
import 'package:pem_ble_app/presentation/widgets/navigation_drawer.dart';
import 'package:pem_ble_app/presentation/widgets/responsive_background.dart';
import 'package:pem_ble_app/core/constants/app_assets.dart';
import 'package:pem_ble_app/data/services/avatar_service.dart';
import 'package:pem_ble_app/presentation/widgets/profile_icon.dart';
import 'package:pem_ble_app/presentation/widgets/coin_counter.dart';
import 'package:pem_ble_app/presentation/widgets/hamburger_menu.dart';

class CoinScreen extends StatefulWidget {
  const CoinScreen({super.key});

  @override
  State<CoinScreen> createState() => _CoinScreenState();
}

class _CoinScreenState extends State<CoinScreen> {
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
      endDrawer: const AppNavigationDrawer(currentScreen: 'کۆین'),
      body: Builder(
        builder: (BuildContext scaffoldContext) {
          return ResponsiveBackground(
            imagePath: AppAssets.mainBackground,
            child: SafeArea(
              child: Stack(
                children: [
                  // Main content
                  const Center(
                    child: Text(
                      'کۆین',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Kurdish',
                      ),
                      textDirection: TextDirection.rtl,
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