import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OfflineLoyaltyOfferWidget extends StatelessWidget {
  const OfflineLoyaltyOfferWidget({super.key});

  
  final int totalDaysNeeded = 10;
  final String offerDetail = 'FREE Delivery and a small Gift!';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          
          gradient: LinearGradient(
            colors: [
              Colors.deepOrange.shade400, 
              Colors.deepOrange.shade700,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '🏅 Customer Loyalty Card Offer!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.receipt_long, 
                  color: Colors.white,
                  size: 28,
                ),
              ],
            ),
            const Divider(color: Colors.white70, height: 20),

            
            Text(
              'Collect a stamp on your loyalty card with every purchase!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),

    
            Text(
              '🎉 Complete all $totalDaysNeeded stamps to unlock:',
              style: TextStyle(
                color: Colors.amberAccent,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 5),
            
            
            Row(
              children: [
                Icon(Icons.stars, color: Colors.amberAccent, size: 20),
                const SizedBox(width: 8),
                Text(
                  offerDetail,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Don\'t forget  stamp on your Loyalty Card!',
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}