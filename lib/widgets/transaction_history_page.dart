import 'package:flutter/material.dart';
import 'transaction_records_page.dart'; // Ensure this matches your filename

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Primary green color from your branding
    const Color telebirrGreen = Color(0xFF8DC73F);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light grey background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: null,
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
            onPressed: () {
              // Context menu action
            },
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
          _buildMenuCard(
            context: context,
            imagePath: 'images/db.jpg', // Your custom image
            title: 'Transaction Records',
            iconColor: Colors.black,
            imageWidth: 37, // Adjust width as needed
            imageHeight: 37, // Adjust height as needed
            onTap: () {
              // Navigates to the records list we just created
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TransactionRecordsPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 10), // Thin visual break
          _buildMenuCard(
            context: context,
            imagePath: 'images/receipt.jpg', // Your custom image
            title: 'Mini Statement',
            iconColor: Colors.black,
            imageWidth: 50, // Adjust width as needed
            imageHeight: 50, // Adjust height as needed
            onTap: () {
              // Future implementation for Mini Statement
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    String? imagePath,
    IconData? icon,
    required String title,
    required Color iconColor,
    double imageWidth = 40,
    double imageHeight = 40,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Use Image if imagePath is provided, otherwise use Icon
              if (imagePath != null)
                Container(
                  width: imageWidth,
                  height: imageHeight,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  ),
                )
              else if (icon != null)
                Icon(icon, color: iconColor, size: 40),
              
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w200,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
