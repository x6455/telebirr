import 'package:flutter/material.dart';
import 'transaction_records_page.dart';

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Transaction History',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.cancel_outlined, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

   _MenuCard(
  imagePath: 'images/db.jpg',
  title: 'Transaction Records',
  imageWidth: 33,  // Image width only
  imageHeight: 33, // Image height only
  cardHeight: 80,  // Button/card height
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TransactionRecordsPage(),
      ),
    );
  },
),

const SizedBox(height: 10),

_MenuCard(
  imagePath: 'images/receipt.jpg',
  title: 'Mini Statement',
  imageWidth: 50,  // Larger image
  imageHeight: 50, // Larger image
  cardHeight: 80,  // Same button/card height
  onTap: () {
    // TODO: Implement Mini Statement
  },
),       
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final double? imageWidth;
  final double? imageHeight;
  final double? cardHeight;
  final VoidCallback onTap;

  const _MenuCard({
    required this.imagePath,
    required this.title,
    required this.onTap,
    this.imageWidth,
    this.imageHeight,
    this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: onTap,
        child: Container(
          height: cardHeight ?? 80, // Default card height is 80
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              SizedBox(
                width: imageWidth,
                height: imageHeight,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
