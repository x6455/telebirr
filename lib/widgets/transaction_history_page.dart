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
            icon: Icons.paid_outlined, // Icon representing 'Transaction Records'
            title: 'Transaction Records',
            iconColor: telebirrGreen,
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
          const SizedBox(height: 2), // Thin visual break
          _buildMenuCard(
            context: context,
            icon: Icons.receipt_long_outlined, // Icon representing 'Mini Statement'
            title: 'Mini Statement',
            iconColor: telebirrGreen,
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
    required IconData icon,
    required String title,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      // Padding removed from margin to make it look like a list item
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(icon, color: iconColor, size: 32),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.black26,
          size: 14,
        ),
        onTap: onTap,
      ),
    );
  }
}
