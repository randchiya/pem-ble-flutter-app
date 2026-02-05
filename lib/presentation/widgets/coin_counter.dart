import 'package:flutter/material.dart';
import 'package:pem_ble_app/core/utils/kurdish_numbers.dart';
import 'package:pem_ble_app/presentation/screens/coin_screen/coin_screen.dart';
import 'package:pem_ble_app/core/utils/page_transitions.dart';
import 'package:pem_ble_app/data/services/supabase_service.dart';

class CoinCounter extends StatelessWidget {
  final int coinAmount;

  const CoinCounter({
    super.key,
    this.coinAmount = 1250, // Default coin amount
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransitions.fadeTransition(const CoinScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF2D1B00), // Dark bronze
              const Color(0xFF1A1A1A), // Very dark gray
              const Color(0xFF2D1B00), // Dark bronze
            ],
            stops: const [0.0, 0.5, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12), // Reduced from 50 to make it less rounded
          border: Border.all(
            color: const Color(0xFFebae2d), // Changed to #ebae2d (golden yellow)
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
            BoxShadow(
              color: Colors.amber.shade700.withValues(alpha: 0.1),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16, // Reduced from 20 to 16
              height: 16, // Reduced from 20 to 16
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.shade700.withValues(alpha: 0.3),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  SupabaseService.client.storage
                      .from('Icons')
                      .getPublicUrl('coin.png'),
                  width: 14, // Reduced from 16 to 14
                  height: 14, // Reduced from 16 to 14
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to original icon if image fails to load
                    return Icon(
                      Icons.monetization_on,
                      color: Colors.amber.shade700,
                      size: 14, // Reduced from 16 to 14
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              KurdishNumbers.toKurdish(coinAmount),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Kurdish',
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(width: 6),
            // Blue plus button
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.6),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.blue.withValues(alpha: 0.8),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}