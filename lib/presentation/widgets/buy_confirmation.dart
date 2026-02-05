import 'package:flutter/material.dart';

class BuyConfirmation extends StatelessWidget {
  final String avatarTitle;
  final int coinAmount;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const BuyConfirmation({
    super.key,
    required this.avatarTitle,
    required this.coinAmount,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: isTablet ? 400 : 320,
        padding: EdgeInsets.all(isTablet ? 24 : 20),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
          border: Border.all(
            color: Colors.blue.withValues(alpha: 0.6),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withValues(alpha: 0.3),
              blurRadius: isTablet ? 12 : 8,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: isTablet ? 8 : 6,
              offset: Offset(0, isTablet ? 4 : 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              'پشتڕاستکردنەوەی کڕین',
              style: TextStyle(
                color: Colors.white,
                fontSize: isTablet ? 22 : 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Kurdish',
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: isTablet ? 20 : 16),
            
            // Avatar info
            Container(
              padding: EdgeInsets.all(isTablet ? 16 : 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
                border: Border.all(
                  color: Colors.blue.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    avatarTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Kurdish',
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                  SizedBox(height: isTablet ? 12 : 8),
                  
                  // Price display
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 16 : 12,
                      vertical: isTablet ? 8 : 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                      border: Border.all(
                        color: Colors.amber.shade700,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.monetization_on,
                          color: Colors.amber.shade700,
                          size: isTablet ? 20 : 18,
                        ),
                        SizedBox(width: isTablet ? 8 : 6),
                        Text(
                          coinAmount.toString(),
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: isTablet ? 16 : 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Kurdish',
                          ),
                        ),
                        SizedBox(width: isTablet ? 8 : 6),
                        Text(
                          'کۆین',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: isTablet ? 14 : 12,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Kurdish',
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: isTablet ? 24 : 20),
            
            // Confirmation text
            Text(
              'ئایا دڵنیایت لە کڕینی ئەم کەسایەتییە؟',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: isTablet ? 16 : 14,
                fontFamily: 'Kurdish',
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            
            SizedBox(height: isTablet ? 24 : 20),
            
            // Buttons
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: GestureDetector(
                    onTap: onCancel,
                    child: Container(
                      height: isTablet ? 50 : 44,
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
                        border: Border.all(
                          color: Colors.red.withValues(alpha: 0.6),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'پاشگەزبوونەوە',
                          style: TextStyle(
                            color: Colors.red.shade300,
                            fontSize: isTablet ? 16 : 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Kurdish',
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ),
                  ),
                ),
                
                SizedBox(width: isTablet ? 16 : 12),
                
                // Confirm button
                Expanded(
                  child: GestureDetector(
                    onTap: onConfirm,
                    child: Container(
                      height: isTablet ? 50 : 44,
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
                        border: Border.all(
                          color: Colors.amber.shade700,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'پشتڕاستکردنەوە',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: isTablet ? 16 : 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Kurdish',
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}