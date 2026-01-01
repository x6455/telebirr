import 'package:flutter/material.dart';

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light grey background from screenshot
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
          _buildMenuCard(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Transaction Records',
            onTap: () {
              // Handle Navigation to Records
            },
          ),
          const SizedBox(height: 2), // Small gap between cards
          _buildMenuCard(
            icon: Icons.receipt_long_outlined,
            title: 'Mini Statement',
            onTap: () {
              // Handle Navigation to Statement
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF8DC73F), size: 30),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.black26,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}
