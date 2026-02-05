import 'package:flutter/material.dart';
import 'package:pem_ble_app/presentation/screens/avatar_screen/avatar_screen.dart';
import 'package:pem_ble_app/presentation/screens/game_screen/game_screen.dart';
import 'package:pem_ble_app/presentation/screens/rules_screen/rules_screen.dart';
import 'package:pem_ble_app/presentation/screens/profile_screen/profile_screen.dart';
import 'package:pem_ble_app/presentation/screens/coin_screen/coin_screen.dart';
import 'package:pem_ble_app/presentation/screens/history_screen/history_screen.dart';
import 'package:pem_ble_app/presentation/screens/report_screen/report_screen.dart';
import 'package:pem_ble_app/core/utils/page_transitions.dart';
import 'package:pem_ble_app/data/services/avatar_service.dart';

class AppNavigationDrawer extends StatefulWidget {
  final String? currentScreen;
  
  const AppNavigationDrawer({super.key, this.currentScreen});

  @override
  State<AppNavigationDrawer> createState() => _AppNavigationDrawerState();
}

class _AppNavigationDrawerState extends State<AppNavigationDrawer> {
  String? selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.currentScreen;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: SafeArea(
        child: Column(
          children: [
            // Header section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // Close drawer first
                          Navigator.push(
                            context,
                            PageTransitions.fadeTransition(const AvatarScreen()),
                          );
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.black, // Changed from white to black
                          backgroundImage: NetworkImage(
                            AvatarService().getSelectedAvatarUrl(),
                          ),
                          onBackgroundImageError: (exception, stackTrace) {
                            debugPrint('Failed to load profile avatar: $exception');
                          },
                          child: null, // Let the backgroundImage show, fallback to backgroundColor if it fails
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context); // Close drawer first
                            Navigator.push(
                              context,
                              PageTransitions.fadeTransition(const AvatarScreen()),
                            );
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'User Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const Text(
                    'user@example.com',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
            // Menu items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildMenuItem(
                    icon: Icons.sports_esports,
                    title: 'یاریکردن',
                    isSelected: selectedItem == 'یاریکردن',
                    onTap: () {
                      setState(() {
                        selectedItem = 'یاریکردن';
                      });
                      final navigator = Navigator.of(context);
                      navigator.pop();
                      Future.delayed(const Duration(milliseconds: 250), () {
                        if (mounted) {
                          navigator.push(
                            PageTransitions.fadeTransition(const GameScreen()),
                          );
                        }
                      });
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.gavel,
                    title: 'یاساکان',
                    isSelected: selectedItem == 'یاساکان',
                    onTap: () {
                      setState(() {
                        selectedItem = 'یاساکان';
                      });
                      final navigator = Navigator.of(context);
                      navigator.pop();
                      Future.delayed(const Duration(milliseconds: 250), () {
                        if (mounted) {
                          navigator.push(
                            PageTransitions.fadeTransition(const RulesScreen()),
                          );
                        }
                      });
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.person,
                    title: 'پرۆفایل',
                    isSelected: selectedItem == 'پرۆفایل',
                    onTap: () {
                      setState(() {
                        selectedItem = 'پرۆفایل';
                      });
                      final navigator = Navigator.of(context);
                      navigator.pop();
                      Future.delayed(const Duration(milliseconds: 250), () {
                        if (mounted) {
                          navigator.push(
                            PageTransitions.fadeTransition(const ProfileScreen()),
                          );
                        }
                      });
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.monetization_on,
                    title: 'کۆین',
                    isSelected: selectedItem == 'کۆین',
                    onTap: () {
                      setState(() {
                        selectedItem = 'کۆین';
                      });
                      final navigator = Navigator.of(context);
                      navigator.pop();
                      Future.delayed(const Duration(milliseconds: 250), () {
                        if (mounted) {
                          navigator.push(
                            PageTransitions.fadeTransition(const CoinScreen()),
                          );
                        }
                      });
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.history,
                    title: 'یاریەکانی پێشوو',
                    isSelected: selectedItem == 'یاریەکانی پێشوو',
                    onTap: () {
                      setState(() {
                        selectedItem = 'یاریەکانی پێشوو';
                      });
                      final navigator = Navigator.of(context);
                      navigator.pop();
                      Future.delayed(const Duration(milliseconds: 250), () {
                        if (mounted) {
                          navigator.push(
                            PageTransitions.fadeTransition(const HistoryScreen()),
                          );
                        }
                      });
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.report,
                    title: 'ریپۆرت',
                    isSelected: selectedItem == 'ریپۆرت',
                    onTap: () {
                      setState(() {
                        selectedItem = 'ریپۆرت';
                      });
                      final navigator = Navigator.of(context);
                      navigator.pop();
                      Future.delayed(const Duration(milliseconds: 250), () {
                        if (mounted) {
                          navigator.push(
                            PageTransitions.fadeTransition(const ReportScreen()),
                          );
                        }
                      });
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.wifi,
                    title: 'یاریی ئۆنلاین',
                    subtitle: 'بەمزوانە بەردەست دەبێت',
                    isSelected: selectedItem == 'یاریی ئۆنلاین',
                    isDisabled: true,
                    onTap: () {
                      // Do nothing - disabled
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.rule,
                    title: 'یاساکانی ئۆنلاین',
                    subtitle: 'بەمزوانە بەردەست دەبێت',
                    isSelected: selectedItem == 'یاساکانی ئۆنلاین',
                    isDisabled: true,
                    onTap: () {
                      // Do nothing - disabled
                    },
                  ),
                  const Divider(
                    color: Colors.white24,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                  _buildMenuItem(
                    icon: Icons.logout,
                    title: 'چوونەدەرەوە',
                    isRed: true,
                    onTap: () {
                      Navigator.pop(context);
                      debugPrint('چوونەدەرەوە tapped');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? subtitle,
    bool isRed = false,
    bool isSelected = false,
    bool isDisabled = false,
  }) {
    final Color itemColor = isRed ? Colors.red : (isDisabled ? Colors.white.withValues(alpha: 0.5) : Colors.white);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        border: isSelected ? Border.all(
          color: Colors.blue.withValues(alpha: 0.6),
          width: 2,
        ) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        trailing: Icon(
          icon,
          color: itemColor,
          size: 24,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              title,
              style: TextStyle(
                color: itemColor,
                fontSize: 16,
                fontFamily: 'Kurdish',
                decoration: isDisabled ? TextDecoration.lineThrough : null,
                decorationColor: itemColor,
                decorationThickness: 2,
              ),
              textAlign: TextAlign.right,
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: TextStyle(
                  color: itemColor.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Kurdish',
                ),
                textAlign: TextAlign.right,
              ),
          ],
        ),
        onTap: isDisabled ? null : onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        hoverColor: isDisabled ? null : itemColor.withValues(alpha: 0.1),
      ),
    );
  }
}