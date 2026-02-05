import 'package:flutter/material.dart';
import 'package:pem_ble_app/presentation/widgets/responsive_background.dart';
import 'package:pem_ble_app/core/constants/app_assets.dart';
import 'package:pem_ble_app/data/services/avatar_service.dart';
import 'package:pem_ble_app/presentation/widgets/profile_icon.dart';
import 'package:pem_ble_app/presentation/widgets/coin_counter.dart';

class OnlineRuleScreen extends StatefulWidget {
  const OnlineRuleScreen({super.key});

  @override
  State<OnlineRuleScreen> createState() => _OnlineRuleScreenState();
}

class _OnlineRuleScreenState extends State<OnlineRuleScreen> {
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
      body: ResponsiveBackground(
        imagePath: AppAssets.mainBackground,
        child: SafeArea(
          child: Stack(
            children: [
              // Main content
              Padding(
                padding: const EdgeInsets.only(top: 80, left: 24, right: 24, bottom: 24),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: CustomScrollView(
                    slivers: [
                      // Text header as sliver
                      SliverToBoxAdapter(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF212121),
                              width: 2,
                            ),
                          ),
                          child: const Text(
                            'یاساکانی یاریی ئۆنلاین',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
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
                      // Spacing between text and content
                      SliverToBoxAdapter(
                        child: SizedBox(height: MediaQuery.of(context).size.width > 600 ? 40 : 30),
                      ),
                      // Rules content
                      SliverToBoxAdapter(
                        child: Container(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'یاساکانی گشتی',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Kurdish',
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                              SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                              Text(
                                '• ڕێزگرتن لە یاریزانانی تر\n'
                                '• قەدەغەیە بەکارهێنانی وشەی ناشیرین\n'
                                '• یاری بە دادپەروەری\n'
                                '• پەیوەندی بە ئینتەرنێت پێویستە\n'
                                '• کاتی یاری سنووردارە',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: MediaQuery.of(context).size.width * 0.035,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Kurdish',
                                  height: 1.8,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                            ],
                          ),
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
              // Profile icon, coin counter, and back button in top row
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Row(
                  children: [
                    // Profile icon widget
                    ProfileIcon(avatarService: _avatarService),
                    const SizedBox(width: 10),
                    // Coin counter widget
                    const CoinCounter(coinAmount: 1250),
                    const Spacer(),
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
        ),
      ),
    );
  }
}